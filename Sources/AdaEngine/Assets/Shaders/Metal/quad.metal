#include <metal_stdlib>
using namespace metal;

struct Uniforms {
    float4x4 view;
};

struct QuadVertex {
    float4 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float2 textureCoordinate [[ attribute(2) ]];
    int textureIndex [[ attribute(3) ]];
};

struct QuadVertexOut {
    float4 position [[ position ]];
    float4 color;
    float2 textureCoordinate;
    int textureIndex;
};

vertex QuadVertexOut quad_vertex(const QuadVertex vertexIn [[ stage_in ]], constant Uniforms &ubo [[ buffer(1) ]]) {
    float4 position = ubo.view * vertexIn.position;
    
    QuadVertexOut out {
        .position = position,
        .color = vertexIn.color,
        .textureCoordinate = vertexIn.textureCoordinate,
        .textureIndex = vertexIn.textureIndex
    };
    
    return out;
}

fragment float4 quad_fragment(QuadVertexOut in [[stage_in]],
                              array<texture2d<half>, 32> textures [[ texture(0) ]],
                              sampler textureSampler [[ sampler(0) ]]
                              ) {
    
    const half4 colorSample = textures[in.textureIndex].sample(textureSampler, in.textureCoordinate);
    const float4 resultColor = float4(colorSample) * in.color;
    
    // to avoid depth write
    if (resultColor.a == 0.0) {
        discard_fragment();
    }
    
    return resultColor;
}

