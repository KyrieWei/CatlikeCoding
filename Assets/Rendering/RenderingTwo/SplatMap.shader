Shader "Custom/Texture Splatting"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        [NoScaleOffset] _Texture1("Texture 1", 2D) = "white" {}
        [NoScaleOffset] _Texture2("Texture 2", 2D) = "white" {}
        [NoScaleOffset] _Texture3("Texture 3", 2D) = "white" {}
        [NoScaleOffset] _Texture4("Texture 4", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _Texture1, _Texture2, _Texture3, _Texture4;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;                
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uvSplat : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uvSplat = v.uv;
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                half4 splat = tex2D(_MainTex, i.uvSplat);
                return tex2D(_Texture1, i.uv) * splat.r + 
                       tex2D(_Texture2, i.uv) * splat.g +
                       tex2D(_Texture3, i.uv) * splat.b +
                       tex2D(_Texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
            }
            ENDHLSL
        }
    }
}
