Shader "Custom/CircleRing"
{
	Properties{
		_BgColor("Background Color", Color) = (1,1,1,1)
		_FillAmount("FillAmount", Range(0, 1)) = 0
		_OuterRadius("OuterRadius", Range(0.25, 0.5)) = 0.25
		_InnerRadius("InnerRadius", Range(0, 0.25)) = 0.1
		_DistanceInMeters("DistanceInMeters", Range(0.0, 100.0)) = 2.0
	}
	SubShader{
		// 如果没有这行Tags的话，Camera的ClearFlags必须设置为SolidColor才能看见图形，如果是默认的
		// Skybox则看不见图形
		Tags{ "Queue" = "Overlay" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Pass{
			Blend SrcAlpha OneMinusSrcAlpha
			AlphaTest Off
			Cull Back
			Lighting Off
			ZWrite Off
			ZTest Always
			Fog{ Mode Off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#define PI 3.141592653589

			fixed4 _BgColor;
			fixed _FillAmount;
			fixed _OuterRadius;
			fixed _InnerRadius;
			uniform float _DistanceInMeters;

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;	
			};

			v2f vert(appdata_base v) {
				v2f o;
				float4 vert_out = float4(v.vertex.x, v.vertex.y, _DistanceInMeters, 1.0);
				o.vertex = mul(UNITY_MATRIX_MVP, vert_out);
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy - fixed2(0.5, 0.5);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float dis = sqrt(pow(i.uv.x, 2) + pow(i.uv.y, 2));
				if (dis > 0.5 || (dis < _OuterRadius && dis > _InnerRadius)) {
					discard;
				}
				else if (dis >= _OuterRadius && dis <= 0.5)
				{
					float theta = atan2(-i.uv.x, -i.uv.y) / (2 * PI) + 0.5;// 起点在上方
					//float theta = atan2(i.uv.x, i.uv.y) / (2 * PI) + 0.5;// 起点在下方

					if (theta > _FillAmount)
					{
						discard;
					}
				}
				
				return fixed4(_BgColor.r, _BgColor.g, _BgColor.b, _BgColor.a);
			}
			ENDCG
		}
	}
}