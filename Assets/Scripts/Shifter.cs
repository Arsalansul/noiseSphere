using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class Shifter : MonoBehaviour
{
    [Range(0, 6.29f)]
    public float shift;

    private Material mat;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(mat == null)
        {
            Renderer r = GetComponent<Renderer>();
            if (r != null) mat = r.material;
        }

        if (mat == null) return;

        mat.SetFloat("_Shift", shift);
    }
}
