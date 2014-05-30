//
//  ParticleShader.vsh
//  
//

/////////////////////////////////////////////////////////////////
// VERTEX ATTRIBUTES
/////////////////////////////////////////////////////////////////
attribute vec3 a_emissionPosition;
attribute vec2 a_size;
attribute vec2 a_emissionAndDeathTimes;
attribute highp float vangle;
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

varying highp float varangle;


void main()
{
    varangle=vangle-90.0;
   
    gl_Position=u_mvpMatrix * vec4(a_emissionPosition, 1.0);
    gl_PointSize = a_size.x;
   
    
    
    
    
  /*
   v_particleOpacity = max(0.0, min(1.0,
      (a_emissionAndDeathTimes.y - u_elapsedSeconds) /
      max(a_size.y, 0.00001)));
   */
   
   
   
}
