import Foundation
import Metal
import MetalKit

func buildRenderPipelineWith(device: MTLDevice,
                             renderView: MTKView,
                             vertexShaderName: String,
                             fragmentShadername: String)
    throws -> MTLRenderPipelineState {
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    if let library = device.makeDefaultLibrary() {
        pipelineDescriptor.vertexFunction = library.makeFunction(name: vertexShaderName)
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: fragmentShadername)
    } else { fatalError() }
    pipelineDescriptor.colorAttachments[0].pixelFormat = renderView.colorPixelFormat
    return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
}
