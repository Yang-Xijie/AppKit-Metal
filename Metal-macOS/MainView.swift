import Cocoa

class MainView: NSView {
    convenience init() {
        self.init(frame: .zero)
        wantsLayer = true
        layer?.backgroundColor = .init(red: CGFloat(0x66) / 255, green: CGFloat(0xCC) / 255, blue: CGFloat(0xFF) / 255, alpha: 1.0)
    }
}
