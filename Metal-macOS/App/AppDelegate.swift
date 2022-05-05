import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - members

    private var mainWindow: MainWindow!

    // MARK: - behaviors

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        mainWindow = MainWindow()
        mainWindow.makeKeyAndOrderFront(self)
        mainWindow.center()
    }

    func applicationWillTerminate(_ aNotification: Notification) { }

    // MARK: config

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
