#ifndef CUSTOM_UNIVERSAL_LIT_INPUT_INCLUDED
#define CUSTOM_UNIVERSAL_LIT_INPUT_INCLUDED

// used in various places, but don't want to copy the whole dependency tree
#define _NORMALMAP _METALLICGLOSSBUMPMAP

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ParallaxMapping.hlsl"
#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

#if defined(_DETAIL_MULX2) || defined(_DETAIL_SCALED)
#define _DETAIL
#endif

// NOTE: Do not ifdef the properties here as SRP batcher can not handle different layouts.
CBUFFER_START(UnityPerMaterial)
float4 _BaseMap_ST;
float4 _DetailAlbedoMap_ST;
half4 _BaseColor;
float _VertexToWhite;
float _TextureToWhite;
half4 _SpecColor;
half4 _EmissionColor;
float _EmitAlbedoMix;
half _Cutoff;
half _Smoothness;
half _Metallic;
half _BumpScale;
half _Parallax;
half _OcclusionStrength;
half _ClearCoatMask;
half _ClearCoatSmoothness;
half _DetailAlbedoMapScale;
half _DetailNormalMapScale;
half _Surface;
CBUFFER_END

// NOTE: Do not ifdef the properties for dots instancing, but ifdef the actual usage.
// Otherwise you might break CPU-side as property constant-buffer offsets change per variant.
// NOTE: Dots instancing is orthogonal to the constant buffer above.
#ifdef UNITY_DOTS_INSTANCING_ENABLED
UNITY_DOTS_INSTANCING_START(MaterialPropertyMetadata)
    UNITY_DOTS_INSTANCED_PROP(float4, _BaseColor)
    UNITY_DOTS_INSTANCED_PROP(float4, _SpecColor)
    UNITY_DOTS_INSTANCED_PROP(float4, _EmissionColor)
    UNITY_DOTS_INSTANCED_PROP(float , _Cutoff)
    UNITY_DOTS_INSTANCED_PROP(float , _Smoothness)
    UNITY_DOTS_INSTANCED_PROP(float , _Metallic)
    UNITY_DOTS_INSTANCED_PROP(float , _BumpScale)
    UNITY_DOTS_INSTANCED_PROP(float , _Parallax)
    UNITY_DOTS_INSTANCED_PROP(float , _OcclusionStrength)
    UNITY_DOTS_INSTANCED_PROP(float , _ClearCoatMask)
    UNITY_DOTS_INSTANCED_PROP(float , _ClearCoatSmoothness)
    UNITY_DOTS_INSTANCED_PROP(float , _DetailAlbedoMapScale)
    UNITY_DOTS_INSTANCED_PROP(float , _DetailNormalMapScale)
    UNITY_DOTS_INSTANCED_PROP(float , _Surface)
UNITY_DOTS_INSTANCING_END(MaterialPropertyMetadata)

#define _BaseColor              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_BaseColor)
#define _SpecColor              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_SpecColor)
#define _EmissionColor          UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float4 , Metadata_EmissionColor)
#define _Cutoff                 UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Cutoff)
#define _Smoothness             UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Smoothness)
#define _Metallic               UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Metallic)
#define _BumpScale              UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_BumpScale)
#define _Parallax               UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Parallax)
#define _OcclusionStrength      UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_OcclusionStrength)
#define _ClearCoatMask          UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_ClearCoatMask)
#define _ClearCoatSmoothness    UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_ClearCoatSmoothness)
#define _DetailAlbedoMapScale   UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_DetailAlbedoMapScale)
#define _DetailNormalMapScale   UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_DetailNormalMapScale)
#define _Surface                UNITY_ACCESS_DOTS_INSTANCED_PROP_FROM_MACRO(float  , Metadata_Surface)
#endif

