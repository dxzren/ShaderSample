Shader "FN_Unlit/FU_3D_NoiseMelt"
{
    Properties
    {
        _MainTex                ("Texture", 2D)                 = "white" {}
        _DissTex                ("DissTex", 2D)                 = "white"{}
        _EdgeColor              ("EdgeColor",Color)             = (1,1,1,1)
        _DissValue              ("DissValue",Range(0,1.2))      = 0

        _EdgeValue              ("EdgeValue",Range(0,1))        = 0.1
    }
    SubShader
    {
        Tags { "RenderType" =   "Opaque" }
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
            sampler2D           _DissTex;
            float4              _MainTex_ST;
            float4              _DissTex_ST;

            float               _DissValue;
            float               _EdgeValue;
            fixed4              _EdgeColor;



            v2f vert (appdata v)
            {
                v2f             o;
                o.vertex        = UnityObjectToClipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(v.uv, _MainTex);
                return          o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4          aTexColor                       = tex2D(_MainTex,i.uv);
                fixed4          aDissColor                      = tex2D(_DissTex,i.uv);
                if (_DissValue < 0.1)
                {
                   _DissValue                                   += _Time.x * 0.5;
                }
                else
                {
                    _DissValue                                  += _Time.y;
                }

                if (aDissColor.g < _DissValue)
                {
                    discard;
                }
                float           aLerpValure                     = _DissValue / aDissColor.r;                         // ¹ý¶É±ßÔµ

                if (aLerpValure <1 && aLerpValure >(1 - _EdgeValue))
                {
                    return                                      _EdgeColor;
                }
                return          aTexColor;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
