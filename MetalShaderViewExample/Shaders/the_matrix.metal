//
//  the_matrix.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

float random(float2 _st) {
    return fract(sin(dot(_st.xy, float2(12.9898,78.233)))* 43758.5453123);
}

float rchar(float2 outer, float2 inner) {
    float grid = 5.;
    float2 margin = float2(.2,.05);
    float seed = 23.;
    float2 borders = step(margin,inner)*step(margin,1.-inner);
    return step(.5,random(outer*seed+floor(inner*grid))) * borders.x * borders.y;
}

float3 rand_matrix(float2 st, float u_time) {
    float rows = 80.0;
    float2 ipos = floor(st*rows);

    ipos += float2(.0,floor(u_time*20.*random(ipos.x)));


    float2 fpos = fract(st*rows);
    float2 center = (.5-fpos);

    float pct = random(ipos);
    float glow = (1.-dot(center,center)*3.)*2.0;

    // float3 color = float3(0.643,0.851,0.690) * ( rchar(ipos,fpos) * pct );
    // color +=  float3(0.027,0.180,0.063) * pct * glow;
    return float3(rchar(ipos,fpos) * pct * glow);
}

fragment float4 the_matrix(VertexOut in [[stage_in]]) {
    float u_time = in.u_time;
    float2 u_resolution = in.u_resolution;
    float2 st = in.position.xy / u_resolution;

    st.y *= u_resolution.y/u_resolution.x;
    float3 color = float3(0.0);

    color = rand_matrix(st, u_time);
    return float4( 1.-color , 1.0);
}
