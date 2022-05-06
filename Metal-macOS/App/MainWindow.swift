import Cocoa

class MainWindow: NSWindow {
    // MARK: - members

    private var mainView: MainView!

    convenience init() {
        self.init(contentRect: NSRect(origin: .zero,
                                      size: Self.defaultContentSize),
                  styleMask: [.titled, .closable, .miniaturizable, .resizable],
                  backing: .buffered,
                  defer: true)

        mainView = MainView()
        contentView = mainView

        title = Self.windowTitle
        contentMinSize = Self.minContentSize
        contentAspectRatio = Self.defaultContentSize
    }

    // MARK: - config

    private static let windowTitle = "Metal macOS"

    private static let contentWidthHeightRatio = CGFloat(16.0 / 9.0)

    private static let defaultContentHeight = CGFloat(360.0)
    private static let defaultContentSize = NSSize(width: defaultContentHeight * contentWidthHeightRatio,
                                                   height: defaultContentHeight)
    private static let minContentHeight = CGFloat(180.0)
    private static let minContentSize = NSSize(width: minContentHeight * contentWidthHeightRatio,
                                               height: minContentHeight)
}
