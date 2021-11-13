Shader "FN_Unlit/3D_NoiseWaterAnim"
{
    Properties
    {
        _MainColor              ("MainColor",COLOR)             = (1,1,1,1)
        _MainTex                ("MainTex", 2D)                 = "white" {}
        _NoiseTex               ("NoiseTex",2D)                 = "white" {}
        _OffsetX                ("OffsetX",Range(0,1))          = 0
        _OffsetY                ("OffsetY",Range(0,1))          = 0
    }
    SubShader
    {
        Tags     { "RenderType" =   "Opaque" }
        LOD                     100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag

            #include "UnityCG.cginc"

            struct              appdata
            {
                float4          vertex  : POSITION;
                float2          uv      : TEXCOORD0;
            };
            struct              v2f
            {
                float2          uv      : TEXCOORD0;
                float4          vertex  : SV_POSITION;
            };

            sampler2D           _MainTex;
            sampler2D           _NoiseTex;
            float4              _MainTex_ST;

            fixed4              _MainColor;
            float               _OffsetX;
            float               _OffsetY;

            v2f vert (appdata v)
            {
                v2f             o;
                float           aWidth                          = distance(v.vertex.x,float(0));
                v.vertex.y                                      = sin(aWidth + _Time.y)/3;
                
                o.vertex                                        = UnityObjectToClipPos(v.vertex);
                o.uv                                            = TRANSFORM_TEX(v.uv,_MainTex);
                return          o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4          aNoiseColor                     = tex2D(_NoiseTex,i.uv);
                float2          aOffset_uv;                 
                aOffset_uv                                      = float2 (0.5 +_Time.y, 0.5 +_OffsetX);
                aOffset_uv                                      = (aNoiseColor + _OffsetX * _Time.y,aNoiseColor + _OffsetY * _Time.y*0.4);

                return          tex2D(_MainTex,aOffset_uv) * _MainColor;

            }
            ENDCG
        }
    }
    FallBack "DIFFUSE"
}
