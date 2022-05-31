import Cocoa
import Metal
import MetalKit

class MainView: NSView {
    private var renderView: MTKView!

    convenience init() {
        self.init(frame: .zero)

        renderView = RenderView()

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
