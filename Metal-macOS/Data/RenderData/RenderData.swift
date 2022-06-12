import Foundation

let test_color = MetalRGBA(Float(0x66) / 255, Float(0xCC) / 255, Float(0xFF) / 255, 1)

var RENDER_DATA = RenderData()

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
