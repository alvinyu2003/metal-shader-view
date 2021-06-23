//
//  cells.metal
//  MetalShaderViewExample
//
//  Created by Alvin Yu on 6/22/21.
//

#include <metal_stdlib>
using namespace metal;
#include "vertex_shader.h"

fragment float4 cells(VertexOut in [[stage_in]]) {
    float2 u_resolution = in.u_resolution;
    float2 u_mouse = in.u_mouse;
    float2 st = in.position.xy / u_resolution;

    st.x *= u_resolution.x/u_resolution.y;

    float3 color = float3(.0);

    // Cell positions
    float2 point[5];
    point[0] = float2(0.83,0.75);
    point[1] = float2(0.60,0.07);
    point[2] = float2(0.28,0.64);
    point[3] =  float2(0.31,0.26);
    point[4] = u_mouse/u_resolution;

    float m_dist = 1.;  // minimum distance

    // Iterate through the points positions
    for (int i = 0; i < 5; i++) {
        float dist = distance(st, point[i]);

        // Keep the closer distance
        m_dist = min(m_dist, dist);
    }

    // Draw the min distance (distance field)
    color += m_dist;

    // Show isolines
    // color -= step(.7,abs(sin(50.0*m_dist)))*.3;

    return float4(color,1.0);
}
