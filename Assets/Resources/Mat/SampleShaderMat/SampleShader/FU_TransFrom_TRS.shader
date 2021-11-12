Shader "FN_Unlit/TransFrom_TRS"
{
    Properties
    {
        _MainTex                ("Texture", 2D)                     = "white" {}
        [Toggle]  _OnTranslate  ("OnTranslate",Float)               = 0
        [Toggle]  _OnRotate     ("OnRotate",Float)                  = 0
        [Toggle]  _OnScale      ("OnScale",FLoat)                   = 0

        _Translate              ("Translate",Vector)                 = (0,0,0,0)
        _Rotate                 ("Rotate",Float)                    = 0
        _Scale                  ("Scale",FLoat)                     = 1

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
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };
            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D           _MainTex;
            float4              _MainTex_ST;

            float4              _Translate;
            float               _Rotate;
            float               _Scale;

            float               _OnTranslate;
            float               _OnRotate;
            float               _OnScale;

            v2f vert (appdata v)
            {
                v2f             o;
                o.vertex        = UnityObjectToClipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(v.uv,_MainTex);
                return          o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2          aUv                                 = i.uv;
                if (_OnTranslate)
                {
                    aUv         += _Translate.xy;
                }
                if (_OnRotate)
                {
                    float       aRad                                = _Rotate * 0.01745139;
                    aUv                                             -= float2(0.5, 0.5);
                    aUv         = float2(aUv.x * cos(aRad)- aUv.y * sin(aRad), aUv.x * sin(aRad) + aUv.y*cos(aRad));
                    aUv                                             += float2(0.5, 0.5);
                }
                if (_OnScale)
                {
                    aUv                                             -= float2(0.5, 0.5);
                    aUv                                             *= _Scale;
                    aUv                                             += float2(0.5, 0.5);
                }

                return          tex2D(_MainTex, aUv);
            }
            ENDCG
        }
    }
}
