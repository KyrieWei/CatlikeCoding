#ifndef MY_LIGHTING_INCLUDED
#define MY_LIGHTING_INCLUDED

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

struct appdata
{
    float4 vertex : POSITION;
    float3 normal : NORMAL;
    float2 uv : TEXCOORD0;
};

struct v2f
{               
    float4 vertex : SV_POSITION;
    float2 uv : TEXCOORD0;
    float3 normal : TEXCOORD1;
    float3 worldPos : TEXCOORD2;
};

sampler2D _MainTex;
float4 _MainTex_ST;
float4 _Tint;
float _Metallic;
float _Smoothness;

v2f vert (appdata v)
{
    v2f o;
    o.vertex = TransformObjectToHClip(v.vertex);
    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.normal = TransformObjectToWorldNormal(v.normal);
    o.worldPos = mul(unity_ObjectToWorld, v.vertex);
    return o;
}

half4 frag (v2f i) : SV_Target
{
    i.normal = normalize(i.normal);
                
    Light light = GetMainLight();

    float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

    float3 albedo = tex2D(_MainTex, i.uv).rgb * _Tint.rgb;
                
    albedo *= light.color;

    float3 specularTint;
    float oneMinusReflectivity;

    half alpha = 0;

    //albedo = DiffuseAndSpecularFromMetallic(
				//	albedo, _Metallic, specularTint, oneMinusReflectivity
				//);
    half4 unity_ColorSpaceDielectricSpec = half4(0.04, 0.04, 0.04, 1 - 0.04);

    specularTint = lerp(half3(0.04, 0.04, 0.04), albedo, _Metallic);
    half oneMinusDielectricSpec = unity_ColorSpaceDielectricSpec.a;    
    oneMinusReflectivity = oneMinusDielectricSpec - _Metallic * oneMinusDielectricSpec;
    albedo *= oneMinusReflectivity;

    BRDFData brdfData;
    InitializeBRDFData(albedo, _Metallic, specularTint, _Smoothness, alpha, brdfData);

    half3 col = DirectBRDF(brdfData, i.normal, light.direction, viewDir);

    #ifdef _AdditionalLights
        uint lightCount = GetAdditionalLightsCount();
        for(uint lightIndex = 0u; lightIndex < lightCount; lightIndex ++)
        {
            light = GetAdditionalLight(lightIndex, i.worldPos);
            
            albedo *= light.color;
            InitializeBRDFData(albedo, _Metallic, specularTint, _Smoothness, alpha, brdfData);

            col += DirectBRDF(brdfData, i.normal, light.direction, viewDir);
        }
    #endif

    return half4(col, 1);
}


#endif
