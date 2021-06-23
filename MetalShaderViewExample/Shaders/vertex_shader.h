//
//  vertex_shader.h
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#ifndef vertex_shader_h
#define vertex_shader_h

struct VertexOut {
    float4 position [[position]];
    float3 color;
    float u_time;
    float2 u_resolution;
    float2 u_mouse;
};

float3 hsb2rgb(float3 c);

#endif /* vertex_shader_h */
