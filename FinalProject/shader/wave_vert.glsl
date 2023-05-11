#version 400

layout (location = 0 ) in vec3 VertexPosition;
layout (location = 1) in vec3 VertexNormal;
layout (location = 2) in vec2 VertexTexCoord;

out vec4 Position;
out vec3 Normal;
out vec3 waveNormal;
out vec4 wavePos;
out vec2 TexCoord;

uniform float Time;
uniform float Freq = 1.5;
uniform float Velocity = 3.5;
uniform float Amp = 0.1;
uniform float dist;

uniform mat4 ModelViewMatrix;
uniform mat3 NormalMatrix;
uniform mat4 MVP;

uniform bool isGround;
uniform bool isSphere;


void main()
{
    vec4 pos = vec4(VertexPosition, 1.0);
    if (!isSphere){
        float u = Freq * ((pos.x * pos.x) + (pos.z * pos.z)) - Velocity * Time;
        float v = Freq * pos.z * pos.z - Velocity * Time;

        pos.y = Amp * sin(u/5.0f);


        vec3 n = vec3(0.0);
        if (isGround){
            n.xy = normalize(vec2(cos(u/5.0f), 1.0));
        } else {
            n.xy = normalize(vec2(cos(u/5.0f), 1.0));
        }

        if (!isGround){
            Position = ModelViewMatrix * pos;
            Normal = NormalMatrix * n;
            TexCoord = VertexTexCoord;
            gl_Position = MVP * pos;
        } else {
            Position = ModelViewMatrix * pos;
            Normal = NormalMatrix * vec3(0,1,0);
            waveNormal = NormalMatrix * n;
            wavePos = pos;
            TexCoord = VertexTexCoord;
            gl_Position = MVP * vec4(VertexPosition,1.0f);
        }
    }
    else {
        Position = ModelViewMatrix * vec4(VertexPosition,1.0);
        Normal = NormalMatrix * VertexNormal;
        TexCoord = VertexTexCoord;
        gl_Position = MVP * vec4(VertexPosition,1.0);
    }
}
