Shader "FN_Unlit/TransFrom_TRS_Anim"
{
    Properties
    {
        _MainTex                            ("Texture", 2D)         = "white" {}
        [Toggle(OnTranslate)]   _OnTranslate("OnTranslate",float)   = 0
        [Toggle(OnRotate)]      _OnRotate   ("OnRotate", float)     = 0
        [Toggle(OnScale)]       _OnScale    ("OnScale", float)      = 0

        _Translate                          ("Translate",float)     = (0,0,0,0)
        _Rotate                             ("Rotate",  float)      = 0
        _Scale                              ("Scale",   float )     = 1
        _TimeShow                           ("TimeShow ",float)     = 0
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

            float4              _Translate;
            float               _Rotate;
            float               _Scale;
            float               _TimeShow;

            v2f vert (appdata v)
            {
                v2f             o;
                o.vertex                            = UnityObjectToClipPos(v.vertex); 
                o.uv                                = TRANSFORM_TEX(v.uv, _MainTex);
                return          o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2          aUv                 = i.uv;

                if (_OnTranslate)
                {
                    aUv                             += _Time.y*_Translate;
                }
                if (_OnRotate)
                {
                    float       aRad                = _Rotate * 0.017453292519943295;
                    aRad                            += aRad * _Time.y;
                    aUv                             -= float2(0.5, 0.5);
                    aUv                             = float2(aUv.x * cos(aRad) - aUv.y * sin(aRad), aUv.x * sin(aRad) + aUv.y * cos(aRad));
                    aUv                             += float2(0.5, 0.5);
                }
                if (_OnScale)
                {
                    aUv                             -= float2(0.5, 0.5);
                    aUv                             *= _Scale * _Time.y;
                    aUv                             += float2(0.5, 0.5);
                }
                _TimeShow                           = _Time.y;
                return          tex2D(_MainTex, aUv);
            }
            ENDCG
        }
    }
}
