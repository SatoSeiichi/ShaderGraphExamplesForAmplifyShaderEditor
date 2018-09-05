// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "ASETemplateShaders/Amp_Golf"
{
	Properties
	{
		_gage("gage", Range( 0 , 1)) = 0.5
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "black" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
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
		
			#define _AlphaClip 1


		    // Lighting include is needed because of GI
		    #include "LWRP/ShaderLibrary/Core.hlsl"
		    #include "LWRP/ShaderLibrary/Lighting.hlsl"
		    #include "CoreRP/ShaderLibrary/Color.hlsl"
		    #include "ShaderGraphLibrary/Functions.hlsl"
			
			uniform sampler2D _TextureSample0;
			uniform float _gage;
			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform sampler2D _TextureSample2;
			uniform float4 _TextureSample2_ST;
					
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
				float2 temp_cast_0 = (_gage).xx;
				float temp_output_8_0 = (1.0 + (_gage - 0.0) * (-0.01 - 1.0) / (1.0 - 0.0));
				float2 uv_TextureSample1 = IN.ase_texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 tex2DNode11 = tex2D( _TextureSample1, uv_TextureSample1 );
				float smoothstepResult6 = smoothstep( temp_output_8_0 , ( temp_output_8_0 + 0.01181978 ) , tex2DNode11.r);
				float2 uv_TextureSample2 = IN.ase_texcoord.xy * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
				float4 tex2DNode12 = tex2D( _TextureSample2, uv_TextureSample2 );
				float4 lerpResult2 = lerp( ( tex2D( _TextureSample0, temp_cast_0 ) * ( smoothstepResult6 * tex2DNode11.a ) ) , tex2DNode12 , tex2DNode12.a);
				
				float lerpResult13 = lerp( tex2DNode11.a , tex2DNode12.a , tex2DNode12.a);
				
		        float3 Color = lerpResult2.rgb;
		        float Alpha = lerpResult13;
		        float AlphaClipThreshold = 0.17;
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
			#define _AlphaClip 1

			uniform sampler2D _TextureSample1;
			uniform float4 _TextureSample1_ST;
			uniform sampler2D _TextureSample2;
			uniform float4 _TextureSample2_ST;

			struct GraphVertexInput
			{
				float4 vertex : POSITION;
				float4 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct GraphVertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			GraphVertexOutput vert (GraphVertexInput v)
			{
				GraphVertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;
				o.clipPos = TransformObjectToHClip(v.vertex.xyz);
				return o;
			}

			half4 frag (GraphVertexOutput IN ) : SV_Target
		    {
		    	UNITY_SETUP_INSTANCE_ID(IN);

				float2 uv_TextureSample1 = IN.ase_texcoord.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float4 tex2DNode11 = tex2D( _TextureSample1, uv_TextureSample1 );
				float2 uv_TextureSample2 = IN.ase_texcoord.xy * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
				float4 tex2DNode12 = tex2D( _TextureSample2, uv_TextureSample2 );
				float lerpResult13 = lerp( tex2DNode11.a , tex2DNode12.a , tex2DNode12.a);
				

				float Alpha = lerpResult13;
				float AlphaClipThreshold = 0.17;
				
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
-17;94;685;274;2678.719;514.0808;2.520296;True;False
Node;AmplifyShaderEditor.LerpOp;2;-215.162,-47.72107;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;6;-992.2878,91.51099;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;8;-1443.288,-21.48901;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;-0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-1792.556,-142.7117;Float;False;Property;_gage;gage;0;0;Create;True;0;0;False;0;0.5;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-681.2878,204.511;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;13;-316.8586,392.7195;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1573.85,178.1956;Float;False;Constant;_Float2;Float 2;0;0;Create;True;0;0;False;0;0.01181978;0.01525675;0;0.02;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1463.859,299.7195;Float;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;None;9be7c2a2efcec604abca78876aaf4512;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;12;-886.8586,472.7195;Float;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;False;0;None;a5aa13c79589d0a498ca66995750ae69;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-850.944,-205.4537;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;None;ad1f23ae927db3c4e9e375f2af4a2c7c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;10;-1232.859,143.7195;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0.01;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-514.2506,-106.909;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;34.963,172.6128;Float;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;0.17;0.04;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;28;331,18;Float;False;True;2;Float;ASEMaterialInspector;0;3;ASETemplateShaders/Amp_Golf;e2514bdcf5e5399499a9eb24d175b9db;0;0;Base;5;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque;Queue=Geometry;RenderPipeline=LightweightPipeline;True;2;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;;0;0;Standard;5;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;29;331,18;Float;False;False;2;Float;ASEMaterialInspector;0;3;ASETemplateShaders/LightWeightSRPUnlit;e2514bdcf5e5399499a9eb24d175b9db;0;1;DepthOnly;0;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderType=Opaque;Queue=Geometry;RenderPipeline=LightweightPipeline;True;2;0;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
WireConnection;2;0;3;0
WireConnection;2;1;12;0
WireConnection;2;2;12;4
WireConnection;6;0;11;0
WireConnection;6;1;8;0
WireConnection;6;2;10;0
WireConnection;8;0;9;0
WireConnection;5;0;6;0
WireConnection;5;1;11;4
WireConnection;13;0;11;4
WireConnection;13;1;12;4
WireConnection;13;2;12;4
WireConnection;4;1;9;0
WireConnection;10;0;8;0
WireConnection;10;1;15;0
WireConnection;3;0;4;0
WireConnection;3;1;5;0
WireConnection;28;0;2;0
WireConnection;28;1;13;0
WireConnection;28;2;14;0
ASEEND*/
//CHKSM=9EB6D02AD9DA69C1DD817E4BA301F80F301D5911