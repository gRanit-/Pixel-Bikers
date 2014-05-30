//
//  Sprite.m
//  Pixel Bikers
//
//  Created by Wojciech Granicki on 20.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import "Sprite.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct

{
    
    GLKVector3 position;
    GLKVector2 size;
    float vangle;
    
   // Square square;
}
SpriteAttributes;

@implementation Sprite: NSObject 


GLuint spriteShaderProgram;
GLint u_mvpMatrix;
GLint u_samplers2D;
float angle=0;
//float speed=0.009999999999;
float speed=0.8;
//1,5
- (id)init
{
    if (nil != (self = [super init]))
    {
        
        NSLog(@"Setting up sprite");
        self.texture2d0 = [[GLKEffectPropertyTexture alloc] init];
        self.texture2d0.enabled = YES;
        self.texture2d0.name = 0;
        self.texture2d0.target = GLKTextureTarget2D;
        self.texture2d0.envMode = GLKTextureEnvModeReplace;
        self.transform = [[GLKEffectPropertyTransform alloc] init];
        self.spriteAttributesData = [NSMutableData data];
    
        SpriteAttributes newSprite;
        newSprite.position=GLKVector3Make(0.0f, 0.0f,0.0f);
        newSprite.size=GLKVector2Make(38.0f, 38.0f);
     //   newSprite.square=[VertexManager getSquare];
        [self.spriteAttributesData appendBytes:&newSprite length:sizeof(newSprite)];
        self.vertexBuffer=[[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SpriteAttributes) numberOfVertices:[self.spriteAttributesData length]/sizeof(SpriteAttributes) bytes:[self.spriteAttributesData bytes] usage:GL_DYNAMIC_DRAW];
    
        
        self.spriteEffect=[[GLKBaseEffect alloc]init];
        self.spriteEffect.useConstantColor = GL_FALSE;
    }
    
    return self;
}

-(void)prepareToDraw
{
    if(spriteShaderProgram==0)
        if([self loadShaders])
            NSLog(@"SHADERS LOADED");
        else
            NSLog(@"SHADERS COULDNT BE LOADED");

    
    if(spriteShaderProgram!=0)
    {
        
        glUseProgram(spriteShaderProgram);
       
        
        GLKMatrix4 modelViewProjectionMatrix=GLKMatrix4Multiply(self.transform.projectionMatrix, self.transform.modelviewMatrix);
        
        
        
        if(self.vertexBuffer==nil &&
           0 < [self.spriteAttributesData length])
            self.vertexBuffer=[[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SpriteAttributes) numberOfVertices:[self.spriteAttributesData length]/sizeof(SpriteAttributes) bytes:[self.spriteAttributesData bytes] usage:GL_DYNAMIC_DRAW];
        else
            [self.vertexBuffer reinitWithAttribStride:sizeof(SpriteAttributes) numberOfVertices:[self.spriteAttributesData length]/sizeof(SpriteAttributes) bytes:[self.spriteAttributesData bytes]];
        
        
        [self.vertexBuffer
         prepareToDrawWithAttrib:0
         numberOfCoordinates:3
         attribOffset:
         offsetof(SpriteAttributes, position)
         shouldEnable:YES];
        
        [self.vertexBuffer
         prepareToDrawWithAttrib:1
         numberOfCoordinates:2
         attribOffset:
         offsetof(SpriteAttributes, size)
         shouldEnable:YES];
        
        
        [self.vertexBuffer
         prepareToDrawWithAttrib:2
         numberOfCoordinates:1
         attribOffset:
         offsetof(SpriteAttributes, vangle)
         shouldEnable:YES];
        
        //[self.spriteEffect prepareToDraw];
    
        
        
        
        glActiveTexture(GL_TEXTURE0);
        if(0 != self.texture2d0.name && self.texture2d0.enabled)
        {
            
            
            glBindTexture(GL_TEXTURE_2D, self.texture2d0.name);
             glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        }
        else
        {
            glBindTexture(GL_TEXTURE_2D, 0);
        }
        glUniformMatrix4fv(u_mvpMatrix,1,0,modelViewProjectionMatrix.m);
        glUniform1i(u_samplers2D,0);
        
      
    
    }


}

- (NSUInteger)numberOfParticles;
{
    return [self.spriteAttributesData length] /
    sizeof(SpriteAttributes);
}
-(void)draw
{
    glDepthMask(GL_FALSE);  // Disable depth buffer writes
    [self.vertexBuffer
     drawArrayWithMode:GL_POINTS
     startVertexIndex:0
     numberOfVertices:self.numberOfParticles];
    glDepthMask(GL_TRUE);  // Reenable depth buffer writes

    [self.spriteEffect prepareToDraw];


}




-(void)setAngle:(int) anAngle
{
    angle=anAngle;
}

-(void)moveLeft
{
    angle+=5;

}

-(void)moveRight
{
    angle-=5;

}
-(void)touchesLeftBegan {
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(moveLeft) userInfo:nil repeats:YES];
}

-(void)touchesRightBegan{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(moveRight) userInfo:nil repeats:YES];
}
-(void)touchesEnded:(NSSet*)touches  withEvent:(UIEvent*)event {
    if (self.timer != nil)
        [self.timer invalidate];
    self.timer = nil;
}

-(void)updatePosition{
    
    NSLog(@"ANGLE=%f",angle);
    for(int i=0;i<[self.spriteAttributesData length]/sizeof(SpriteAttributes);i++){
         SpriteAttributes* spr=
        (SpriteAttributes*)[self.spriteAttributesData bytes];
        spr[i].vangle=angle;
        spr[i].position.x+=cosf(GLKMathDegreesToRadians(angle))*speed;
        spr[i].position.y+=sinf(GLKMathDegreesToRadians(angle))*speed;
        
        NSLog(@"x= %f y=%f",spr[i].position.x,spr[i].position.y);

    }
}


-(float)getAngle
{
    return angle;

}











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
    spriteShaderProgram = glCreateProgram();
    
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
    glAttachShader(spriteShaderProgram, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(spriteShaderProgram, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(spriteShaderProgram, 0,
                         "a_emissionPosition");
    glBindAttribLocation(spriteShaderProgram, 1,
                         "a_size");
    glBindAttribLocation(spriteShaderProgram, 2,"vangle");
    
    // Link program.
    if (![self linkProgram:spriteShaderProgram])
    {
        NSLog(@"Failed to link program: %d", spriteShaderProgram);
        
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
        if (spriteShaderProgram)
        {
            glDeleteProgram(spriteShaderProgram);
            spriteShaderProgram = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    u_mvpMatrix = glGetUniformLocation(spriteShaderProgram, "u_mvpMatrix");
    u_samplers2D = glGetUniformLocation(spriteShaderProgram, "u_samplers2D");

    
    // Delete vertex and fragment shaders.
    if (vertShader) 
    {
        glDetachShader(spriteShaderProgram, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) 
    {
        glDetachShader(spriteShaderProgram, fragShader);
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


@end
