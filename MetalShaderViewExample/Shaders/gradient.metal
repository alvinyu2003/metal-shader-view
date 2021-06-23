//
//  gradient.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

fragment float4 gradient(VertexOut in [[stage_in]]) {
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    return float4(st.x, st.y, 0.0, 1.0);
}
