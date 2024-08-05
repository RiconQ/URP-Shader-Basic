// Shader ����. ���̴��� ������ �̸��� ���⼭ �����մϴ�.
Shader "URPTraining/URPBasic"
{
	Properties
	{
		// Properties Block : ���̴����� ����� ������ �����ϰ� �̸� material inspector�� �����ŵ�ϴ�
		_ColorVar("Basic Color", Color) = (1, 1, 1, 1)
		_RangeVar("Basic Range", Range(0, 1)) = 0
		_VectorVar("Basic Vector", Vector) = (1, 1, 1, 1)
		_IntVar("Basic Int", Int) = 1
		_FloatVar("Basic Float", Float) = 1.5
		_Texture2DVar("Basic Texture 2D", 2D) = "White"{}
		_Texture3DVar("Basic Texture 3D", 3D) = "White"{}
		_TextureRectVar("Basic Texture Rect", Rect) = "White"{}
		_TextureCubeVar("Basic Texture Cube", CUBE) = "White"{}
		_TextureArrayVar("Basic Texture 2D Array", 2DArray)=""{}
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
				return half4(0.5, 0.5, 0.5, 1);
			}

			ENDHLSL
		}
	}
}