using UnityEngine;
using System.Collections;

public class Perlin : MonoBehaviour
{
    public int pixWidth;
    public int pixHeight;
    public float xOrg;
    public float yOrg;
    public float scale = 1.0F;
    private Texture2D noiseTex;
    private Color[] pix;
    private Renderer rend;

    void Start()
    {
        rend = GetComponent<Renderer>();
        noiseTex = new Texture2D(pixWidth, pixHeight);
        pix = new Color[noiseTex.width * noiseTex.height];
        //rend.material.mainTexture = noiseTex;
        CalcNoise();
        rend.material.SetTexture("_HTex", noiseTex);
    }

    void CalcNoise()
    {
        //float y = 0.0F;
        //while (y < noiseTex.height)
        //{
        //    float x = 0.0F;
        //    while (x < noiseTex.width)
        //    {
        //        float xCoord = xOrg + x / noiseTex.width * scale;
        //        float yCoord = yOrg + y / noiseTex.height * scale;
        //        float sample = Mathf.PerlinNoise(xCoord, yCoord);
        //        pix[(int)y * noiseTex.width + (int)x] = new Color(sample, sample, sample);
        //        x++;
        //    }
        //    y++;
        //}

        for (var y = 0; y < 360; y++)
        {
            for (var x = 0; x < 180; x ++)
            {
                float xCoord = x % 90 * scale;
                float yCoord = y % 90 * scale;
                float sample = Mathf.PerlinNoise(xCoord, yCoord);
                pix[(int)y * noiseTex.width + (int)x] = new Color(sample, sample, sample);
            }
        }

        noiseTex.SetPixels(pix);
        noiseTex.Apply();
    }

    private void PerlinNoise(int x, int y)
    {

    }

    private void Update()
    {
        CalcNoise();
    }
}