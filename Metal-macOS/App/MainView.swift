import Cocoa
import Metal
import MetalKit
import XCLog

class MainView: NSView {
    var renderView: MTKView!
    var renderViewDelegate: RenderViewDelegate!

    convenience init() {
        self.init(frame: .zero)

        renderView = {
            let rv = MTKView()

            // MARK: device

            guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
                XCLog(.fatal, "Metal is not supported on this device")
                fatalError()
            }
            rv.device = defaultDevice

            // MARK: render method

            rv.preferredFramesPerSecond = 60
            rv.isPaused = false
            rv.enableSetNeedsDisplay = false
            rv.autoResizeDrawable = false

            // MARK: delegate

            guard let tempRenderer = RenderViewDelegate(renderView: rv) else {
                XCLog(.fatal, "Renderer failed to initialize")
                fatalError()
            }
            renderViewDelegate = tempRenderer // neccessary
            rv.delegate = renderViewDelegate

            return rv
        }()
        addSubview(renderView)
        renderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            renderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            renderView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            renderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
        ])
    }
}
