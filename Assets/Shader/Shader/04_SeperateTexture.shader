// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/04_SeperateTexture"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�

		_TintColor("Color", Color) = (1, 1, 1, 1)
		_MainTex("RGB", 2D) = "white"{}
		_MainTex02("RGB02", 2D) = "white"{}
	}

	SubShader
	{
		Tags
		{
			//Render type�� Render Queue�� ���⼭ �����մϴ�.
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

			//cg shader�� .cginc�� hlsl shader�� .hlsl�� include�ϰ� �˴ϴ�.
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			//vertex buffer���� �о�� ������ �����մϴ�. 
			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv		: TEXCOORD0;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			struct VertexOutput
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
			};

			half4 _TintColor;

			float4 _MainTex_ST;
			Texture2D _MainTex;
			Texture2D _MainTex02;

			SamplerState sampler_MainTex;

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;

				return o;
			}

			//�ȼ� ���̴�
			half4 frag(VertexOutput i) : SV_TARGET
			{
				//return half4(0.5, 0.5, 0.5, 1);

				half4 color01 = _MainTex.Sample(sampler_MainTex, i.uv);
				half4 color02 = _MainTex02.Sample(sampler_MainTex, i.uv);

				half4 color = color01 * color02;

				return color;
			}

			ENDHLSL
		}
	}
}