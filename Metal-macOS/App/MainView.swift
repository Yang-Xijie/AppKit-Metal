import Cocoa
import Metal
import MetalKit
import XCLog

class MainView: NSView {
    var renderView: MTKView!
    var renderViewDelegate: RenderViewDelegate!

    convenience init() {
        self.init(frame: .zero)
        wantsLayer = true
        layer?.backgroundColor = CGColor(red: CGFloat(0x66) / 255,
                                         green: CGFloat(0xCC) / 255,
                                         blue: CGFloat(0xFF) / 255,
                                         alpha: 1.0)

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
            rv.isPaused = false // No need for `rv.preferredFramesPerSecond = 120`. It will be automatically decided by device.
            rv.enableSetNeedsDisplay = false // when Apple Pencil or finger strokes, call `draw()` to render a drawable
            rv.autoResizeDrawable = false // set `renderView.drawableSize` by ourselves
            rv.presentsWithTransaction = false

            // MARK: delegate

            guard let tempRenderer = RenderViewDelegate(renderView: rv) else {
                XCLog(.fatal, "Renderer failed to initialize")
                fatalError()
            }
            renderViewDelegate = tempRenderer // neccessary
            rv.delegate = renderViewDelegate

            return rv
        }()
        // not `view.addSubView()` because the scrollView should be on the top to recieve user's gesture
        // notice: renderView.frame is relative to scrollContentView
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
