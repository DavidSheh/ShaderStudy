// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Shaders101/ColoredUV"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
	}

	SubShader
	{
		Tags
		{
			"Queue" = "Transparent"
			"PreviewType" = "Plane"
		}

		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			Name "ColorPass"

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
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			sampler2D _MainTex;
			float4 _Color;

			float4 frag(v2f i) : SV_Target
			{
				// i.uv.x或者i.uv.r都对。xyz对应rgb,但uv是二维结构，没有z/b，所以第三个值可以自定义大小，但范围是[0, 1]
				fixed4 color = tex2D(_MainTex, i.uv) * float4(i.uv.x,i.uv.y,1,1);
				//float4 color = tex2D(_MainTex, i.uv) * float4(i.uv.x, i.uv.y, 0, 1);
				return color;
				/*float4 color = tex2D(_MainTex, i.uv);
				float lum = color.r * 0.3 + color.g * 0.59 + color.b * 0.11;
				float4 grayscale = float4(lum, lum, lum, color.a);
				return grayscale * _Color;*/
			}
			ENDCG
		}
	}
}