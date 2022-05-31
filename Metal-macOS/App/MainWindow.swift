import Cocoa
import XCLog

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
        collectionBehavior = [.managed, .fullScreenPrimary, .fullScreenDisallowsTiling]
        contentAspectRatio = NSSize(width: CONFIG.WINDOW.width_height_ratio,
                                    height: CGFloat(1.0))
        contentMinSize = NSSize(width: CONFIG.WINDOW.min_height * CONFIG.WINDOW.width_height_ratio,
                                height: CONFIG.WINDOW.min_height)
        // setting `contentMaxSize` instead of `maxFullScreenContentSize` is better
        if NSScreen.main!.frame.size.width / NSScreen.main!.frame.size.height >= CONFIG.WINDOW.width_height_ratio {
            contentMaxSize = NSSize(width: NSScreen.main!.frame.size.height * CONFIG.WINDOW.width_height_ratio,
                                    height: NSScreen.main!.frame.size.height)
        } else {
            contentMaxSize = NSSize(width: NSScreen.main!.frame.size.width,
                                    height: NSScreen.main!.frame.size.width / CONFIG.WINDOW.width_height_ratio)
        }
    }

    override func toggleFullScreen(_: Any?) {
        XCLog("Entered full screen.")
        super.toggleFullScreen(self) // FIXME: pause rendering before enter full screen and continue rendering after full screen, or there will be frame overlapping
    }
}
