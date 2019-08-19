Shader "Custom/Noise"
{
     Properties {
        _HTex ("heightMap texture", 2D) = "white" {}
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
			
        void surf (Input IN, inout SurfaceOutput o) 
		{
			float3 n0;
			float r = sqrt(IN.worldPos.z * IN.worldPos.z + IN.worldPos.x * IN.worldPos.x);

			n0.x = asin(clamp(IN.worldPos.z / r, -1, 1));
			n0.x += 3.1415 / 2;			
			
			float k = step(IN.worldPos.x, 0);
			n0.x = 2 * 3.1415 * k + (1 - 2*k) * n0.x;//n0.x Э [0, 2pi]

			//n0.x /= 3.1415;
			n0.x = n0.x % (2 * 3.1415);
			n0.y = asin(clamp(IN.worldPos.y / 10, -1, 1));
			n0.z = 10; //radius
			 
			//clip(IN.worldPos.x);
			//clip(n0.x);
			//clip(1 - n0.x);

			float d = 1;
			float delta_b = d /10;
			float delta_a = d;// d / sqrt(100 - IN.worldPos.y*IN.worldPos.y);
			
			n0.x = floor(n0.x/ delta_a);
			n0.y = floor(n0.y / delta_b);

			/////////////////////////////////////
			n0.x = cos(n0.x);
			n0.y = sin(n0.y);

			float n = noise (n0);
			half3 c;
			c.r = n;
			c.g = n;
			c.b = n;
			
			/*c.r = n0.x;
			c.g = 0;
			c.b = 0;*/
			
            o.Albedo = c;
            
        }
        ENDCG
    } 
    FallBack "Diffuse"
}
