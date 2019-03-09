Shader "AudioTexture/RMSVisualizer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SamplingFrequency ("Sampling Frequency", float) = 44100
		_Color ("Color", Color) = (1, 1, 1, 0)
		_Window ("Window Length (seconds)", float) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma target 5.0

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			UNITY_DECLARE_TEX2D(_MainTex);
			float _SamplingFrequency;
			fixed4 _Color;
			float _Window;
			
			v2f vert (appdata v)
			{
				float width, height;
				_MainTex.GetDimensions(width, height);
				float startTime = _Time.y - _Window;
				float sum = 0.0;
				[unroll(_Window * 48000)]
				for (float audioSamplePos = startTime * _SamplingFrequency; audioSamplePos < _Time.y * _SamplingFrequency; audioSamplePos++) {
					float2 uv = float2(fmod(audioSamplePos, width) / width, audioSamplePos / width / height);
					float2 audio = _MainTex.SampleLevel(sampler_MainTex, uv, 0) * 2.0 - 1.0;
					sum += audio.x * audio.x;
				}
				float rms = sqrt(sum / (_Window * _SamplingFrequency));

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex * rms);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = _Color;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
