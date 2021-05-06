Shader "Chapter4/HashShader"
{
    Properties
    {
       
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalRenderPipeline"}
        LOD 100

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #pragma instancing_options assumeuniformscaling procedural:ConfigureProcedural
            #pragma editor_sync_compilation
            

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "../Common/HashFunction.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };
            
            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                
                return OUT;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half3 color = GetHashColor();
                return half4(color, 1.0);
            }

            ENDHLSL
        }
    }
}
