Shader "FN_Unlit/TransFromTRS"
{
    Properties
    {
        _MainTex                            ("Texture", 2D)         = "white" {}
        [Toggle(OpenOffset)] _OpenOffset    ("OpenOffset",float)    = 0
        [Toggle(OpenRotate)] _OpenRotate    ("OpenRotate",float)    = 0
        [Toggle(OpenScale)]  _OpenScale     ("OpenScale",float)     = 0

        [Space(5)]
        _Offset                             ("Offset",float)        = (0,0,0,0)
        _Rotate                             ("Rotate",float)        = 0
        _Scale                              ("Scale",Range(0,10))   = 1
        
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv :     TEXCOORD0;
            };
            struct v2f
            {
                float2 uv :     TEXCOORD0;
                float4 vertex : SV_POSITION;
            };


            sampler2D           _MainTex;
            float4              _MainTex_ST;

            float               _OpenOffset;
            float               _OpenRotate;
            float               _OpenScale;
            
            float4              _Offset;
            float               _Rotate;
            float               _Scale;


            v2f vert (appdata v)
            {
                v2f             o;
                o.vertex        = UnityObjectToClipPos(v.vertex);
                o.uv            = TRANSFORM_TEX(v.uv, _MainTex);
                return          o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2          aUv                             = i.uv;

                if(_OpenOffset)
                {
                    aUv                                         += _Offset.xy;
                }
                if (_OpenRotate)
                {
                    float       aAngle                          =  _Rotate * 0.017453292519943295;   // ½Ç¶È±ä»¡¶È
                    aAngle                                      += aAngle * _Time.y;
                    aUv                                         -= float2(0.5,0.5);
                    aUv                                         =  float2(aUv.x * cos(aAngle)- aUv.y * sin(aAngle), aUv.x * sin(aAngle) + aUv.y * cos(aAngle));
                    aUv                                         += float2(0.5,0.5);
                }
                if (_OpenScale)
                {
                    aUv                                         -= float2(0.5, 0.5);
                    aUv                                         *= _Scale * _Time.y;
                    aUv                                         += float2(0.5, 0.5);
                }
                return        tex2D(_MainTex, aUv);
            }
            ENDCG
        }
    }
}
