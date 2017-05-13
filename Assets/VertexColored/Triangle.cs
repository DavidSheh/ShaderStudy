using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class Triangle : MonoBehaviour {

	// Use this for initialization
	void Start () {
		CreateTriangle();
	}
	
	private void CreateTriangle()
	{
		Mesh mesh = new Mesh ();
		Vector3[] vertex = new Vector3[3];
		vertex [0] = new Vector3 (-1, 0, 0);
		vertex [1] = new Vector3 (1, 0, 0);
		vertex [2] = new Vector3 (0, 1, 0);

		int[] triangles = new int[3]{ 0, 2, 1 };

		Color[] colors = new Color[3]{ Color.red, Color.green, Color.blue };

		//Vector3[] normals = new Vector3[3]{ Vector3.up, Vector3.up, Vector3.up };
		//		Vector3[] normals = new Vector3[3]{ Vector3.forward, Vector3.forward, Vector3.forward };

		mesh.vertices = vertex;
		mesh.triangles = triangles;
		mesh.colors = colors;
		//mesh.normals = normals;
		mesh.RecalculateNormals ();
		GetComponent<MeshFilter> ().mesh = mesh;
	}
}
