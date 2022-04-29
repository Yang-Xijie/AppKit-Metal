import Cocoa

class MainWindow: NSWindow {
    private var mainView: MainView!

    convenience init() {
        self.init(contentRect: NSRect(origin: .zero,
                                      size: NSSize(width: 400 * 1.414, height: 400)),
                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                  backing: .buffered,
                  defer: true)
        title = "Main Window"

        mainView = MainView()
        contentView = mainView
    }
}
