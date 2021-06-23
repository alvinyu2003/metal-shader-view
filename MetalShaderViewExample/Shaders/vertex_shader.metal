//
//  vertex_shader.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

vertex VertexOut vertex_main(device const float4 *positionBuffer [[buffer(0)]],
                             device const float3 *colorBuffer [[buffer(1)]],
                             constant float &timer [[buffer(2)]],
                             constant float2 &resolution [[buffer(3)]],
                             constant float2 &touchCoord [[buffer(4)]],
                             uint vertexId [[vertex_id]]) {
  VertexOut out {
    .position = positionBuffer[vertexId],
    .color = colorBuffer[vertexId],
    .u_time = timer,
    .u_resolution = resolution,
    .u_mouse = touchCoord
  };
  return out;
}

//  Function from Iñigo Quiles
//  https://www.shadertoy.com/view/MsS3Wc
float3 hsb2rgb(float3 c) {
    float3 rgb = clamp( abs( fmod( c.x*6.0+float3(0.0,4.0,2.0) , 6.0) -3.0) -1.0, 0.0, 1.0 );
    rgb = rgb*rgb*(3.0-2.0*rgb);
    return c.z * mix(float3(1.0), rgb, c.y);
}
