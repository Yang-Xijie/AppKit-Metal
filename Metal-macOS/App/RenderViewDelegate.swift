import Foundation
import Metal
import MetalKit
import XCLog

class RenderViewDelegate: NSObject, MTKViewDelegate {
    // MARK: 通用

    private let commandQueue: MTLCommandQueue!

    // flight: 一帧的时间内 CPU准备数据放到`buffer[n+1]` GPU运算使用`buffer[n]` 这样互不影响
    private let MAX_FRAMES_IN_FLIGHT = 3
    private var bufferIndex = 0

    // MARK: 渲染管线 - 三角形

    private let pipelineState_triangle: MTLRenderPipelineState
    // CPU和GPU共享的内存
    private var buffer_triangle: [MTLBuffer] = []

    init?(renderView: MTKView) {
        commandQueue = renderView.device!.makeCommandQueue()!

        // 编译这两个shader为GPU可以直接执行的机器码 只需要编译一次
        pipelineState_triangle = try! buildRenderPipelineWith(
            device: renderView.device!, renderView: renderView,
            vertexShaderName: "vertexShader_triangle",
            fragmentShadername: "fragmentShader_triangle"
        )

        // 分配需要CPU和GPU共享的内存空间
        for _ in 0 ..< MAX_FRAMES_IN_FLIGHT {
            buffer_triangle.append(
                // 这里只指定长度就够了 后面在每帧动态修改其中的数据
                renderView.device!.makeBuffer(
                    // 注意一开始应该给够内存
                    length: RENDER_DATA.triangles.vertices.count * MemoryLayout<Vertex2D>.stride,
                    options: [.storageModeShared]
                )!
            )
        }
    }

    // MARK: draw

    func draw(in renderView: MTKView) {
        // MARK: - 准备

        // flight
        bufferIndex = (bufferIndex + 1) % MAX_FRAMES_IN_FLIGHT

        // MTLRenderPassDescriptor: A group of render targets that hold the results of a render pass.
        // currentRenderPassDescriptor: Creates a render pass descriptor to draw into the current drawable.
        let renderPassDescriptor = renderView.currentRenderPassDescriptor!
        // white background
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0)

        let commandBuffer = commandQueue.makeCommandBuffer()!

        // MARK: - 渲染一种类型的数据

        // A MTLRenderCommandEncoder object provides methods to set up and perform a single graphics rendering pass.
        let renderEncoder_triangle = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder_triangle.setRenderPipelineState(pipelineState_triangle)
        renderEncoder_triangle.setTriangleFillMode(.fill)

        // 从程序中取到需要渲染的数据
        let currentBufferData_triangle = RENDER_DATA.triangles.vertices
        let vertexCount_triangle = RENDER_DATA.triangles.vertices.count
        // 拿到CPU和GPU共享的buffer的地址
        let currentBufferAddr_triangle = buffer_triangle[bufferIndex].contents()
        // 将数据装进共享内存
        currentBufferAddr_triangle.initializeMemory(as: Vertex2D.self, from: currentBufferData_triangle, count: vertexCount_triangle)
        renderEncoder_triangle.setVertexBuffer(buffer_triangle[bufferIndex],
                                               offset: 0,
                                               index: 0)

        renderEncoder_triangle.drawPrimitives(type: .triangle,
                                              vertexStart: 0,
                                              vertexCount: vertexCount_triangle)
        renderEncoder_triangle.endEncoding()

        // MARK: - 提交当前帧

        commandBuffer.present(renderView.currentDrawable!)
        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}
}
