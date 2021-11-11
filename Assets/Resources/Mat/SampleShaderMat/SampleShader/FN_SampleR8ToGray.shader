Shader "FN_Unlit/FN_SampleR8ToGray"
{
    Properties
    {
        _MainTex    ("Texture", 2D)             = "white" {}
        _Speed      ("Speed",Range(0,4))        = 1
    }
        SubShader
    {
        Tags            { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex      vert
            #pragma fragment    frag

            #include            "UnityCG.cginc"

            sampler2D           _MainTex;
            float               _Speed;
            float4              _MainTex_ST;

            struct              appdata
            {
                float4          vertex : POSITION;
                float2          uv:      TEXCOORD0;
            };
            struct              v2f
            {
                float2 uv       :TEXCOORD0;
                float4 vertex   :SV_POSITION;
            };

            v2f vert(appdata v)
            {
                v2f             o;
                o.vertex                                        = UnityObjectToClipPos(v.vertex);
                o.uv                                            = TRANSFORM_TEX(v.uv, _MainTex);
                return          o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                //-----------------------------------------------|| 中心扭曲 ||-----------------------------------------------
                //fixed2          a_uv                            = i.uv - fixed2(0.5,0.5);
                //float           a_angle                         = _Speed * 0.1745/(length(a_uv) + 0.1);     // 0.1 是放置length(a_uv)为 0
                //float           a_angle_2                       = a_angle * _Time.y;
                //a_uv            = float2(a_uv.x * cos(a_angle_2) - a_uv.y * sin(a_angle_2) , a_uv.y * cos(a_angle_2) + a_uv.x * sin(a_angle_2));

                //a_uv                                            += fixed2(0.5,0.5);
                //return          tex2D(_MainTex, a_uv);

                //-----------------------------------------------|| Uv缩放 ||-----------------------------------------------
                float2          a_uv                            = i.uv ;
                a_uv                                            -= float2(0.5, 0.5);
                a_uv.x = a_uv.x  *_Time.y * _Speed;
                a_uv.y = a_uv.y * _Time.y * _Speed;
                a_uv                                            += float2(0.5, 0.5);
                return          tex2D(_MainTex, a_uv);
            }
            ENDCG
        }
    }
}
