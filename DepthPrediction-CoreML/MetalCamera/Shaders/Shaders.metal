#include <metal_stdlib>
using namespace metal;

struct Vertex {
    float4 position [[position]];
    float2 text_coord;
};

struct TwoInputVertex
{
    float4 position [[position]];
    float2 textureCoordinate [[user(texturecoord)]];
    float2 textureCoordinate2 [[user(texturecoord2)]];
};

struct Uniforms {
    float4x4 scaleMatrix;
};

vertex Vertex vertex_render_target(constant Vertex *vertexes [[ buffer(0) ]],
                                   constant Uniforms &uniforms [[ buffer(1) ]],
                                   uint vid [[vertex_id]])
{
    Vertex out = vertexes[vid];
    out.position = uniforms.scaleMatrix * out.position;// * in.position;
    return out;
};


fragment float4 fragment_render_target(Vertex vertex_data [[ stage_in ]],
                                       texture2d<float> tex2d [[ texture(0) ]])
{
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    float4 color = float4(tex2d.sample(textureSampler, vertex_data.text_coord));
    return color;
};

fragment float4 gray_fragment_render_target(Vertex vertex_data [[ stage_in ]],
                                            texture2d<float> tex2d [[ texture(0) ]])
{
    constexpr sampler textureSampler(mag_filter::linear, min_filter::linear);
    float4 color = float4(tex2d.sample(textureSampler, vertex_data.text_coord));
    float gray = (color[0] + color[1] + color[2])/3;
    return float4(gray, gray, gray, 1.0);
};

typedef struct
{
    float depth;
} DepthmapValue;

typedef struct
{
    int32_t width;
    int32_t height;
} DepthmapUniform;

fragment float4 depthmap_render_target(Vertex vertex_data [[ stage_in ]],
                                           constant DepthmapValue *depthmap [[ buffer(0) ]],
                                           constant DepthmapUniform& uniform [[ buffer(1) ]])

{
    int index = int(vertex_data.position.x) + int(vertex_data.position.y) * uniform.width;
    float depthValue = 1.0 - depthmap[index].depth;
    return float4(depthValue, depthValue, depthValue, 1);
};

