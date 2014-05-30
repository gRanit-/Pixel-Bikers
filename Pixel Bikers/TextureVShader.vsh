

/////////////////////////////////////////////////////////////////
// VERTEX ATTRIBUTES
/////////////////////////////////////////////////////////////////
attribute vec3 a_emissionPosition;
attribute vec2 a_textureCoordinates;
/////////////////////////////////////////////////////////////////
// UNIFORMS
/////////////////////////////////////////////////////////////////
uniform highp mat4      u_mvpMatrix;
uniform sampler2D       u_samplers2D1;
/////////////////////////////////////////////////////////////////
varying highp vec2 v_texCoord;


void main()
{
    
    v_texCoord=a_textureCoordinates;
    gl_Position=u_mvpMatrix * vec4(a_emissionPosition, 1.0);
   
}
