//
//  animated_gradient.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

fragment float4 animated_gradient(VertexOut in [[stage_in]]) {
    float u_time = in.u_time;
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    st.x *= u_resolution.x/u_resolution.y;
    float3 color = float3(0.0);
    color = float3(st.x,st.y,abs(sin(u_time)));
    return float4(color, 1.0);
}
