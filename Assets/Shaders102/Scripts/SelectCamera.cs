using UnityEngine;

public class SelectCamera : MonoBehaviour {
    public Camera[] cameras;
    [Range(0, 2)]
    public int CameraType = 0;
    private int currType;

	// Use this for initialization
	void Start () {
        currType = 0;
        ActiveCam(currType);
    }
	
	// Update is called once per frame
	void Update () {
	    if(currType != CameraType)
        {
            currType = CameraType;
            ActiveCam(currType);
        }
	}

    private void ActiveCam(int index)
    {
        for (int i = 0; i < cameras.Length; i++)
        {
            cameras[i].gameObject.SetActive(false);
        }

        cameras[index].gameObject.SetActive(true);
    }
}
