Shader "AudioTexture/VolumeVisualizer"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
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
			
			v2f vert (appdata v)
			{
				float width, height;
				_MainTex.GetDimensions(width, height);
				float audioSamplePos = _Time.y * 44100;
				float2 uv = float2(fmod(audioSamplePos, width) / width, audioSamplePos / width / height);
				float2 audio = _MainTex.SampleLevel(sampler_MainTex, uv, 0);

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex * audio.r);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = 0.5;
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
