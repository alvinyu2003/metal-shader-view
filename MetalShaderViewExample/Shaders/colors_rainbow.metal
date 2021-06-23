//
//  colors_rainbow.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

fragment float4 colors_rainbow(VertexOut in [[stage_in]]) {
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    float3 color = hsb2rgb(float3(st.x,1.0,st.y));
    return float4(color, 1.0);
}
