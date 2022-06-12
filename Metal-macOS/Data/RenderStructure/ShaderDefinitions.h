#ifndef ShaderDefinitions_h
#define ShaderDefinitions_h

#include <simd/simd.h>

typedef vector_float2 MetalPosition2;
typedef vector_float4 MetalPosition4;
typedef vector_float4 MetalRGBA;

struct Vertex2D {
    MetalPosition2 position;
    MetalRGBA color;
};

#endif /* ShaderDefinitions_h */
