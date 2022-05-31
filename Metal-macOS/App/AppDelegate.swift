import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - members

    private var mainWindow: MainWindow!

    // MARK: - behaviors

    func applicationDidFinishLaunching(_: Notification) {
        mainWindow = MainWindow()
        mainWindow.makeKeyAndOrderFront(self)
        mainWindow.center()
    }

    func applicationWillTerminate(_: Notification) {
        XCLog("Quit.")
    }

    // MARK: config

    func applicationSupportsSecureRestorableState(_: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
