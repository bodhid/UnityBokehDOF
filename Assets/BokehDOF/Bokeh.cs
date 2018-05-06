using UnityEngine;
namespace BodhiDonselaar
{
	[ExecuteInEditMode]
	public class Bokeh : MonoBehaviour
	{
		[Range(0, 256)]
		public float Size = 16;
		[Range(4, 64)]
		public int Samples = 16;
		[Range(0, 8)]
		public float Dimming = 2.0f;
		[Range(0, 60)]
		public float Rotation = 0.0f;
		public float startBlur=1, blurSize=10;
		private static Material bokehSampleMat, bokehFinalMat;
		private Camera cam;
		private void OnEnable()
		{
			if (bokehSampleMat == null) bokehSampleMat = new Material(Resources.Load<Shader>("BokehSample"));
			if (bokehFinalMat == null) bokehFinalMat = new Material(Resources.Load<Shader>("BokehFinal"));
			if (cam == null) cam = GetComponent<Camera>();
		}
		void OnRenderImage(RenderTexture src, RenderTexture des)
		{
			RenderTextureFormat format = cam.allowHDR ? RenderTextureFormat.ARGBHalf : RenderTextureFormat.ARGB32;
			bokehSampleMat.SetFloat("_Samples", Samples);
			bokehSampleMat.SetFloat("_Size", Size);
			bokehSampleMat.SetFloat("_Light", Dimming);
			RenderTexture A = RenderTexture.GetTemporary(src.width, src.height, 0, format);
			RenderTexture B = RenderTexture.GetTemporary(src.width, src.height,0, format);
			float rot = (Rotation / 360.0f) * (Mathf.PI * 2.0f);
			bokehSampleMat.SetFloat("_Direction", rot);
			Graphics.Blit(src, A, bokehSampleMat);
			bokehSampleMat.SetFloat("_Direction", rot + (Mathf.PI * 2.0f / 3.0f));
			Graphics.Blit(A, B, bokehSampleMat);
			bokehSampleMat.SetFloat("_Direction", rot + (Mathf.PI * 4.0f / 3.0f));
			Graphics.Blit(B, A, bokehSampleMat);
			bokehFinalMat.SetTexture("_Bokeh", A);
			float _blurStart = startBlur / cam.farClipPlane;
			float _blurSize = 1f / (blurSize / cam.farClipPlane);
			bokehFinalMat.SetFloat("_BlurStart", _blurStart);
			bokehFinalMat.SetFloat("_BlurSize", _blurSize);
			Graphics.Blit(src, des, bokehFinalMat);
			RenderTexture.ReleaseTemporary(A);
			RenderTexture.ReleaseTemporary(B);
		}
	}
}