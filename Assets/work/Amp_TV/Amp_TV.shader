// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASETemplateShaders/Amp_TV"
{
	Properties
	{
		_MonaLisa("MonaLisa", 2D) = "white" {}
		_Float1("Float 1", Float) = 40
		_Float2("Float 2", Float) = 40
		_Float3("Float 3", Range( -0.5 , 0.5)) = 0
		_Float0("Float 0", Float) = 0
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Geometry" "RenderPipeline"="LightweightPipeline" }
		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
		
		Pass
		{
			Tags { "LightMode"="LightweightForward" }
			Name "Base"
			
			Blend One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			
		    HLSLPROGRAM
		    // Required to compile gles 2.0 with standard srp library
		    #pragma prefer_hlslcc gles
		    #pragma exclude_renderers d3d11_9x
		
		    #pragma vertex vert
		    #pragma fragment frag
		
			

		    // Lighting include is needed because of GI
		    #include "LWRP/ShaderLibrary/Core.hlsl"
		    #include "LWRP/ShaderLibrary/Lighting.hlsl"
		    #include "CoreRP/ShaderLibrary/Color.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
			
			uniform sampler2D _MonaLisa;
			uniform float _Float2;
			uniform float _Float0;
			uniform float _Float3;
			uniform float _Float1;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
					
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
	
		    struct GraphVertexOutput
		    {
		        float4 position : POSITION;
				float4 ase_texcoord : TEXCOORD0;
		        UNITY_VERTEX_INPUT_INSTANCE_ID
		    };
		
		    GraphVertexOutput vert (GraphVertexInput v )
			{
		        GraphVertexOutput o = (GraphVertexOutput)0;
		        UNITY_SETUP_INSTANCE_ID(v);
		        UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				v.vertex.xyz +=  float3( 0, 0, 0 ) ;
				v.ase_normal =  v.ase_normal ;
		        o.position = TransformObjectToHClip(v.vertex.xyz);
		        return o;
			}
		
		    half4 frag (GraphVertexOutput IN) : SV_Target
		    {
		        UNITY_SETUP_INSTANCE_ID(IN);
				float2 uv23 = IN.ase_texcoord.xy * float2( 0.86,0.68 ) + float2( 0,0 );
				float4 transform26 = mul(unity_WorldToObject,float4( uv23, 0.0 , 0.0 ));
				float2 temp_cast_1 = (( ( ( _Time.y * _Float2 ) + transform26.y ) * _Float0 )).xx;
				float simplePerlin2D39 = snoise( temp_cast_1 );
				float2 temp_cast_2 = (( _Time.y * _Float1 )).xx;
				float simplePerlin2D47 = snoise( temp_cast_2 );
				float4 appendResult5 = (float4(( ( (simplePerlin2D39*_Float3 + _Float3) * pow( simplePerlin2D47 , 2.0 ) ) + transform26.x ) , transform26.y , 0.0 , 0.0));
				
		        float3 Color = ( tex2D( _MonaLisa, appendResult5.xy ) * ( saturate( sin( ( ( transform26.y + ( _Time.y * 2.0 ) ) * 200.0 ) ) ) * 2.0 ) ).rgb;
		        float Alpha = 1;
		        float AlphaClipThreshold = 0;
		#if _AlphaClip
		        clip(Alpha - AlphaClipThreshold);
		#endif
		    	return half4(Color, Alpha);
		    }
		    ENDHLSL
		}
		
		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			
			HLSLPROGRAM
			#pragma prefer_hlslcc gles
    
			#pragma multi_compile_instancing

			#pragma vertex vert
			#pragma fragment frag

			#include "LWRP/ShaderLibrary/Core.hlsl"
			
			
			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			GraphVertexOutput vert (GraphVertexInput v)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;
				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag (GraphVertexOutput IN ) : SV_Target
		    {
		    	UNITY_SETUP_INSTANCE_ID(IN);

				

				float Alpha = 1;
				float AlphaClipThreshold = AlphaClipThreshold;
				
				#if _AlphaClip
					clip(Alpha - AlphaClipThreshold);
				#endif
				return Alpha;
				return 0;
		    }
			ENDHLSL
		}
	}	
	FallBack "Hidden/InternalErrorShader"
	
	CustomEditor "ASEMaterialInspector"
	
}
/*ASEBEGIN
Version=15500
0;94;563;365;1631.793;736.2626;2.57186;False;False
Node;AmplifyShaderEditor.TimeNode;35;-1505.217,114.0551;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-1579.854,-110.9337;Float;False;Property;_Float1;Float 1;1;0;Create;True;0;0;False;0;40;300;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;45;-961.0943,-404.4792;Float;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;-1709.446,-500.8864;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-1859.696,-573.0129;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1.8;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-786.3444,5.134123;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;39;-1256.777,-743.4445;Float;True;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-1588.507,-441.2632;Float;False;Property;_Float0;Float 0;4;0;Create;True;0;0;False;0;0;4.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1279.507,-477.2632;Float;False;Property;_Float3;Float 3;3;0;Create;True;0;0;False;0;0;0.15;-0.5;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-738.2185,-575.0625;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-611.4464,0.4030688;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1260.02,61.40718;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-1995.94,-431.878;Float;False;Property;_Float2;Float 2;2;0;Create;True;0;0;False;0;40;1.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-964.0524,-2.45898;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;200;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;47;-1167.747,-317.0537;Float;True;Simplex2D;1;0;FLOAT2;300,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;5;-430.9363,-300.3259;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;23;-2247.298,-272.3837;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.86,0.68;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;38;-2117.047,-660.3895;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-293.8687,-32.65674;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-251.3059,-406.0866;Float;True;Property;_MonaLisa;MonaLisa;0;0;Create;True;0;0;False;0;8a4569df886e73e41a7c73caaa89ba5a;8a4569df886e73e41a7c73caaa89ba5a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;67.07253,-149.0218;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-694.7397,-337.1819;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1349.282,-319.9962;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;300;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-1446.589,-607.8476;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;48;-1576.814,-316.9881;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-1099.207,0.6902888;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;70;-1003.507,-676.2632;Float;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldToObjectTransfNode;26;-1927.442,-251.8212;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;0,0;Float;False;False;2;Float;ASEMaterialInspector;0;3;ASETemplateShaders/LightWeightSRPUnlit;e2514bdcf5e5399499a9eb24d175b9db;0;1;DepthOnly;0;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque;Queue=Geometry;RenderPipeline=LightweightPipeline;True;2;0;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;233.4938,2.599998;Float;False;True;2;Float;ASEMaterialInspector;0;3;ASETemplateShaders/Amp_TV;e2514bdcf5e5399499a9eb24d175b9db;0;0;Base;5;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque;Queue=Geometry;RenderPipeline=LightweightPipeline;True;2;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;;0;0;Standard;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;0
WireConnection;45;0;47;0
WireConnection;36;0;37;0
WireConnection;36;1;26;2
WireConnection;37;0;38;2
WireConnection;37;1;61;0
WireConnection;30;0;31;0
WireConnection;39;0;68;0
WireConnection;44;0;70;0
WireConnection;44;1;45;0
WireConnection;28;0;30;0
WireConnection;33;0;35;2
WireConnection;31;0;32;0
WireConnection;47;0;50;0
WireConnection;5;0;46;0
WireConnection;5;1;26;2
WireConnection;7;0;28;0
WireConnection;3;1;5;0
WireConnection;27;0;3;0
WireConnection;27;1;7;0
WireConnection;46;0;44;0
WireConnection;46;1;26;1
WireConnection;50;0;48;2
WireConnection;50;1;60;0
WireConnection;68;0;36;0
WireConnection;68;1;69;0
WireConnection;32;0;26;2
WireConnection;32;1;33;0
WireConnection;70;0;39;0
WireConnection;70;1;71;0
WireConnection;70;2;71;0
WireConnection;26;0;23;0
WireConnection;0;0;27;0
ASEEND*/
//CHKSM=195F89AFAFB477095863DBC9AB703B9064C535D7