Shader "FN_Unlit/TransFrom_TRS"
{
    Properties
    {
        _MainTex                            ("Texture", 2D)         = "white" {}
        [Toggle(OnTranslate)]   _OnTranslate("OnTranslate",float)   = 0;
        [Toggle(OnRotate)]      _OnRotate   ("OnRotate", float)     = 0;
        [Toggle(OnScale)]       _OnScale    ("OnScale", float)      = 0;

        _Translate                          ("Translate",float)     = (0,0,0,0)
        _Rotate                             ("Rotate",  float)      = (0, 0, 0, 0)
        _Scale                              ("Scale",   float )     = (0, 0, 0, 0)

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4          vertex   : POSITION;
                float2          uv       : TEXCOORD0;
            };
            struct v2f
            {
                float2          uv       : TEXCOORD0;
                float4          vertex   : SV_POSITION;
            };

            sampler2D           _MainTex;
            float4              _MainTex_ST;

            float               _OnTranslate;
            float               _OnRotate;
            float               _OnScale;

            float2              _Translate;
            float               _Rotate;
            float               _Scale;

            v2f vert (appdata v)
            {
                v2f             o;
                o.vertex        = UnityObjectToCipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(o.uv);
                return          o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
            }
            ENDCG
        }
    }
}
