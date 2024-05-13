// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Microsoft/SphereSculptureShader"
{
    Properties
    {
        _Alpha("Alpha", Range(0, 1)) = 1
        [Toggle(IS_SMALL_SPHERE)] _IsSmallSphere("Is Small Sphere", int) = 0

        _LightDir("Light Dir", Vector) = (0, 0, 0)

        [Header(Movement)]
        _WobbleSpeed("Wobble Speed", Float) = 0.5
        _WobbleScale("Wobble Scale", Float) = 0.2

        [Header(Default Colors)]
        _BorderColor("Border Color", Color) = (1,1,1,1)
        _TranslucentColor("Translucent Color", Color) = (1,1,1,1)
        _LightColor("Light Color", Color) = (1,1,1,1)

        [Header(Active Colors)]
        _BorderColor2("Border Color", Color) = (1,1,1,1)
        _TranslucentColor2("Translucent Color", Color) = (1,1,1,1)
        _LightColor2("Light Color", Color) = (1,1,1,1)

        [Header(Interaction Colors)]
        _HoveredColor("Hover Color", Color) = (1,1,1,1)
        _PressedColor("Pressed Color", Color) = (1,1,1,1)

        [Header(Sphere Mask Settings)]
        _DistanceMultiplier("Distance Multiplier", Float) = 0.2
        _Radius("Radius", Range(0, 10)) = 0
		_Falloff("Falloff", Range(0.01, 5)) = 0
        _PositionOffset("Position Offset", Float) = 3
        _TotalHeight("Total Height", Float) = 7

        [Header(Small Spheres Wave)]
        _SmallSphereWaveDisplacementAmount("Small Sphere Wave Displacement Amount", Float) = 0.07
        _SmallSpheresWaveColor("Small Spheres Wave Color", Color) = (1,1,1,1)

        [Header(REFLECTIONS)]
        _ReflectionIntensity("ReflectionIntensity", Range(0, 1)) = 0
        _Roughness("Roughness", Range(0.0, 10.0)) = 0.0
        
        [HideInInspector]_Active("Active", Float) = 0
        [HideInInspector]_IsPressed("Is Pressed", Float) = 0
        [HideInInspector]_StartingPosition("Starting Position", Vector) = (0, 0, 0)
        [HideInInspector]_StartingScale("Starting Scale", Vector) = (0, 0, 0)
    }

    SubShader
    {
        Tags {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        Blend One OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM 
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing
            #pragma shader_feature IS_SMALL_SPHERE

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half sphere : TEXCOORD1;
                half3 reflection : TEXCOORD2;
                half3 sphereActiveColor : TEXCOORD3;
                half3 smallSphereActiveColor : TEXCOORD4;
                half3 combinedColorDefault : TEXCOORD5;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            //Shading
            half _Alpha;
            half3 _TranslucentColor;
            half3 _LightColor;
            half3 _LightDir;

            //Color
            half3 _HoveredColor;
            half3 _PressedColor;
            half3 _BorderColor;
            half3 _BorderColor2;
            half3 _TranslucentColor2;
            half3 _LightColor2;

            //Reflections
            half _ReflectionIntensity;
            half _Roughness;

            //States
            half _Active;
            half _IsPressed;

            //Movement
            half3 _StartingPosition;
            half3 _StartingScale;
            half _WobbleSpeed;
            half _WobbleScale;

            //Wave
            half _SmallSphereWaveDisplacementAmount;
            half3 _SmallSpheresWaveColor;

            //Sphere
            half _Radius;
		    half _Falloff;
            half _DistanceMultiplier;
            half _PositionOffset;
            half _TotalHeight;
            CBUFFER_END

            //Global
            half _Global_MusicalSpheres_WaveProgress_1;
            half3 _Global_MusicalSpheres_WaveOrigin_1;

            half _Global_MusicalSpheres_WaveProgress_2;
            half3 _Global_MusicalSpheres_WaveOrigin_2;

            half _Global_MusicalSpheres_WaveProgress_3;
            half3 _Global_MusicalSpheres_WaveOrigin_3;

            half3 Half3Lerp(half3 val1, half3 val2, half t)
            {
                return val1 * (1 - t) + val2 * t;
            }

            v2f vert (appdata v)
            {
                v2f o = (v2f)0;
                UNITY_SETUP_INSTANCE_ID(v); 
                UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = v.vertex;
                o.uv = v.uv;
                half3 worldNormal = TransformObjectToWorldNormal(v.normal);
                half3 worldPos = mul(UNITY_MATRIX_M, v.vertex).xyz;
                half3 worldViewDir = normalize(GetWorldSpaceViewDir(worldPos));

                //Movement
                half heightOffset = cos(_StartingPosition.x + _StartingPosition.y * _StartingScale.x + _Time.y * _WobbleSpeed);
                o.vertex.y += heightOffset * _WobbleScale;

                //Distance based spheres
                half3 objectOrigin = mul(UNITY_MATRIX_M, float4(0,0,0,1)).xyz;

                #if defined(IS_SMALL_SPHERE)
                //Wave 1
				half dis = distance(_Global_MusicalSpheres_WaveOrigin_1, objectOrigin) * 0.1;
                half progress = lerp(0, _Radius, _Global_MusicalSpheres_WaveProgress_1);
				half sphere1 = 1 - saturate(dis / progress);
                half backSphere = saturate(dis / progress);
				sphere1 = saturate((pow(sphere1 * backSphere, _Falloff) - 0.01) * 20);
                sphere1 *= 1 - dis; 

                //Wave 2
                half dis2 = distance(_Global_MusicalSpheres_WaveOrigin_2, objectOrigin) * 0.1;
                half progress2 = lerp(0, _Radius, _Global_MusicalSpheres_WaveProgress_2);
				half sphere2 = 1 - saturate(dis2 / progress2);
                half backSphere2 = saturate(dis2 / progress2);
				sphere2 = saturate((pow(sphere2 * backSphere2, _Falloff) - 0.01) * 20);
                sphere2 *= 1 - dis2; 

                //Wave 3
                half dis3 = distance(_Global_MusicalSpheres_WaveOrigin_3, objectOrigin) * 0.1;
                half progress3 = lerp(0, _Radius, _Global_MusicalSpheres_WaveProgress_3);
				half sphere3 = 1 - saturate(dis3 / progress3);
                half backSphere3 = saturate(dis3 / progress3);
				sphere3 = saturate((pow(sphere3 * backSphere3, _Falloff) - 0.01) * 20);
                sphere3 *= 1 - dis3; 

                o.sphere = sphere1 + sphere2 + sphere3;

                o.vertex.xyz += v.normal * o.sphere * _SmallSphereWaveDisplacementAmount;
                worldPos += (objectOrigin - _Global_MusicalSpheres_WaveOrigin_1) * sphere1 * _SmallSphereWaveDisplacementAmount;
                worldPos += (objectOrigin - _Global_MusicalSpheres_WaveOrigin_2) * sphere2 * _SmallSphereWaveDisplacementAmount;
                worldPos += (objectOrigin - _Global_MusicalSpheres_WaveOrigin_3) * sphere3 * _SmallSphereWaveDisplacementAmount;
                o.vertex = mul(UNITY_MATRIX_I_M, float4(worldPos, 1.0));
                #endif

                o.vertex = TransformObjectToHClip(o.vertex);

                //Colors
                half3 translucentCol = Half3Lerp(_TranslucentColor, _TranslucentColor2, _Active);
                half3 borderCol = Half3Lerp(_BorderColor, _BorderColor2, _Active);
                half3 lightCol = Half3Lerp(_LightColor, _LightColor2, _Active); 

                #if defined(IS_SMALL_SPHERE)
                translucentCol = Half3Lerp(_TranslucentColor, _TranslucentColor2, o.sphere);
                borderCol = Half3Lerp(_BorderColor, _BorderColor2, o.sphere);
                lightCol = Half3Lerp(_LightColor, _LightColor2, o.sphere); 
                #endif

                half3 normalizedWorldNormal = normalize(worldNormal);
                half theDot = dot(normalize(_LightDir), normalizedWorldNormal);
                half mainShade = saturate(theDot) * 0.5 + 0.5;
                half3 extraColors = lerp(translucentCol, lightCol, mainShade);
                half fresnel = dot(worldViewDir, normalizedWorldNormal);
                half rimLight = pow(1 - fresnel, 5);
                half3 coloredRimLight = rimLight * borderCol;

                #if defined(IS_SMALL_SPHERE)
                coloredRimLight *= lerp(0.5, 1, o.sphere);
                #else
                coloredRimLight *= lerp(0.5, 1, _Active);
                #endif

                half3 interactionColor = Half3Lerp(_HoveredColor, _PressedColor, _IsPressed);
                #if !defined(IS_SMALL_SPHERE)
                interactionColor += pow(saturate((objectOrigin.y + _PositionOffset) / _TotalHeight) * 0.5, 1.5); 
                #endif

                interactionColor *= fresnel * 1.3;

                o.combinedColorDefault = coloredRimLight + extraColors;
                half3 combinedColorNew =  coloredRimLight + (extraColors * (1 - fresnel));
                o.sphereActiveColor = combinedColorNew + interactionColor;
                o.smallSphereActiveColor = combinedColorNew + _SmallSpheresWaveColor * fresnel;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                half3 defaultCol = i.combinedColorDefault;
                half3 finalColor = Half3Lerp(defaultCol, i.sphereActiveColor * 1.1, _Active);
                half4 finalColorComp = half4(finalColor, _Alpha);

                #if defined(IS_SMALL_SPHERE)
                finalColor = Half3Lerp(finalColor, i.smallSphereActiveColor, i.sphere);
                finalColorComp = half4(finalColor, lerp(_Alpha, 1, i.sphere));
                #endif

                return finalColorComp;
            }
            ENDHLSL 
        }
    }
}