Shader "FN_Unlit/FU_3D_SinAxisWave"
{
    Properties
    {
        _MainTex                ("Texture", 2D)                 = "white" {}
    }
    SubShader
    {
        Tags        { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4          vertex  : POSITION;
                float2          uv      : TEXCOORD0;
            };

            struct v2f
            {
                float2          uv      : TEXCOORD0;
                float4          vertex  : SV_POSITION;
            };

            sampler2D           _MainTex;
            float4              _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f             o;
                v.vertex.y      = sin(v.vertex.z + _Time.y * 2);
                o.vertex        = UnityObjectToClipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(v.uv, _MainTex);
                return          o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return          tex2D(_MainTex,i.uv);
            }
            ENDCG
        }
    }
}
