import Foundation

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
