Shader "Hidden/BodhiDonselaar/BokehSample"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Direction("Direction",Range(0,6.2829)) = 0
		_Size("Size",Range(1,256)) = 8
		_Samples("Samples",Range(4,64)) = 16
		_Light("Dimming",Range(0,8))=2
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
				float4 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			float4 _MainTex_TexelSize;
			half _Direction, _Size;
			int _Samples;
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = float4(v.uv, (_MainTex_TexelSize*_Size) / (_Samples * 2)*float2(sin(_Direction), cos(_Direction)));
				return o;
			}
			
			sampler2D _MainTex;
			half _Light;
			fixed4 frag (v2f i) : SV_Target
			{
				float4 light = float4(0,0, 0,0);
				float4 amount = float4(0, 0, 0,0);
				for (int j = (-_Samples+1); j < _Samples; ++j)
				{
					float2 uv = i.uv + (i.uv.zw*j);
					float4 col = saturate(tex2D(_MainTex,uv));
					float4 power = float4((pow(col.xyz, float3(9,9,9)) *50 + _Light),0);
					light += col * power;
					amount += power;
				}
				float4 result = light / amount;
				return result;
			}
			ENDCG
		}
	}
}
