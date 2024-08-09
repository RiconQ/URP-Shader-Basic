// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/07_Transparent"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
		_TintColor("Test Color", Color) = (1, 1, 1, 1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("Main Texture", 2D) = "white"{}
		_Alpha("Alpha", Range(0, 1))= 0.5 

		
	[Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
	[Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0

	}

	SubShader
	{
		Tags
		{
			//Render type�� Render Queue�� ���⼭ �����մϴ�.
			"RenderPipeline" = "UniversalPipeline"
			"RederType" = "Transparent"
			"Queue" = "Transparent"
		}
		Pass
		{
			// Blend Operation ����
			// Blend Operation�� �ش� �ȼ��� �׸��� �տ� �׷��� �ȼ��� ���� �ȼ��� ��� ����� �������� �����ϴ� ����.
			Blend [_SrcBlend] [_DstBlend]

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
				float4 vertex	: POSITION;
				float2 uv		: TEXCOORD0;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			struct VertexOutput
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
			};

			half4 _TintColor;
			float _Intensity;

			float4 _MainTex_ST;
			Texture2D _MainTex;
			SamplerState sampler_MainTex;

			float _Alpha;

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
				float4 color = _MainTex.Sample(sampler_MainTex, i.uv);

				color.rgb *= _TintColor * _Intensity;
				color.a = color.a * _Alpha;

				return color;
			}

			ENDHLSL
		}
	}
}