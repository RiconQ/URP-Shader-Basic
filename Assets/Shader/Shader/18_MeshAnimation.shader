// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/18_Mesh Animation"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
		_TintColor("Test Color", Color) = (1, 1, 1, 1)
		_Intensity("Range Sample", Range(0, 1)) = 0.5
		_MainTex("Main Texture", 2D) = "white"{}

		[NoScaleOffset]_FlowMap("Flow Map", 2D) = "white"{}
		_FlowIntensity("Flow Intensity", range(0, 1)) = 1
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

			half4 _TintColor;
			float _Intensity, _FlowIntensity;

			float4 _MainTex_ST;
			Texture2D _MainTex;
			SamplerState sampler_MainTex;

			sampler2D _FlowMap;

			//���ؽ� ���̴�
			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);

				o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				half4 noise = tex2Dlod(_FlowMap, float4(o.uv, 0, 0));
				
				o.vertex.y += sin(v.vertex.x + v.vertex.z + _Time.y) * noise.r * _FlowIntensity;

				return o;
			}
			
			//�ȼ� ���̴�
			half4 frag(VertexOutput i) : SV_TARGET
			{
				float4 color = _MainTex.Sample(sampler_MainTex, i.uv);
				color.rgb *= _TintColor * _Intensity;

				return color;
			}

			ENDHLSL
		}
	}
}