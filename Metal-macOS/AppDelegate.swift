import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: MainWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window = MainWindow()
        window.makeKeyAndOrderFront(self)
        window.center()
    }

    func applicationWillTerminate(_ aNotification: Notification) {}

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }
}
