import Foundation
import Metal
import MetalKit
import XCLog

class RenderViewDelegate: NSObject, MTKViewDelegate {
    // MARK: members

    private let commandQueue: MTLCommandQueue!
    private let pipelineState_triangles: MTLRenderPipelineState
    // flight
    private let MAX_FRAMES_IN_FLIGHT = 3
    private var vertexBufferIndex = 0
    private var vertexBuffer: [MTLBuffer] = []

    init?(renderView: MTKView) {
        // MARK: setup

        commandQueue = renderView.device!.makeCommandQueue()!

        pipelineState_triangles = try! buildRenderPipelineWith(
            device: renderView.device!, metalKitView: renderView,
            vertexFuncName: "vertexShader_drawTriangles",
            fragmentFuncName: "fragmentShader_drawTriangles"
        )

        // MARK: preapare data

        for _ in 0 ..< MAX_FRAMES_IN_FLIGHT {
            // TODO: 这里应该给够内存 虽然刚刚好也是够
            vertexBuffer.append(
                renderView.device!.makeBuffer(
                    length: RenderData.shared.vertices.count * MemoryLayout<VertexIn>.stride,
                    options: [.storageModeShared]
                )!
            )
        }
    }

    // MARK: draw

    func draw(in renderView: MTKView) {
        vertexBufferIndex = (vertexBufferIndex + 1) % MAX_FRAMES_IN_FLIGHT

        // MARK: -

        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }

        // MARK: -

        // FIXME: 这一部分的代码每帧都要吗？感觉加载一下数据就可以了
        guard let renderPassDescriptor = renderView.currentRenderPassDescriptor else { return }
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1.0, 1.0, 1.0, 1.0) // white background
        guard let renderEncoder_triangles = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }

        renderEncoder_triangles.setRenderPipelineState(pipelineState_triangles)
        renderEncoder_triangles.setTriangleFillMode(.fill)

        // MARK: -

        // FIXME: 如果输入的点不变的话其实是没必要更新的 如果点数要变的话 地址空间的大小也要变的
        let currentVertexBufferAddr = vertexBuffer[vertexBufferIndex].contents()
        let currentVertexBufferData = RenderData.shared.vertices
        currentVertexBufferAddr.initializeMemory(as: VertexIn.self, from: currentVertexBufferData, count: RenderData.shared.vertices.count)
        renderEncoder_triangles.setVertexBuffer(vertexBuffer[vertexBufferIndex],
                                                offset: 0,
                                                index: 0)

        renderEncoder_triangles.drawPrimitives(type: .triangle,
                                               vertexStart: 0,
                                               vertexCount: RenderData.shared.vertices.count)
        renderEncoder_triangles.endEncoding()

        // MARK: -

        commandBuffer.present(renderView.currentDrawable!)
        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}
}
