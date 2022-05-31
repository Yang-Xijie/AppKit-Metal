import Cocoa

class MainWindow: NSWindow {
    // MARK: - members

    private var mainView: MainView!

    convenience init() {
        self.init(contentRect: NSRect(origin: .zero,
                                      size: NSSize(width: CONFIG.WINDOW.default_height * CONFIG.WINDOW.width_height_ratio,
                                                   height: CONFIG.WINDOW.default_height)),
                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                  backing: .buffered,
                  defer: true)

        mainView = MainView()
        contentView = mainView

        title = CONFIG.WINDOW.title
        contentMinSize = NSSize(width: CONFIG.WINDOW.min_height * CONFIG.WINDOW.width_height_ratio,
                                height: CONFIG.WINDOW.min_height)
        contentAspectRatio = NSSize(width: CONFIG.WINDOW.width_height_ratio,
                                    height: CGFloat(1.0))
    }
}
