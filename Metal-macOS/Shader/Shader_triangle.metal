#include <metal_stdlib>
#include "ShaderDefinitions.h"
using namespace metal;

struct VertexOut {
	MetalPosition4 position[[position]];
	MetalRGBA color;
};

vertex VertexOut
vertexShader_triangle(
	const device Vertex2D *vertexArray[[buffer(0)]],
	unsigned int vid[[vertex_id]]){
	// MARK: get data from buffers

	Vertex2D in = vertexArray[vid];

	// MARK: return

	VertexOut out = VertexOut();
	out.position = MetalPosition4(in.position.x, in.position.y, 0, 1);
	out.color =  in.color;
	return out;
}

fragment MetalRGBA
fragmentShader_triangle(
	VertexOut in[[stage_in]]) {
	return in.color;
}
