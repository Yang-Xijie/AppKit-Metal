import Metal
import MetalKit
import XCLog

class RenderView: MTKView {
    var renderViewDelegate: RenderViewDelegate!

    convenience init() {
        self.init(frame: .zero) // should not call `self.init()` which will call `convenience init()` and go into a infinite loop

        // MARK: device

        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            XCLog(.fatal, "Metal is not supported on this device")
            fatalError()
        }
        device = defaultDevice

        // MARK: render method

        preferredFramesPerSecond = 60
        isPaused = false
        enableSetNeedsDisplay = false
        autoResizeDrawable = false

        // MARK: delegate

        guard let tempRenderer = RenderViewDelegate(renderView: self) else {
            XCLog(.fatal, "Renderer failed to initialize")
            fatalError()
        }
        renderViewDelegate = tempRenderer
        delegate = renderViewDelegate
    }
}
