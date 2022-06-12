import Cocoa

extension NSPoint {
    func isInside(rect: NSRect) -> Bool {
        return self.x > 0 && self.x < rect.width && self.y > 0 && self.y < rect.height
    }
}
