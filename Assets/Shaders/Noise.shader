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

        void surf (Input IN, inout SurfaceOutput o) 
		{
			float barrier = 0.95;
			float3 n0;

			float radius = 10; //radius

			n0.z = asin(clamp(IN.worldPos.y / radius, -1, 1));

			float r = sqrt(IN.worldPos.x * IN.worldPos.x + IN.worldPos.z * IN.worldPos.z);
			float k1 = 1;// (1 - step(r, 0));

			n0.x = k1 * asin(clamp(IN.worldPos.z / r, -1, 1));

			n0.x += 3.1415 / 2;			
			
			float k = step(IN.worldPos.x, 0);
			n0.x = 2 * 3.1415 * k + (1 - 2*k) * n0.x;//n0.x Э [0, 2pi]
			float alpha = n0.x + _Shift;

			//n0.x /= 3.1415;			
			 
			//clip(IN.worldPos.x);
			//clip(n0.x);
			//clip(1 - n0.x);

			float d = 1;
			float delta_b = d /10;
			float delta_a = d / 10;// (d / r);
			
			n0.x = k1 * floor(n0.x / delta_a);
			n0.z = floor(n0.z / delta_b);

			/////////////////////////////////////

			n0.y = 0;
			//n0.xy = Change(alpha, 80 * radius);

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
