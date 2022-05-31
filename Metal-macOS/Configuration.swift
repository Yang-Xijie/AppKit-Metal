import Cocoa

enum CONFIG {
    enum WINDOW {
        static let width_height_ratio = CGFloat(16.0 / 9.0)
        static let default_height = CGFloat(1080 / 2)
        static let min_height = CGFloat(1080 / 8)
        static let title = "Metal macOS"
    }

    enum RENDER {
        static let default_fps = 30
    }
}
