// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/05_SeperateSampler"
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

			
			sampler2D _MainTex02;
			float4 _MainTex02_ST;

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv;

				return o;
			}

			//�ȼ� ���̴�
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