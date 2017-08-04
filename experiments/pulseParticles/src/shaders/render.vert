// render.vert

precision highp float;
attribute vec3 aVertexPosition;
attribute vec3 aNormal;

uniform mat4 uModelMatrix;
uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;
uniform mat4 uShadowMatrix;

uniform sampler2D textureCurr;
uniform sampler2D textureNext;
uniform sampler2D textureExtra;
uniform float percent;
uniform vec2 uViewport;
uniform float fixSize;

varying vec4 vColor;
varying vec3 vNormal;
varying vec3 vExtra;
varying vec4 vShadowCoord;

const float radius = 0.015;

void main(void) {
	vec2 uv      = aVertexPosition.xy;
	vec3 posCurr = texture2D(textureCurr, uv).rgb;
	vec3 posNext = texture2D(textureNext, uv).rgb;
	vec3 pos     = mix(posCurr, posNext, percent);
	vec3 extra   = texture2D(textureExtra, uv).rgb;
	gl_Position  = uProjectionMatrix * uViewMatrix * uModelMatrix * vec4(pos, 1.0);

	vShadowCoord  = uShadowMatrix * vec4(pos, 1.0);
	if(extra.b <= 0.0) {
		vColor = vec4(0.0);	
	} else {
		vColor = vec4(1.0);
	}
	
	

	float distOffset = uViewport.y * uProjectionMatrix[1][1] * radius / gl_Position.w * extra.b;
	if(fixSize > 0.0) {
		gl_PointSize = fixSize;
	} else {
		gl_PointSize = distOffset * (1.0 + extra.g);
	}
    
	vExtra 		 = extra;
	vNormal 	 = aNormal;
}