Shader "FN_Unlit/FU_3D_OffsetAndBlast"
{
    Properties
    {
        _MainTex                ("Texture", 2D)                 = "white" {}
        _MainColor              ("MainColor",COLOR)             = (1,1,1,1)
        _Offset                 ("Offse",Float)                 = 1
    }
    SubShader
    {
        Tags { "RenderType" ="  Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
                float3 normal   : NORMAL;
            };

            struct v2f
            {
                float2 uv       : TEXCOORD0;
                float4 vertex   : SV_POSITION;
            };

            sampler2D           _MainTex;
            fixed4              _MainColor;
            float4              _MainTex_ST;
            float               _Offset;

            v2f vert (appdata v)
            {
                v2f             o;
                v.vertex.xyz    += v.normal * _Offset;
                o.vertex        = UnityObjectToClipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(v.uv, _MainTex);

                return          o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv) * _MainColor;
            }
            ENDCG 
        }
    }
            FallBack "Diffuse"
}
