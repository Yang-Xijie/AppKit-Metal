import Cocoa

enum CONFIG {
    enum WINDOW {
        static let width_height_ratio = CGFloat(16.0 / 9.0) // FIXME: full screen will corrupt this ratio
        static let default_height = CGFloat(360.0)
        static let min_height = CGFloat(180.0)
        static let title = "Metal macOS"
    }
}
