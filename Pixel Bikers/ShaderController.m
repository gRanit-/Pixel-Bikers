//
//  ShaderController.m
//  Pixel Bikers
//
//  Created by Wojciech Granicki on 21.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import "ShaderController.h"

@implementation ShaderController
GLuint program;




/*



///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:
                          @"SpriteVShader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER
                        file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:
                          @"SpriteFShader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER
                        file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, 0,
                         "a_emissionPosition");
    glBindAttribLocation(program, 1,
                         "a_size");
    glBindAttribLocation(program, 2,"vangle");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    u_mvpMatrix = glGetUniformLocation(program, "u_mvpMatrix");
    u_samplers2D = glGetUniformLocation(program, "u_samplers2D");
    
    
    // Delete vertex and fragment shaders.
    if (vertShader)
    {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader)
    {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
    
    
}

/////////////////////////////////////////////////////////////////
//
- (BOOL)compileShader:(GLuint *)shader
                 type:(GLenum)type
                 file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file
                                                  encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}


/////////////////////////////////////////////////////////////////
//
- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    
    return YES;
}


/////////////////////////////////////////////////////////////////
//
- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
    {
        return NO;
    }
    
    return YES;
}

*/
@end
