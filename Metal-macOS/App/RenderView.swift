import Cocoa
import Metal
import MetalKit
import XCLog

class RenderView: MTKView {
    private var renderViewDelegate: RenderViewDelegate!
    
    convenience init(){
        self.init()
        

        // MARK: device

        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            XCLog(.fatal, "Metal is not supported on this device")
            fatalError()
        }
        self.device = defaultDevice

        // MARK: render method

        self.preferredFramesPerSecond = 60
        self.isPaused = false
        self.enableSetNeedsDisplay = false

        // MARK: delegate

        guard let tempRenderer = RenderViewDelegate(renderView: self) else {
            XCLog(.fatal, "Renderer failed to initialize")
            fatalError()
        }
        renderViewDelegate = tempRenderer // neccessary
        self.delegate = renderViewDelegate
    }
}
