// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/03_TextureSampling"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�

		//����� �ؽ��� ����
		_MainTex("Main Texture", 2D) = "white" {}

		_TintColor("Color", Color) = (1, 1, 1, 1)
		_Intensity("Intensity", Range(0, 1)) = 0.5
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

			// Shader���ο� Texture Sampling�� �����ϰ�
			sampler2D _MainTex;
			float4 _MainTex_ST; // tile�� offset�� ����ϱ� ���� ��
			float _Intensity;
			half4 _TintColor;

			//vertex buffer���� �о�� ������ �����մϴ�. 
			struct VertexInput
			{
				//Vertex buffer���� uv ������ �о���� Semantic ����
				float4 vertex	: POSITION;
				float2 uv		:TEXCOORD0;
			};

			//�����⸦ ���� ���ؽ� ���̴����� �ȼ� ���̴��� ������ ������ �����մϴ�.
			struct VertexOutput
			{
				//Pixel Shader�� �����ϱ� ���� ������ ����
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
				//float3 positionWS	: COLOR;
			};

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				// Vertex Shader���� �����
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);

				//o.positionWS = TransformObjectToWorld(v.vertex.xyz);
				
				o.uv = v.uv;

				return o;
			}

			//�ȼ� ���̴�
			half4 frag(VertexOutput i) : SV_TARGET
			{
				//Pixel Shader���� �̸� �����
				float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;
				//float4 color = tex2D(_MainTex, i.positionWS.xz * 0.5) * _TintColor * _Intensity;
				return color;
			}

			ENDHLSL
		}
	}
}