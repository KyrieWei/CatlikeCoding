Shader "Custom/RenderingFiveLighting"
{
    Properties
    {
        _Tint ("Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Albedo", 2D) = "white" {}
        _Smoothness ("Smoothness", Range(0, 1)) = 0.5
        [Gamma] _Metallic ("Metallic", Range(0, 1)) = 0
        [Toggle(_AdditionalLights)] _AdditionalLights ("Additional lights", Float) = 1
    }

        


    SubShader
    {
        

        Pass
        {

            Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline" "LightMode" = "UniversalForward" }


            HLSLPROGRAM

            #pragma target 3.0

            #pragma vertex vert
            #pragma fragment frag

            #include "myLighting.hlsl"

            #pragma shader_feature _AdditionalLights

            ENDHLSL
        }

    }
}
