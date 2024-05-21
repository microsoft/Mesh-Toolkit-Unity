// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

Shader "Microsoft/Mesh Toolkit/Earth"
{
	Properties
    {
		_BaseMap ("Base Map", CUBE) = ""{}
		_GlossMap ("Gloss Map", CUBE) = ""{}
		_CloudMap ("Cloud Map", CUBE) = ""{}
		_LightsMap ("Lights Map", CUBE) = ""{}

		_AtmosphereColor("Atmosphere", Color) = (1,1,1,1)
		_Haze("Haze", Color) = (1,1,1,1)
		_LightsColor("Lights Color", Color) = (1,1,1,1)
		_CloudColor("Clouds Color", Color) = (1,1,1,1)

		_CloudShadowDistance("Cloud Shadow Distance", Range(-1, 1)) = .1
		_ScrollSpeed("Scroll Speed", Float) = 1

        [Toggle(_USE_VIEW_DIRECTIONAL_LIGHT)] _UseViewDirectionalLight("Use View Directional Light", Float) = 0.0
	}
	SubShader
	{
		Pass
		{
            Name "Main"
            Tags{ "LightMode" = "UniversalForward" }

			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

            #pragma shader_feature_local _ _USE_VIEW_DIRECTIONAL_LIGHT

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
		
            CBUFFER_START(UnityPerMaterial)
			    samplerCUBE _BaseMap;
			    samplerCUBE _GlossMap;

			    samplerCUBE _CloudMap;
			    half4 _CloudColor;

			    samplerCUBE _LightsMap;
			    half4 _LightsColor;

			    half4 _AtmosphereColor;
			    half4 _Haze;
			    float _CloudShadowDistance;
			    float _ScrollSpeed;
            CBUFFER_END

			struct appdata 
            {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f 
            {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD1;
				half3 localNormal : NORMAL;
				half3 cloudNormal : TEXCOORD2;
				half3 worldNormal : TEXCOORD3;
				half3 worldView : TEXCOORD4;
				half3 forward : TEXCOORD5;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float3 GetCloudNormal(float3 normal)
			{
				float angle = _Time.x * _ScrollSpeed;
				float x = normal.x * cos(angle) - normal.z * sin(angle);
				float z = normal.z * cos(angle) + normal.x * sin(angle);
				return float3(x, normal.y, z);
			}

			v2f vert(appdata v)
			{
				v2f o = (v2f)0;

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float4 vert = v.vertex;

				o.uv = v.uv;
				o.pos = TransformObjectToHClip(vert.xyz);

				o.localNormal = v.normal;
				o.cloudNormal = GetCloudNormal(v.normal);
				o.worldNormal = TransformObjectToWorldNormal(v.normal);
				o.worldView = GetWorldSpaceViewDir(TransformObjectToWorld(vert.xyz));
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
                i.worldView = normalize(i.worldView);

                #if defined(_USE_VIEW_DIRECTIONAL_LIGHT)
                    float3 directionalLightDirection = i.worldView;
                #else
                    Light directionalLight = GetMainLight();
                    float3 directionalLightDirection = directionalLight.direction.xyz;
                #endif

				i.worldNormal = normalize(i.worldNormal);
				float fresnel = dot(i.worldView, i.worldNormal);

				half3 baseCol = texCUBE(_BaseMap, i.localNormal).xyz;
				float3 cloudShadowNormal = lerp(i.cloudNormal, directionalLightDirection, _CloudShadowDistance);
				float3 cloudShadow = texCUBElod(_CloudMap, float4(cloudShadowNormal, 5)).xyz * _CloudColor.a;
				float3 gloss = texCUBE(_GlossMap, i.localNormal).xyz;

				float3 clouds = texCUBE(_CloudMap, i.cloudNormal).xyz * _CloudColor.rgb * _CloudColor.a;

				float3 lights = texCUBE(_LightsMap, i.localNormal).xyz;

				half baseShade = -dot(i.worldNormal, directionalLightDirection);

				float3 halfAngle = normalize(i.worldView + directionalLightDirection);
				float spec = dot(i.worldNormal, halfAngle);
				float3 shine = pow(saturate(spec), 90) * float3(1, 1, .5);
				shine += pow(saturate(spec), 30) * float3(1, .2, 0) * .5;
				shine *= saturate(gloss.x * 5);
				shine += pow(saturate(spec), 10) * float3(0.2, 0.05, 0) * (1 - saturate(gloss.x * 2));

				float3 frontCol = baseCol;
				frontCol += (shine * _Haze.rgb) * _Haze.a;

				float atmosphere = pow(1 - fresnel, 5);
				float3 atmosphereCol = lerp(_AtmosphereColor.rgb, 0, atmosphere);

				frontCol -= pow(cloudShadow, 2) * .5;
				frontCol = lerp(frontCol, 1, pow(clouds, 1) * 1.2);
				frontCol = lerp(frontCol, atmosphereCol, atmosphere);

				float frontLight = 1 - pow(1 - saturate(-baseShade), 2);
				frontLight = max(frontLight, .1);
				float backLight = 1 - pow(1 - saturate(baseShade), 2);
				float3 backCol = lights * (1 - clouds * .5) * _LightsColor.rgb;
				float3 col = saturate(frontLight * frontCol) + saturate(backLight * backCol);

				return float4(col, 1);
			}
			ENDHLSL
		}
	}
}