//
//  sin_red.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

fragment float4 sin_red(VertexOut in [[stage_in]]) {
    return float4(float3(1.0, 0.0, 0.0) * abs(sin(in.u_time)), 1);
}
