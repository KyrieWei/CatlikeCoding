Shader "Graph/pointSurface"
{
    Properties
    {

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalRenderPipeline" }
      
        pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
            };


            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float4 positionWS : TEXCOORD0;
            };

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                OUT.positionHCS = TransformObjectToHClip(IN.positionOS.xyz);
                OUT.positionWS = mul(unity_ObjectToWorld, IN.positionOS);

                return OUT;
            }

            half4 frag(Varyings input) : SV_Target
            {
                half4 col = saturate(input.positionWS * 0.5 + 0.5);
                return col;
            }


            ENDHLSL
        }
    }
    //FallBack "Diffuse"
}
