import Foundation
import Metal
import MetalKit
import XCLog

class RenderViewDelegate: NSObject, MTKViewDelegate {
    // MARK: members

    private let renderView: MTKView!
    private let device: MTLDevice!
    private let commandQueue: MTLCommandQueue!
    private let pipelineState: MTLRenderPipelineState
    // flight
    private let MAX_FRAMES_IN_FLIGHT = 3
    private var vertexBufferIndex = 0
    private var vertexBuffer: [MTLBuffer] = []

    init?(renderView: MTKView) {
        // MARK: setup

        self.renderView = renderView
        device = renderView.device!
        commandQueue = device.makeCommandQueue()!
        do {
            pipelineState = try buildRenderPipelineWith(
                device: device, metalKitView: renderView,
                vertexFuncName: "vertexShader_drawTriangles",
                fragmentFuncName: "fragmentShader_drawTriangles"
            )
        } catch {
            XCLog(.fatal, "Unable to compile render pipeline state: \(error)")
            fatalError()
        }

        // MARK: preapare data

        for _ in 0 ..< MAX_FRAMES_IN_FLIGHT {
            // TODO: 这里应该给够内存 虽然刚刚好也是够
            vertexBuffer.append(
                device.makeBuffer(length: RenderData.shared.vertices.count * MemoryLayout<VertexIn>.stride)!)
        }
    }

    // MARK: draw

    func draw(in view: MTKView) {
        vertexBufferIndex = (vertexBufferIndex + 1) % MAX_FRAMES_IN_FLIGHT

        // MARK: -

        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }

        // MARK: -

        // FIXME: 这一部分的代码每帧都要吗？感觉加载一下数据就可以了
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1) // white background
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }

        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setTriangleFillMode(.fill)

        // MARK: -

        // FIXME: 如果输入的点不变的话其实是没必要更新的 如果点数要变的话 地址空间的大小也要变的
        let currentVertexBufferAddr = vertexBuffer[vertexBufferIndex].contents()
        let currentVertexBufferData = RenderData.shared.vertices
        currentVertexBufferAddr.initializeMemory(as: VertexIn.self, from: currentVertexBufferData, count: RenderData.shared.vertices.count)
        renderEncoder.setVertexBuffer(vertexBuffer[vertexBufferIndex],
                                      offset: 0,
                                      index: 0)

        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: RenderData.shared.vertices.count)
        renderEncoder.endEncoding()

        // MARK: -

        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}
}
