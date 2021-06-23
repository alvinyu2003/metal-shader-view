//
//  gray_noise.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

float random(float2 st, float time) {
    return fract(sin(dot(st.xy, float2(12.9898 * time, 78.233 * time))) * 43758.5453123);
}

fragment float4 gray_noise(VertexOut in [[stage_in]]) {
    float u_time = in.u_time;
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    float rnd = random(st, u_time);
    float4 fragColor = float4(float3(rnd), 1.0);
    return fragColor;
}
