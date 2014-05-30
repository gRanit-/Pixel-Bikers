
// UNIFORMS
/////////////////////////////////////////////////////////////////
uniform highp mat4      u_mvpMatrix;
uniform sampler2D       u_samplers2D1;

//uniform highp vec2 u_texCoord;
/////////////////////////////////////////////////////////////////
varying highp vec2 v_texCoord;
lowp vec4 textureColor;
void main()
{

    
    
    
    //textureColor = texture2D(u_samplers2D1,vec2(v_texCoord.x,v_texCoord.y));
    textureColor = texture2D(u_samplers2D1,v_texCoord);
    gl_FragColor = textureColor;
    
    
    
    
}
