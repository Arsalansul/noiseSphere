Shader "Custom/Noise"
{
     Properties {
        _HTex ("heightMap texture", 2D) = "white" {}
		_Shift("Shift", Float) = 0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
        LOD 2048
        
        CGPROGRAM
        #pragma surface surf Lambert
		
        struct Input {
            float2 uv_HTex;
			float3 worldPos;
        };

		float hash( float n )
		{
		    return frac(sin(n)*43758.5453);
		}
			
		float noise( float3 x )
		{
		    // The noise function returns a value in the range -1.0f -> 1.0f
		
		    float3 p = floor(x);
		    float3 f = frac(x);
					
		    f = f*f*(3.0-2.0*f);
		    float n = p.x + p.y*57.0 + 113.0*p.z;
		
		    return lerp(lerp(lerp( hash(n+0.0), hash(n+1.0),f.x),
		                   lerp( hash(n+57.0), hash(n+58.0),f.x),f.y),
		               lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
		                   lerp( hash(n+170.0), hash(n+171.0),f.x),f.y),f.z);
		}

		float2 Change(float x, float r)
		{
			float2 p;
			p.x = r + r * cos(x);
			p.y = r + r * sin(x);
			return p;
		}
		
		float _Shift;

#define M_PI 3.1415926535897932384626433832795
#define M_2PI 6.283185307179586476925286766559
#define M_PI2 1.5707963267948966192313216916398

        void surf (Input IN, inout SurfaceOutput o) 
		{
			int N = 100; //кол-во колец
			float3 n0; //вектов в сферических координатах который передаем в функцию шума

			float radius = 10; //radius сферы

			float r = sqrt(IN.worldPos.x * IN.worldPos.x + IN.worldPos.z * IN.worldPos.z);
						
			float delta_b = M_2PI / N; //шаг в плоскости XY

			float k = 1;// (1 - step(r, 0));

			float3 n_start; //можно удалить
			n_start.x = IN.worldPos.x * cos(0) - IN.worldPos.z * sin(0);
			n_start.z = IN.worldPos.x * sin(0) + IN.worldPos.z * cos(0);
			n_start.y = IN.worldPos.y;

			///////////////////////
			n0.z = k * asin(clamp(n_start.y / radius, -1, 1)); //угол в плоскости XY
			
			float h = floor(n0.z / delta_b); //считаем на каком кольце находимся
			int N1 = floor(N * cos(delta_b * h)); //кол-во сегментов на текущем кольце
			int N2 = floor(N * cos(delta_b * clamp(h - 1, 0, h))); //кол-во сегментов на предыдущем кольце
			float delta_a = M_2PI / N1; //шаг в плоскости XZ (на кольце)
			float shift = delta_a * (N2 - N1) / 2; //поворот колец

			///////////////////////
			n0.x = k * asin(clamp(n_start.z / r, -1, 1));
			n0.x += M_PI2;
			
			float kx = step(n_start.x, 0);
			n0.x = M_2PI * kx + (1 - 2 * kx) * n0.x;//n0.x Э [0, 2pi]
			n0.x += +shift * _Shift;

			///////////////////////
			float alpha = n0.x;			
			 
			//clip(IN.worldPos.x);
			//clip(_Shift - n0.x);
			//clip(_Shift - n0.z);

			
			n0.x = k * floor(n0.x / delta_a);
			n0.z = floor (n0.z / delta_b);

			/////////////////////////////////////

			n0.y = 0;
			n0.xy = Change(alpha,  radius);
					   
			float n = noise (n0);

			half3 c;
			c.r = n;
			c.g = n;
			c.b = n;
			
            o.Albedo = c;
            
        }
        ENDCG
    } 
    FallBack "Diffuse"
}
