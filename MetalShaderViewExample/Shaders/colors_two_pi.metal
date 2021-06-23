//
//  colors_two_pi.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

#define TWO_PI 6.28318530718

fragment float4 colors_two_pi(VertexOut in [[stage_in]]) {
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    float3 color = float3(0.0);

    // Use polar coordinates instead of cartesian
    float2 toCenter = float2(0.5)-st;
    float angle = atan2(toCenter.y,toCenter.x);
    float radius = length(toCenter)*2.0;

    // Map the angle (-PI to PI) to the Hue (from 0 to 1)
    // and the Saturation to the radius
    color = hsb2rgb(float3((angle/TWO_PI)+0.5,radius,1.0));

    return float4(color, 1.0);
}
