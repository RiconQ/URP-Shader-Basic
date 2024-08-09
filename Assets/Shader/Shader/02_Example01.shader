// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/02_Example01"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
		// Color �����ϴ� ������ ����, ���� Ÿ���� Color�̸� �⺻���� (1, 1, 1, 1)
		_TintColor("Tint Color", Color) = (1, 1, 1, 1)

		// ������ ���⸦ �ּ� 0���� �ִ� 1�� �����ϴ� ����, �⺻�� 0.5
		_Intensity("Range Sample", Range(0, 1)) = 0.5
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

			float _Intensity;
			half4 _TintColor;

			//vertex buffer���� �о�� ������ �����մϴ�. 
			struct VertexInput
			{
				float4 vertex : POSITION;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			struct VertexOutput
			{
				float4 vertex : SV_POSITION;
			};

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);

				return o;
			}

			//�ȼ� ���̴�
			half4 frag(VertexOutput i) : SV_TARGET
			{
				float4 color = _TintColor * _Intensity;
				return color;
			}

			ENDHLSL
		}
	}
}