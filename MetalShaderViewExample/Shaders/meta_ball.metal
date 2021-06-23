//
//  meta_ball.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

float smoothen(float d1, float d2) {
    float k = 1.5;
    return -log(exp(-k * d1) + exp(-k * d2)) / k;
}

fragment float4 meta_ball(VertexOut in [[stage_in]]) {
    float u_time = in.u_time;
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    float2 p0 = float2(cos(u_time) * 0.3 + 0.5, 0.5);
    float2 p1 = float2(-cos(u_time) * 0.3 + 0.5, 0.5);
    float d = smoothen(distance(st, p0) * 5.0, distance(st, p1) * 5.0);
    float ae = 5.0 / u_resolution.y;
    float3 color = float3(smoothstep(0.8, 0.8+ae, d));
    return float4(color, 1.0);
}
