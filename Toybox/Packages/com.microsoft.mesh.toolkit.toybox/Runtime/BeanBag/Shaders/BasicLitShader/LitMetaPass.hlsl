#ifndef CUSTOM_UNIVERSAL_LIT_META_PASS_INCLUDED
#define CUSTOM_UNIVERSAL_LIT_META_PASS_INCLUDED

#include "./UniversalMetaPass.hlsl"

half4 UniversalFragmentMetaLit(Varyings input) : SV_Target
{
    SurfaceData surfaceData;
    half4 parallaxAlpha = SampleParallaxAlpha(input.uv, TEXTURE2D_ARGS(_ParallaxAlphaMap, sampler_ParallaxAlphaMap));
    InitializeStandardLitSurfaceData(input.uv, input.color, parallaxAlpha.a, surfaceData);

    BRDFData brdfData;
    InitializeBRDFData(surfaceData.albedo, surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.alpha, brdfData);

    MetaInput metaInput;
    metaInput.Albedo = brdfData.diffuse + brdfData.specular * brdfData.roughness * 0.5;
    metaInput.Emission = surfaceData.emission;
    return UniversalFragmentMeta(input, metaInput);
}
#endif
