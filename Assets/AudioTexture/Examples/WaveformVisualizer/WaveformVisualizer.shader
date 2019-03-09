Shader "AudioTexture/WaveformVisualizer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SamplingFrequency ("Sampling Frequency", float) = 44100
		_Color ("Color", Color) = (1, 1, 1, 0)
	}
	SubShader
	{
		Tags {
			"RenderType"="Opaque"
		}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 5.0

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			UNITY_DECLARE_TEX2D(_MainTex);
			float _SamplingFrequency;
			fixed4 _Color;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				int width, height;
				_MainTex.GetDimensions(width, height);
				float normalizedTime = i.uv.x;
				float stride = 1.0 / height;

				float window = 0.0005;
				float offsetStep = 1.0 / (width * height);
				float2 minMaxAmplitude = 0.0;
				for (float offset = -window; offset < 0; offset += offsetStep) {
					float2 sampleUV = float2(fmod(normalizedTime + offset, stride) * height, normalizedTime + offset);
					float2 stereoAmplitude = _MainTex.Sample(sampler_MainTex, sampleUV) * 2.0 - 1.0;
					minMaxAmplitude = float2(min(minMaxAmplitude.x, stereoAmplitude.x), max(minMaxAmplitude.y, stereoAmplitude.x));
				}

				float y = i.uv.y * 2.0 - 1.0;
				return lerp(0, _Color, y > minMaxAmplitude.x && y < minMaxAmplitude.y );
			}
			ENDCG
		}
	}
}
