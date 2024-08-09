// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/13_UVtoPixelShader"
{
	Properties
	{
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
				float4 vertex	: POSITION;
				float2 uv		: TEXCOORD0;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			struct VertexOutput
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
			};

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy;

				return o;
			}
			
			//�ȼ� ���̴�
			half4 frag(VertexOutput i) : SV_TARGET
			{
				//float4 color = float4(i.uv.x, i.uv.y, 0, 1);
				//float4 color = i.uv.x;

				float4 color = (i.uv.y > 0.5) ? color = pow(i.uv.x, 2.2) : i.uv.x;

				return color;
			}

			ENDHLSL
		}
	}
}