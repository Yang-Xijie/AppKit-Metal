import Cocoa
import Metal
import MetalKit
import XCLog

class MainView: NSView {
    private var renderView: MTKView!
    var mouseLocation: NSPoint? { self.window?.mouseLocationOutsideOfEventStream }

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

        // `addTrackingArea` not work because view doesn't finish loading when being initializing
        NSEvent.addLocalMonitorForEvents(matching: [.mouseMoved]) {
            self.mouseMoved(with: $0)
            return $0
        }
    }

    override func mouseDown(with _: NSEvent) {
        guard let mousePoint = self.mouseLocation else {
            XCLog(.error, ErrorDescription.cannot_get_mouse_location)
            return
        }

        XCLog("\(normalizedPosition(from: mousePoint))")
        RENDER_DATA.triangles_animated.append(contentsOf:
            AnimatedTriangle.createFourSurroundingTriangles(center: normalizedPosition(from: mousePoint)))
    }

    override func rightMouseDown(with _: NSEvent) {
        guard let mousePoint = self.mouseLocation else {
            XCLog(.error, ErrorDescription.cannot_get_mouse_location)
            return
        }

        XCLog("\(normalizedPosition(from: mousePoint))")
    }

    override func mouseMoved(with _: NSEvent) {
        guard let mousePoint = self.mouseLocation else {
            XCLog(.error, ErrorDescription.cannot_get_mouse_location)
            return
        }

        if mousePoint.isInside(rect: self.frame) {
            XCLog("\(normalizedPosition(from: mousePoint))")
        }
    }

    private func normalizedPosition(from screenPoint: NSPoint) -> simd_float2 {
        let screenPosition3 = simd_float3(Float(screenPoint.x), Float(screenPoint.y), 1.0)
        let tranformMatrix3x3 = simd_float3x3(rows: [
            simd_float3(2.0 / Float(frame.width), 0.0, -1),
            simd_float3(0.0, 2.0 / Float(frame.height), -1),
            simd_float3(0.0, 0.0, 1),
        ])
        let normalizedPosition3 = simd_mul(tranformMatrix3x3, screenPosition3)
        return simd_float2(normalizedPosition3.x, normalizedPosition3.y)
    }
}