TEXTURE2D(_ParallaxAlphaMap); SAMPLER(sampler_ParallaxAlphaMap);
TEXTURE2D(_DetailMask);           SAMPLER(sampler_DetailMask);
TEXTURE2D(_DetailAlbedoMap);      SAMPLER(sampler_DetailAlbedoMap);
TEXTURE2D(_DetailNormalMap);      SAMPLER(sampler_DetailNormalMap);
TEXTURE2D(_MetallicGlossBumpMap); SAMPLER(sampler_MetallicGlossBumpMap);
TEXTURE2D(_ClearCoatMap);         SAMPLER(sampler_ClearCoatMap);


/**
Returns metal/specular in RGB, glossiness in A
*/
void SampleMetallicGlossBump(float2 uv, out half2 metalGloss, out half3 normal)
{
#ifdef _METALLICGLOSSBUMPMAP
    half4 metalGlossBump = half4(SAMPLE_TEXTURE2D(_MetallicGlossBumpMap, sampler_MetallicGlossBumpMap, uv));

    metalGloss.x = metalGlossBump.r;
    metalGloss.y = metalGlossBump.b * _Smoothness;

    #if BUMP_SCALE_NOT_SUPPORTED
        normal = UnpackNormalAG(metalGlossBump, 1.0);
    #else
        normal = UnpackNormalAG(metalGlossBump, _BumpScale);
    #endif

#else // _METALLICGLOSSBUMPMAP
    metalGloss.x = _Metallic.r;
    metalGloss.y = _Smoothness;
    normal = half3(0.0h, 0.0h, 1.0h);
#endif
}

half SampleOcclusion(float2 uv, half4 albedoOcclusion)
{
    // TODO: Controls things like these by exposing SHADER_QUALITY levels (low, medium, high)
    #if defined(SHADER_API_GLES)
        return albedoOcclusion.a;
    #else
        half occ = albedoOcclusion.a;
        return LerpWhiteTo(occ, _OcclusionStrength);
    #endif
}


// Returns clear coat parameters
// .x/.r == mask
// .y/.g == smoothness
half2 SampleClearCoat(float2 uv)
{
#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
    half2 clearCoatMaskSmoothness = half2(_ClearCoatMask, _ClearCoatSmoothness);

#if defined(_CLEARCOATMAP)
    clearCoatMaskSmoothness *= SAMPLE_TEXTURE2D(_ClearCoatMap, sampler_ClearCoatMap, uv).rg;
#endif

    return clearCoatMaskSmoothness;
#else
    return half2(0.0, 1.0);
#endif  // _CLEARCOAT
}

void ApplyPerPixelDisplacement(half3 viewDirTS, inout float2 uv, out half4 rawTextureData)
{
#if defined(_PARALLAXALPHAMAP)
    rawTextureData = SAMPLE_TEXTURE2D(_ParallaxAlphaMap, sampler_ParallaxAlphaMap, uv);
    half h = rawTextureData.g;
    float2 offset = ParallaxOffset1Step(h, _Parallax, viewDirTS);
    uv += offset;
#else
    rawTextureData = half4(0.0h, 0.0h, 0.0h, 1.0h);
#endif
}

void ApplyPerPixelDisplacementPreSampled(half3 viewDirTS, half h, inout float2 uv)
{
    uv += ParallaxOffset1Step(h, _Parallax, viewDirTS);
}

half4 SampleParallaxAlpha(float2 uv, TEXTURE2D_PARAM(parallaxAlphaMap, sampler_parallaxAlphaMap))
{
#if _PARALLAXALPHAMAP
    return SAMPLE_TEXTURE2D(parallaxAlphaMap, sampler_parallaxAlphaMap, uv);
#else
    return half4(0.0h, 0.0h, 0.0h, 1.0h);
#endif
}

// Used for scaling detail albedo. Main features:
// - Depending if detailAlbedo brightens or darkens, scale magnifies effect.
// - No effect is applied if detailAlbedo is 0.5.
half3 ScaleDetailAlbedo(half3 detailAlbedo, half scale)
{
    // detailAlbedo = detailAlbedo * 2.0h - 1.0h;
    // detailAlbedo *= _DetailAlbedoMapScale;
    // detailAlbedo = detailAlbedo * 0.5h + 0.5h;
    // return detailAlbedo * 2.0f;

    // A bit more optimized
    return half(2.0) * detailAlbedo * scale - scale + half(1.0);
}

