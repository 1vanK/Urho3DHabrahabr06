#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"

varying vec2 vScreenPos;

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    vScreenPos = GetScreenPosPreDiv(gl_Position);
}

void PS()
{
    #ifdef GL3
        float c = texture2D(sDiffMap, vScreenPos).r;
    #else
        float c = texture2D(sDiffMap, vScreenPos).a;
    #endif

    gl_FragColor = vec4(c, c, c, 1.0);
}
