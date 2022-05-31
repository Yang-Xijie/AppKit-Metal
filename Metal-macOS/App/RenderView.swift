import Cocoa
import Metal
import MetalKit
import XCLog

class RenderView: MTKView {
    private var renderViewDelegate: RenderViewDelegate!

    convenience init() {
        self.init(frame: .zero) // should not call `self.init()` which will call `convenience init()` and go into a infinite loop

        // MARK: Metal Setup - device

        if let defaultDevice = MTLCreateSystemDefaultDevice() {
            device = defaultDevice
        } else {
            XCLog(.fatal, "Metal is not supported on this device")
            fatalError()
        }

        // MARK: Metal - delegate

        if let tempRenderer = RenderViewDelegate(renderView: self) {
            renderViewDelegate = tempRenderer
            delegate = renderViewDelegate
        } else {
            XCLog(.fatal, "Renderer failed to initialize")
            fatalError()
        }

        // MARK: Metal - config

        isPaused = false
        enableSetNeedsDisplay = false
        preferredFramesPerSecond = CONFIG.RENDER.default_fps
        autoResizeDrawable = true // 和机器的缩放比例相适应
    }
}
