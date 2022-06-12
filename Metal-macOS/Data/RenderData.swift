import Foundation

let test_color = MetalRGBA(Float(0x66) / 255, Float(0xCC) / 255, Float(0xFF) / 255, 1)

let RENDER_DATA = RenderData()

struct RenderData {
    var triangles: [Triangle] = [Triangle(pointA: Vertex2D(position: MetalPosition2(0, 0),
                                                           color: test_color),
                                          pointB: Vertex2D(position: MetalPosition2(-1, 0),
                                                           color: test_color),
                                          pointC: Vertex2D(position: MetalPosition2(0, 1),
                                                           color: test_color)),
                                 Triangle(pointA: Vertex2D(position: MetalPosition2(0, 0),
                                                           color: test_color),
                                          pointB: Vertex2D(position: MetalPosition2(1, 0),
                                                           color: test_color),
                                          pointC: Vertex2D(position: MetalPosition2(0, -1),
                                                           color: test_color))]
    var triangles_animated: [AnimatedTriangle] = []
}

struct AnimatedTriangle {
    var triangle: Triangle
    var frameLeft: Int = 30
}

struct Triangle {
    // properties
    var pointA: Vertex2D
    var pointB: Vertex2D
    var pointC: Vertex2D

    // funcs
    var vertices: [Vertex2D] {
        return [pointA, pointB, pointC]
    }
}

extension Array where Element == Triangle {
    var vertices: [Vertex2D] {
        var result: [Vertex2D] = []
        _ = self.map { triangle in
            result.append(contentsOf: triangle.vertices)
        }
        return result
    }
}
