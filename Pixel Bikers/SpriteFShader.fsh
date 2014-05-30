//
//  ParticleShader.fsh
//  
//
#define PI 3.1415926535897932384626
/////////////////////////////////////////////////////////////////
// UNIFORMS
/////////////////////////////////////////////////////////////////
uniform highp mat4      u_mvpMatrix;
uniform sampler2D       u_samplers2D;
uniform highp float     u_elapsedSeconds;

/////////////////////////////////////////////////////////////////
// Varyings
/////////////////////////////////////////////////////////////////
//varying lowp float      v_particleOpacity;
//varying highp vec2 rotatedVector;
varying highp float varangle;
void main()
{
   // highp vec2 texPos=vPosition*vaRotation;
   highp float angleRadian;
  highp  float _cos;
 highp   float _sin;
    highp vec2 center = vec2(0.5,0.5);
    highp vec2 centeredPoint = gl_PointCoord - center;
    angleRadian=varangle*PI/180.0;
    _cos=cos(angleRadian);
    _sin=sin(angleRadian);
   highp vec2 rotatedVector=vec2(centeredPoint.x*_cos-centeredPoint.y*_sin,centeredPoint.x*_sin+centeredPoint.y*_cos);
    
    
    
    lowp vec4 textureColor = texture2D(u_samplers2D, rotatedVector+center);
  // lowp vec4 textureColor = texture2D(u_samplers2D[0], rotatedVector+center);
   // textureColor.a = textureColor.a * v_particleOpacity;
    gl_FragColor = textureColor;
    


    
}