half3 ApplyDetailAlbedo(float2 detailUv, half3 albedo, half detailMask)
{
#if defined(_DETAIL)
    half3 detailAlbedo = SAMPLE_TEXTURE2D(_DetailAlbedoMap, sampler_DetailAlbedoMap, detailUv).rgb;

    // In order to have same performance as builtin, we do scaling only if scale is not 1.0 (Scaled version has 6 additional instructions)
#if defined(_DETAIL_SCALED)
    detailAlbedo = ScaleDetailAlbedo(detailAlbedo, _DetailAlbedoMapScale);
#else
    detailAlbedo = half(2.0) * detailAlbedo;
#endif

    return albedo * LerpWhiteTo(detailAlbedo, detailMask);
#else
    return albedo;
#endif
}

half3 ApplyDetailNormal(float2 detailUv, half3 normalTS, half detailMask)
{
#if defined(_DETAIL)
#if BUMP_SCALE_NOT_SUPPORTED
    half3 detailNormalTS = UnpackNormal(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv));
#else
    half3 detailNormalTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv), _DetailNormalMapScale);
#endif

    // With UNITY_NO_DXT5nm unpacked vector is not normalized for BlendNormalRNM
    // For visual consistancy we going to do in all cases
    detailNormalTS = normalize(detailNormalTS);

    return lerp(normalTS, BlendNormalRNM(normalTS, detailNormalTS), detailMask); // todo: detailMask should lerp the angle of the quaternion rotation, not the normals
#else
    return normalTS;
#endif
}

inline void InitializeStandardLitSurfaceData(float2 uv, half3 color, half alpha, out SurfaceData outSurfaceData)
{
    half4 albedoOcclusion = half4(SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv));
    half3 textureContrib = LerpWhiteTo(albedoOcclusion.rgb, 1.0 - _TextureToWhite);
    half3 vertcolorContrib = LerpWhiteTo(color, 1.0 - _VertexToWhite);
    outSurfaceData.albedo = textureContrib * _BaseColor.rgb * vertcolorContrib;
    outSurfaceData.occlusion = SampleOcclusion(uv, albedoOcclusion);

    half2 metalGloss;
    half3 normal;
    SampleMetallicGlossBump(uv, metalGloss, normal);

    outSurfaceData.metallic = metalGloss.x;
    outSurfaceData.specular = half3(0.0, 0.0, 0.0);
    outSurfaceData.smoothness = metalGloss.y;
    outSurfaceData.normalTS = normal;

    outSurfaceData.alpha = Alpha(alpha, _BaseColor, _Cutoff);
    outSurfaceData.emission = SampleEmission(uv, _EmissionColor.rgb, TEXTURE2D_ARGS(_EmissionMap, sampler_EmissionMap))
        * LerpWhiteTo(outSurfaceData.albedo, _EmitAlbedoMix);

#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
    half2 clearCoat = SampleClearCoat(uv);
    outSurfaceData.clearCoatMask       = clearCoat.r;
    outSurfaceData.clearCoatSmoothness = clearCoat.g;
#else
    outSurfaceData.clearCoatMask       = half(0.0);
    outSurfaceData.clearCoatSmoothness = half(0.0);
#endif

#if defined(_DETAIL)
    half detailMask = SAMPLE_TEXTURE2D(_DetailMask, sampler_DetailMask, uv).a;
    float2 detailUv = uv * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
    outSurfaceData.albedo = ApplyDetailAlbedo(detailUv, outSurfaceData.albedo, detailMask);
    outSurfaceData.normalTS = ApplyDetailNormal(detailUv, outSurfaceData.normalTS, detailMask);
#endif
}

#endif // CUSTOM_UNIVERSAL_INPUT_SURFACE_PBR_INCLUDED
