Shader "Chapter4/Chapter4_Surface"
{
    Properties
    {
        
    }
    SubShader
    {
        Tags { "RenderType"= "Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 vertex : POSITION;
                //float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct Varyings
            {
                //float2 uv : TEXCOORD0;
                half4 color : COLOR;
                float4 vertex : SV_POSITION;
            };


            Varyings vert (Attributes IN)
            {
                Varyings OUT;
                OUT.vertex = TransformObjectToHClip(IN.vertex.xyz);
                //OUT.uv = IN.uv;
                OUT.color = half4(IN.color.rgb, IN.color.a);
                return OUT;
            }

            half4 frag(Varyings input) : SV_Target
            {
                return input.color;
            }
            ENDHLSL
        }
    }
}

