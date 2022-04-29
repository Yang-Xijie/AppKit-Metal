#include <metal_stdlib>
#include "ShaderDefinitions.h"
using namespace metal;

struct VertexOut {
	MetalPosition4 position[[position]];
	MetalRGBA color;
};

/// draw triangleStrips with a single color
vertex VertexOut
vertexShader_drawTriangleStripWithSingleColor(
	const device VertexIn *vertexArray[[buffer(0)]],
    unsigned int vid[[vertex_id]]){

	// MARK: get data from buffers

	VertexIn in = vertexArray[vid];

	// MARK: return

	VertexOut out = VertexOut();
	out.position = MetalPosition4(in.position.x, in.position.y, 0, 1);
	out.color =  in.color;
	return out;
}

// check `5.2.3.4 Fragment Function Input Attributes`
fragment MetalRGBA
fragmentShader_drawTriangleStripWithSingleColor(
	VertexOut in[[stage_in]]) {
	return in.color;
}
