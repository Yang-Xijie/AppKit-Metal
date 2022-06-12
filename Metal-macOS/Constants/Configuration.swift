import Cocoa

enum CONFIG {
    enum WINDOW {
        static let width_height_ratio = CGFloat(1.0)
        static let default_height = CGFloat(800.0)
        static let min_height = CGFloat(100.0)
        static let title = "Metal macOS"
    }

    enum RENDER {
        static let default_fps = 30
    }
}
