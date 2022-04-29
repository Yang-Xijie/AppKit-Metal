import Foundation
import Metal
import MetalKit
import XCLog

class RenderViewDelegate: NSObject, MTKViewDelegate {
    let renderView: MTKView!

    let device: MTLDevice
    let commandQueue: MTLCommandQueue

    let pipelineState_drawTriangleStripWithSingleColor: MTLRenderPipelineState

    init?(renderView: MTKView) {
        self.renderView = renderView

        device = renderView.device!
        commandQueue = device.makeCommandQueue()!

        do {
            pipelineState_drawTriangleStripWithSingleColor = try buildRenderPipelineWith(
                device: device, metalKitView: renderView,
                vertexFuncName: "vertexShader_drawTriangles",
                fragmentFuncName: "fragmentShader_drawTriangles"
            )
        } catch {
            XCLog(.fatal, "Unable to compile render pipeline state: \(error)")
            return nil
        }

        for _ in 0 ..< MaxFramesInFlight {
            vertexBuffer.append(device.makeBuffer(bytes: RenderData.shared.vertices,
                                                  length: RenderData.shared.vertices.count * MemoryLayout<VertexIn>.stride,
                                                  options: [])!)
        }
    }

    // flight
    let MaxFramesInFlight = 3
    var _currentBuffer = 0
    var vertexBuffer: [MTLBuffer] = []

    // MARK: draw

    func draw(in view: MTKView) {
        _currentBuffer = (_currentBuffer + 1) % MaxFramesInFlight

        // MARK: preparation

        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1) // white background
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }

        // MARK: create data

        // MARK: create buffer and set draw primitive

        renderEncoder.setRenderPipelineState(pipelineState_drawTriangleStripWithSingleColor)
        renderEncoder.setTriangleFillMode(.fill)

        let currentVertexBufferAddr = vertexBuffer[_currentBuffer].contents()
        let currentVertexBufferData = RenderData.shared.vertices
        currentVertexBufferAddr.initializeMemory(as: VertexIn.self, from: currentVertexBufferData, count: RenderData.shared.vertices.count)

        renderEncoder.setVertexBuffer(vertexBuffer[_currentBuffer],
                                      offset: 0,
                                      index: 0)

        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: RenderData.shared.vertices.count)

        // MARK: commit

        renderEncoder.endEncoding()
        commandBuffer.present(view.currentDrawable!)
        commandBuffer.commit()
    }

    func mtkView(_: MTKView, drawableSizeWillChange _: CGSize) {}
}
