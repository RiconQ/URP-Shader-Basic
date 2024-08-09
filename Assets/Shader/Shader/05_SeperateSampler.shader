// Shader 시작. 셰이더의 폴더와 이름을 여기서 결정합니다.
Shader "URPTraining/05_SeperateSampler"
{
	Properties
	{
		// Properties Block : 셰이더에서 사용할 변수를 선언하고 이를 material inspector에 노출시킵니다

		_TintColor("Color", Color) = (1, 1, 1, 1)
		_MainTex("RGB", 2D) = "white"{}
		_MainTex02("RGB02", 2D) = "white"{}
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
				float4 vertex : POSITION;
				float2 uv		: TEXCOORD0;
			};

			//보간기를 통해 버텍스 셰이더에서 픽셀 셰이더로 전달할 정보를 선언합니다.
			struct VertexOutput
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
			};

			half4 _TintColor;

			sampler2D _MainTex;
			float4 _MainTex_ST;

			
			sampler2D _MainTex02;
			float4 _MainTex02_ST;

			//버텍스 셰이더
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv;

				return o;
			}

			//픽셀 셰이더
			half4 frag(VertexOutput i) : SV_TARGET
			{
				//return half4(0.5, 0.5, 0.5, 1);

				float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 uv2 = i.uv.xy * _MainTex02_ST.xy + _MainTex02_ST.zw;

				half4 color01 = tex2D(_MainTex, uv);
				half4 color02 = tex2D(_MainTex02, uv2);

				half4 color = color01 * color02;

				return color;
			}

			ENDHLSL
		}
	}
}