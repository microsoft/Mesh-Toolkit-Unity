// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

Shader "Microsoft/Mesh Toolkit/InformationCoin"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _RotationSpeed("Rotation Speed", Float) = 1
        _Scale("Scale", Float) = 1

        [Header(Colors)]
        _BorderColor1("Border Color 1", Color) = (1,1,1,1)
        _BorderColor2("Border Color 2", Color) = (1,1,1,1)
        _HoverBorderColor("Hovered Outline Color", Color) = (1,1,1,1)
        _TextColor("Text Color", Color) = (1,1,1,1)
        _BackgroundColor1("Background Color 1", Color) = (1,1,1,1)
        _BackgroundColor2("Background Color 2", Color) = (1,1,1,1)

        [Header(Environment Coloring)]
        _EnvironmentColorThreshold("Environment Color Threshold", Range(0.0, 3.0)) = 1.5
        _EnvironmentColorIntensity("Environment Color Intensity", Range(0.0, 1.0)) = 0.5
        _EnvironmentColorX("Environment Color X (RGB)", Color) = (1.0, 0.0, 0.0, 1.0)
        _EnvironmentColorY("Environment Color Y (RGB)", Color) = (0.0, 1.0, 0.0, 1.0)
        _EnvironmentColorZ("Environment Color Z (RGB)", Color) = (0.0, 0.0, 1.0, 1.0)

        [Header(Hydration Effect)]
        _ColorMaskThickness("Color Mask Thickness", Range(0, 1)) = 1
        _TransitionColor1("Transition Color 1", Color) = (1,1,1,1)
        _TransitionColor2("Transition Color 2", Color) = (1,1,1,1)

        [HideInInspector]_IsBillboarded("Is Billboarded", Float) = 1
        [HideInInspector]_IsHovered("Is Hovered", Float) = 1
        [HideInInspector]_HydrateProgress("Hydrate Progress", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags 
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }

        Pass
        {
            Blend SrcAlpha OneMinusSrcAlpha 
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
                fixed3 backgroundColor : TEXCOORD1;
                fixed3 borderColor : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            CBUFFER_START(UnityPerMaterial)
            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed3 _BorderColor1;
            fixed3 _BorderColor2;
            fixed3 _HoverBorderColor;
            fixed3 _TextColor;
            fixed3 _BackgroundColor1;
            fixed3 _BackgroundColor2;

            fixed _RotationSpeed;
            fixed _Scale;
            fixed _IsBillboarded;
            fixed _IsHovered;
            fixed _HydrateProgress;

            half _EnvironmentColorThreshold;
            half _EnvironmentColorIntensity;
            half3 _EnvironmentColorX;
            half3 _EnvironmentColorY;
            half3 _EnvironmentColorZ;

            fixed3 _TransitionColor1;
            fixed3 _TransitionColor2;
            float _ColorMaskThickness;
            CBUFFER_END

            fixed3x3 RotateY(float theta) {
                float c = cos(theta);
                float s = sin(theta);
                return fixed3x3(
                    fixed3(c, 0, s),
                    fixed3(0, 1, 0),
                    fixed3(-s, 0, c)
                );
            }

            float4 CameraFacingPosition(float4 vert, fixed width, fixed height){
                vert *= float4(-width, height, 1, 1);
                float3 pos = (vert.x * UNITY_MATRIX_IT_MV[0] + vert.y * UNITY_MATRIX_IT_MV[1]).xyz;
                return float4(pos, 1.0);
            }

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v); 
				UNITY_INITIALIZE_OUTPUT(v2f, o); 
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = v.vertex;
                fixed4 rotationTransform = fixed4(mul(RotateY(_Time.x * _RotationSpeed), o.vertex.xyz), o.vertex.w);
                fixed4 billboardedTransform = CameraFacingPosition(o.vertex, _Scale, _Scale);
                o.vertex = rotationTransform * (1 - _IsBillboarded) + billboardedTransform * _IsBillboarded;

                o.vertex = UnityObjectToClipPos(o.vertex);

                fixed3 rotNormal = mul(RotateY(_Time.x * _RotationSpeed), v.normal.xyz);
                fixed3 worldNormal = mul(unity_ObjectToWorld, rotNormal);
                float3 worldVertexPosition = mul(UNITY_MATRIX_M, o.vertex).xyz;
                half3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldVertexPosition.xyz));
                half3 incident = -worldViewDir;
                half3 environmentColor = incident.x * incident.x * _EnvironmentColorX +
                                         incident.y * incident.y * _EnvironmentColorY +
                                         incident.z * incident.z * _EnvironmentColorZ;
    
                o.backgroundColor = _BackgroundColor1 * (1 - v.uv.x) + _BackgroundColor2 * v.uv.x;
                o.backgroundColor += 
                    environmentColor * max(0.0, dot(incident, worldNormal) + 
                    _EnvironmentColorThreshold) * _EnvironmentColorIntensity;

                o.borderColor = _BorderColor1 * (1 - v.uv.x) + _BorderColor2 * v.uv.x;
                o.borderColor = o.borderColor * (1 - _IsHovered) + _HoverBorderColor * _IsHovered;

                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed hydrationMask  = 1 - saturate(((1 - i.uv.y) * 0.9) + _HydrateProgress);
                
                clip(hydrationMask - 0.001);

                fixed3 col = tex2D(_MainTex, i.uv).rgb;

                fixed3 borderColor = i.borderColor * col.g;
                fixed3 textColor = _TextColor * col.b;
                fixed3 backgroundColor = i.backgroundColor * col.r;

                fixed3 coinColor = borderColor + textColor + backgroundColor;

                half colorMask1 = step(hydrationMask, _ColorMaskThickness) * step(0, hydrationMask);
                half colorMask2 = step(hydrationMask, _ColorMaskThickness * 2) * step(_ColorMaskThickness, hydrationMask);
                half shadedColorMask = step(_ColorMaskThickness * 2, hydrationMask);

                half3 color1 = colorMask1 * _TransitionColor1;
                half3 color2 = colorMask2 * _TransitionColor2;
                coinColor *= shadedColorMask;
                half3 combinedColor = coinColor + color1 + color2;

                fixed4 finalColor = half4(combinedColor, 1);
                return finalColor;
            }
            ENDCG
        }
    }
}
