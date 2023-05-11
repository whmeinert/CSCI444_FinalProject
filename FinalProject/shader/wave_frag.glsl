#version 400

uniform struct LightInfo {
    vec4 Position;
    vec3 Intensity;
} Light;

uniform struct MaterialInfo {
    vec3 Ka;
    vec3 Kd;
    vec3 Ks;
    float Shininess;
} Material;

uniform float alpha;

in vec4 Position;
in vec3 Normal;
in vec2 TexCoord;
in vec3 waveNormal;
in vec4 wavePos;

uniform sampler2D texture1;

uniform float Time;

uniform bool isGround;

layout ( location = 0 ) out vec4 FragColor;

vec3 phongModel(vec3 kd) {
    vec3 n = Normal;
    vec3 s = normalize(Light.Position.xyz - Position.xyz);
    vec3 v = normalize(-Position.xyz);
    vec3 r = reflect( -s, n );
    float sDotN = max( dot(s,n), 0.0 );
    vec3 diffuse = Light.Intensity * kd * sDotN;
    vec3 spec = vec3(0.0);
    if( sDotN > 0.0 )
    spec = Light.Intensity * Material.Ks *
    pow( max( dot(r,v), 0.0 ), Material.Shininess );

    return Material.Ka * Light.Intensity + diffuse + spec;
}

vec4 caustic() {
    vec3 E = Normal;
    vec3 N = waveNormal;
    float n1 = 1.333;
    float n2 = 1.0003;


    vec3 T = N*((n1/n2)*dot(E,N)-sqrt(1+(pow(n1/n2, 2))*(pow(dot(E, N),2)-1)))+((n1/n2)*(E));


    vec3 lineP = Position.xyz;
    vec3 lineN = normalize(T);
    float planeD = -0.050;
    float distance = (planeD - lineP.z) / lineN.z;
    vec3 intercept = lineP + lineN * distance;
    vec4 color = texture(texture1, (intercept.xy*(-planeD)));


    T = N*((n1/n2)*(E*N)+sqrt(1+(pow(n1/n2, 2))*(pow(dot(E, N),2)-1)))+((n1/n2)*(E));
    lineN = normalize(T);
    intercept = lineP + lineN * distance;

    color += texture(texture1, (intercept.xy*(-planeD)));;
    return color;
}

void main()
{
    vec3 Color;
    if (!isGround){
        FragColor = vec4(phongModel(Material.Kd), 1.0f);
    } else {
        Color = phongModel(Material.Kd);
        //FragColor = vec4(mix(vec3(29/255.0f,162/255.0f,216/255.0f), Color, 0.80f),1.0f);
        FragColor = mix(caustic(), vec4(Color,1.0),0.50);

    }
}
