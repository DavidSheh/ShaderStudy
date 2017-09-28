using UnityEngine;
using System.Collections;

public class PostEffectScript : MonoBehaviour {

    public Material mat;

	// Use this for initialization
	void Start () {
	
	}

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, mat);
    }
}
