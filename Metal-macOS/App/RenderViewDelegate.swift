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

    // MARK: 渲染管线 - 有动画的三角形

    private let pipelineState_animatedTriangle: MTLRenderPipelineState
    // CPU和GPU共享的内存
    private var buffer_animatedTriangle: [MTLBuffer] = []

    init?(renderView: MTKView) {
        commandQueue = renderView.device!.makeCommandQueue()!

        // 编译这两个shader为GPU可以直接执行的机器码 只需要编译一次
        pipelineState_triangle = try! buildRenderPipelineWith(
            device: renderView.device!, renderView: renderView,
            vertexShaderName: "vertexShader_triangle",
            fragmentShadername: "fragmentShader_triangle"
        )

        pipelineState_animatedTriangle = try! buildRenderPipelineWith(
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
                    length: MemoryLayout<Vertex2D>.stride * RENDER_DATA.triangles.vertices.count,
                    options: [.storageModeShared]
                )!
            )
            buffer_animatedTriangle.append(
                renderView.device!.makeBuffer(
                    // 注意一开始应该给够内存
                    length: MemoryLayout<Vertex2D>.stride * 100,
                    options: [.storageModeShared]
                )!)
        }
    }

    // MARK: draw

    func draw(in renderView: MTKView) {
        // MARK: - 准备

        // flight
        bufferIndex = (bufferIndex + 1) % MAX_FRAMES_IN_FLIGHT

        let commandBuffer = commandQueue.makeCommandBuffer()!

        // MARK: - 渲染一种类型的数据: 三角形

        // MTLRenderPassDescriptor: A group of render targets that hold the results of a render pass.
        // currentRenderPassDescriptor: Creates a render pass descriptor to draw into the current drawable.
        let renderPassDescriptor_triangle = renderView.currentRenderPassDescriptor!
        // white background
        renderPassDescriptor_triangle.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 0.0)
        renderPassDescriptor_triangle.colorAttachments[0].loadAction = .clear // important, or previous frame will exist
        renderPassDescriptor_triangle.colorAttachments[0].storeAction = .dontCare

        // A MTLRenderCommandEncoder object provides methods to set up and perform a single graphics rendering pass.
        let renderEncoder_triangle = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor_triangle)!
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

        // MARK: - 渲染一种类型的数据: 有动画的三角形

        // MTLRenderPassDescriptor: A group of render targets that hold the results of a render pass.
        // currentRenderPassDescriptor: Creates a render pass descriptor to draw into the current drawable.
        let renderPassDescriptor_animatedTriangle = renderView.currentRenderPassDescriptor!
        // white background
        renderPassDescriptor_animatedTriangle.colorAttachments[0].loadAction = .load // important, when set to `.clear`, previous RenderEncoders will take no effects
        renderPassDescriptor_animatedTriangle.colorAttachments[0].storeAction = .dontCare

        // A MTLRenderCommandEncoder object provides methods to set up and perform a single graphics rendering pass.
        let renderEncoder_animatedTriangle = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor_animatedTriangle)!
        renderEncoder_animatedTriangle.setRenderPipelineState(pipelineState_animatedTriangle)
        renderEncoder_animatedTriangle.setTriangleFillMode(.fill)

        // 从程序中取到需要渲染的数据
        let currentBufferData_animatedTriangle = RENDER_DATA.triangles_animated.vertices
        let vertexCount_animatedTriangle = RENDER_DATA.triangles_animated.vertices.count
        // 拿到CPU和GPU共享的buffer的地址
        let currentBufferAddr_animatedTriangle = buffer_animatedTriangle[bufferIndex].contents()
        // 将数据装进共享内存
        currentBufferAddr_animatedTriangle.initializeMemory(as: Vertex2D.self, from: currentBufferData_animatedTriangle, count: vertexCount_animatedTriangle)
        renderEncoder_animatedTriangle.setVertexBuffer(buffer_animatedTriangle[bufferIndex],
                                                       offset: 0,
                                                       index: 0)

        renderEncoder_animatedTriangle.drawPrimitives(type: .triangle,
                                                      vertexStart: 0,
                                                      vertexCount: vertexCount_animatedTriangle)
        renderEncoder_animatedTriangle.endEncoding()
        RENDER_DATA.triangles_animated.presentOneFrame()

        // MARK: - 提交当前帧

        commandBuffer.present(renderView.currentDrawable!)
        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}
}
