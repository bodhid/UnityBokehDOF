Shader "Hidden/BodhiDonselaar/BokehFinal"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _CameraDepthTexture, _Bokeh;
			uniform float _BlurStart, _BlurSize;
			fixed4 frag (v2f i) : SV_Target
			{
				//return _ProjectionParams.w;
				float depth = (Linear01Depth(tex2D(_CameraDepthTexture, i.uv).r));
				float4 bokeh = tex2D(_Bokeh, i.uv);
			//	depth = bokeh.a;
				//return depth;
				depth = (depth - _BlurStart)*_BlurSize;

				//return depth;
				fixed4 col = tex2D(_MainTex, i.uv);
				
				return lerp(col, bokeh, saturate(depth));

				return col;
			}
			ENDCG
		}
	}
}
