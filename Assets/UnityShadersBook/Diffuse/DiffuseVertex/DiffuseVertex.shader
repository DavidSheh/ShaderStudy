﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/DiffuseVertex"
{
	Properties
	{
		_Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Tags { "LightMode"="ForwardBase" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "Lighting.cginc"

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			fixed4 _Diffuse;
			
			v2f vert (a2v v)
			{
				v2f o;
				// 将顶点从模型空间变换到投影空间
				o.pos = UnityObjectToClipPos(v.vertex);
				
				// 获取环境光（ambient）参数
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				// 将法向量从模型空间变换到世界空间
				fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
				// 获取光源在世界空间中的方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				// 计算漫反射
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));
				// 最终光照效果 = 环境光（ambient） + 漫反射光（diffuse）
				o.color = ambient + diffuse;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}

	Fallback "Diffuse"
}