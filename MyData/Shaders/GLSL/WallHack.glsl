#include "Uniforms.glsl"
#include "Samplers.glsl"
#include "Transform.glsl"
#include "ScreenPos.glsl"

varying vec2 vTexCoord;

void VS()
{
    mat4 modelMatrix = iModelMatrix;
    vec3 worldPos = GetWorldPos(modelMatrix);
    gl_Position = GetClipPos(worldPos);
    vTexCoord = GetQuadTexCoord(gl_Position);
}

void PS()
{
    vec3 viewport = texture2D(sDiffMap, vTexCoord).rgb;

    #ifdef GL3
        float fullmask = texture2D(sNormalMap, vTexCoord).r;
        float visiblemask = texture2D(sSpecMap, vTexCoord).r;
    #else
        float fullmask = texture2D(sNormalMap, vTexCoord).a;
        float visiblemask = texture2D(sSpecMap, vTexCoord).a;
    #endif

    if (fullmask == 0.0 || visiblemask > 0.0)
        gl_FragColor = vec4(viewport, 1.0);
    else   
        gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
}
