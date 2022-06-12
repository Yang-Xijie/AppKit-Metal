import Foundation

struct AnimatedTriangle {
    var triangle: Triangle
    var frameLeft: Int

    static func createFourSurroundingTriangles(center: MetalPosition2, size: Float = 0.1, color: MetalRGBA = test_color, frameLeft: Int = 30) -> [Self] {
        var result: [Self] = []
        result.append(contentsOf: [
            Self(triangle: Triangle(pointA: Vertex2D(position: center, color: color),
                                    pointB: Vertex2D(position: MetalPosition2(center.x - size / 2.0, center.y + size / 2.0 * sqrt(3)), color: color),
                                    pointC: Vertex2D(position: MetalPosition2(center.x + size / 2.0, center.y + size / 2.0 * sqrt(3)), color: color)),
                 frameLeft: frameLeft),
            Self(triangle: Triangle(pointA: Vertex2D(position: center, color: color),
                                    pointB: Vertex2D(position: MetalPosition2(center.x - size / 2.0, center.y - size / 2.0 * sqrt(3)), color: color),
                                    pointC: Vertex2D(position: MetalPosition2(center.x + size / 2.0, center.y - size / 2.0 * sqrt(3)), color: color)),
                 frameLeft: frameLeft),
            Self(triangle: Triangle(pointA: Vertex2D(position: center, color: color),
                                    pointB: Vertex2D(position: MetalPosition2(center.x - size / 2.0 * sqrt(3), center.y + size / 2.0), color: color),
                                    pointC: Vertex2D(position: MetalPosition2(center.x - size / 2.0 * sqrt(3), center.y - size / 2.0), color: color)),
                 frameLeft: frameLeft),
            Self(triangle: Triangle(pointA: Vertex2D(position: center, color: color),
                                    pointB: Vertex2D(position: MetalPosition2(center.x + size / 2.0 * sqrt(3), center.y + size / 2.0), color: color),
                                    pointC: Vertex2D(position: MetalPosition2(center.x + size / 2.0 * sqrt(3), center.y - size / 2.0), color: color)),
                 frameLeft: frameLeft),
        ])

        return result
    }
}

extension Array where Element == AnimatedTriangle {
    var vertices: [Vertex2D] {
        var result: [Vertex2D] = []
        _ = self.map { triangle_animated in
            result.append(contentsOf: triangle_animated.triangle.vertices)
        }
        return result
    }

    mutating func presentOneFrame() {
        for i in 0 ..< self.count {
            self[i].frameLeft -= 1
        }
        self.removeAll {
            $0.frameLeft == 0
        }
    }
}
