import Foundation

let test_color = MetalRGBA(Float(0x66) / 255, Float(0xCC) / 255, Float(0xFF) / 255, 1)

class RenderData {
    static let shared = RenderData()

    var triangles: [Triangle] = [Triangle(pointA: VertexIn(position: MetalPosition2(0, 0),
                                                           color: test_color),
                                          pointB: VertexIn(position: MetalPosition2(-1, 0),
                                                           color: test_color),
                                          pointC: VertexIn(position: MetalPosition2(0, 1),
                                                           color: test_color)),
                                 Triangle(pointA: VertexIn(position: MetalPosition2(0, 0),
                                                           color: test_color),
                                          pointB: VertexIn(position: MetalPosition2(1, 0),
                                                           color: test_color),
                                          pointC: VertexIn(position: MetalPosition2(0, -1),
                                                           color: test_color)),
    ]

    var vertices: [VertexIn] {
        var result: [VertexIn] = []
        _ = triangles.map({ triangle in
            result.append(contentsOf: triangle.vertices)
        })
        return result
    }
}

struct Triangle {
    var pointA: VertexIn
    var pointB: VertexIn
    var pointC: VertexIn
    var vertices: [VertexIn] {
        [pointA, pointB, pointC]
    }
}
