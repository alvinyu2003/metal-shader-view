//
//  wobbly_shape.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

float2 random2(float2 st) {
    st = float2( dot(st,float2(127.1,311.7)),
              dot(st,float2(269.5,183.3)) );
    return -1.0 + 2.0*fract(sin(st)*43758.5453123);
}

float noise(float2 st) {
    float2 i = floor(st);
    float2 f = fract(st);

    float2 u = f*f*(3.0-2.0*f);

    return mix( mix( dot( random2(i + float2(0.0,0.0) ), f - float2(0.0,0.0) ),
                     dot( random2(i + float2(1.0,0.0) ), f - float2(1.0,0.0) ), u.x),
                mix( dot( random2(i + float2(0.0,1.0) ), f - float2(0.0,1.0) ),
                     dot( random2(i + float2(1.0,1.0) ), f - float2(1.0,1.0) ), u.x), u.y);
}

half2x2 rotate2d(float _angle){
    return half2x2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float shape(float2 st, float radius, float u_time) {
    st = float2(0.5)-st;
    float r = length(st)*2.0;
    float a = atan2(st.y,st.x);
    float m = abs(fmod(a+u_time*2.,3.14*2.)-3.14)/3.6;
    float f = radius;
    m += noise(st+u_time*0.1)*.5;
    // a *= 1.+abs(atan(u_time*0.2))*.1;
    // a *= 1.+noise(st+u_time*0.1)*0.1;
    f += sin(a*50.)*noise(st+u_time*.2)*.1;
    f += (sin(a*20.)*.1*pow(m,2.));
    return 1.-smoothstep(f,f+0.007,r);
}

float shapeBorder(float2 st, float radius, float width, float u_time) {
    return shape(st,radius, u_time)-shape(st,radius-width, u_time);
}

fragment float4 wobbly_shape(VertexOut in [[stage_in]]) {
    float u_time = in.u_time;
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    float3 color = float3(1.0) * shapeBorder(st,0.8,0.02, u_time);
    return float4( 1.-color, 1.0 );
}
