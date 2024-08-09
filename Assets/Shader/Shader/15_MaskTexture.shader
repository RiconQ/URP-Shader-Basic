// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "URPTraining/15_Mask Texture"
{
	Properties
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다
		_MainTex("RGB 01", 2D) = "white"{}
		_MainTex02("RGB 02", 2D) = "white"{}

		_MaskTex("Mask Texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags
		{
			//Render type과 Render Queue를 여기서 결정합니다.
			"RenderPipeline" = "UniversalPipeline"
			"RederType" = "Opaque"
			"Queue" = "Geometry"
		}
		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward"}

			HLSLPROGRAM
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			//cg shader는 .cginc를 hlsl shader는 .hlsl을 include하게 됩니다.
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			//vertex buffer에서 읽어올 정보를 선언합니다. 
			struct VertexInput
			{
				float4 vertex	: POSITION;
				float2 uv		: TEXCOORD0;
			};

			//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
			struct VertexOutput
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
				float2 uv2		: TEXCOORD1;
			};
			SamplerState sampler_MainTex;

			float4 _MainTex_ST;
			Texture2D _MainTex;

			float4 _MainTex02_ST;
			Texture2D _MainTex02;

			Texture2D _MaskTex;

			//버텍스 셰이더
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);

				o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv2 = v.uv.xy * _MainTex02_ST.xy + _MainTex02_ST.zw;

				return o;
			}
			
			//픽셀 셰이더
			half4 frag(VertexOutput i) : SV_TARGET
			{
				float4 tex01 = _MainTex.Sample(sampler_MainTex, i.uv);
				float4 tex02 = _MainTex02.Sample(sampler_MainTex, i.uv2);

				float mask = _MaskTex.Sample(sampler_MainTex, i.uv);

				float4 color = lerp(tex01, tex02, mask.r);

				return color;
			}

			ENDHLSL
		}
	}
}