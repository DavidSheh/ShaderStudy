// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/BlinnPhong"
{
	Properties
	{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}
		SubShader
	{
		Tags{ "LightMode" = "ForwardBase" }

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
		fixed3 worldNormal : TEXCOORD0;
		float3 worldPos : TEXCOORD1;
	};

	fixed4 _Diffuse;
	fixed4 _Specular;
	float _Gloss;

	v2f vert(a2v v)
	{
		v2f o;
		// 将顶点从模型空间变换到投影空间
		o.pos = mul(UNITY_MATRIX_MVP, v.vertex);

		// 将法向量从模型空间变换到世界空间
		o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

		// 将顶点从模型空间变换到世界空间
		o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		// 获取环境光（ambient）参数
		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

	// 获取世界空间中的法向量
	fixed3 worldNormal = normalize(i.worldNormal);
	// 获取光源在世界空间中的方向
	fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
	// 计算漫反射
	fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

	// 计算光线在世界空间中的反射方向
	fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));
	// 计算在世界空间中的观察方向
	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
	// 计算在世界空间中的half方向
	fixed halfDir = normalize(worldLightDir + viewDir);
	// 计算高光
	fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
	// 最终光照效果 = 环境光（ambient） + 漫反射光（diffuse） + 高光反射（Specular)
	fixed3 color = ambient + diffuse + specular;

	return fixed4(color, 1.0);
	}
		ENDCG
	}
	}

		Fallback "Specular"
}