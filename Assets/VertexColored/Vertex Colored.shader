// 方法一
Shader "Custom/VertexColor" {
	Category {
	     BindChannels { 
	         Bind "Color", color 
	         Bind "Vertex", vertex
	     }
	     SubShader { Pass { } }
	 }
 }

// 方法二
//Shader "Custom/Vertex Colored" {
//     SubShader {
//         Pass {
//                 ColorMaterial AmbientAndDiffuse
//         }
//     } 
//}