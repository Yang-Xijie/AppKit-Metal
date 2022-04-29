import Cocoa

class MainWindow: NSWindow {
    private var mainView: MainView!

    convenience init() {
        self.init(contentRect: .zero,
                  styleMask: [.titled, .closable, .miniaturizable],
                  backing: .buffered,
                  defer: true)
        title = "Main Window"
        setFrameOrigin(.zero)
        setContentSize(NSSize(width: 400 * 1.414, height: 400))

        mainView = MainView()
        contentView = mainView
    }
}
