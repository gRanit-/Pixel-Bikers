//
//  OpenGLES_Ch2_3ViewController.m
//  OpenGLES_Ch2_3
//

#import "ViewController.h"

#import "AGLKContext.h"

#import "Sprite.h"
#import "AGLKVertexAttribArrayBuffer.h"

@interface GLKEffectPropertyTexture (AGLKAdditions) //(AGLKAddition) -kategoria sposob na rozszerzanie istniejacych klas

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end







@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;
{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(
                    self.target,
                    parameterID,
                    value);
}

@end



@implementation ViewController

Square**board;
Square testSquare;
int boardWidth,boardHight;
GLuint program;
GLint u_mvpMatrix;
GLint u_samplers2D1;
GLint u_texCoord;

-(void)initialisation
{
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_FALSE;
    self.baseEffect.constantColor = GLKVector4Make(
                                                   0.0f, // Red
                                                   1.0f, // Green
                                                   0.0f, // Blue
                                                   1.0f);// Alpha

    NSString * path = [[NSBundle bundleForClass:[self class]]
            pathForResource:@"bike4" ofType:@"png"];
    
    NSAssert(nil != path, @"Biker texture image not found");  
    self.bikerTexture=[GLKTextureLoader textureWithContentsOfFile:path options:nil error:NULL];
    
    self.playerSprite=[[Sprite alloc]init];
    self.playerSprite.texture2d0.name=self.bikerTexture.name;
    self.playerSprite.texture2d0.target=self.bikerTexture.target;
    self.players=[[NSMutableArray alloc]initWithObjects:self.playerSprite, nil];
    
    
    
    [(AGLKContext *)view.context setClearColor:
     GLKVector4Make(1.0f, 0.2f, 0.2f, 1.0f)];
    [(AGLKContext *)view.context enable:GL_DEPTH_TEST];
    [(AGLKContext *)view.context enable:GL_BLEND];
    [(AGLKContext *)view.context
     setBlendSourceFunction:GL_SRC_ALPHA
     destinationFunction:GL_ONE_MINUS_SRC_ALPHA];
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(updatePosition) userInfo:nil repeats:YES];
    //0.033
    Color color;
    color.Red=0.0;
    color.Blue=0.0;
    color.Green=0.0;
    color.Alpha=1.0;
    Color colors[2];
    colors[0]=color;
    colors[1]=color;
   
    boardWidth=(int)(512*1.775000);
    boardHight=512;
    
   // testSquare=[VertexManager getSquareAtPoint:GLKVector3Make(boardWidth/4,-256, 0.0)];
    testSquare=[VertexManager getSquareAt:GLKVector3Make(-256*1.775000,-256.0,0.0) B:GLKVector3Make(256*1.775000,-256.0,0.0) C:GLKVector3Make(256*1.775000,256.0,0.0) D:GLKVector3Make(-256*1.775000,256.0,0.0)];
    CGImageRef imageRef =
    [[UIImage imageNamed:@"road1.png"] CGImage];
    NSAssert(imageRef!=NULL && imageRef!=nil,(@"Couldnt load image"));
    self.roadTexture = [GLKTextureLoader
                                   textureWithCGImage:imageRef
                                   options:nil
                                   error:NULL];
    
    self.baseEffect.texture2d0.name = self.roadTexture.name;
    self.baseEffect.texture2d0.target = self.roadTexture.target;
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(testSquare.triangles) / sizeof(SceneVertex)
                         bytes:testSquare.triangles
                         usage:GL_STATIC_DRAW];
    
  //  [self.baseEffect.texture2d0     aglkSetParameter:GL_TEXTURE_WRAP_S value:(GL_REPEAT)];
     //board=[VertexManager backgroundSquaresWithWidth:512*1.775000 andHeight:512 paintWith:colors];
    NSLog(@"initialisation performed");
   // glEnable(GL_BLEND);
   // glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
}


/////////////////////////////////////////////////////////////////
// Called when the view controller's view is loaded
// Perform initialization before the view is asked to draw
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialisation];
    
    
}

-(void)updatePosition
{
    
    for(Sprite* player in self.players)
        [player updatePosition];

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    
       const GLfloat  aspectRatio =
    (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    
    
    
    [(AGLKContext *)view.context clear:
     GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    
    [self preparePointOfViewWithAspectRatio:aspectRatio];
    

    [self prepareToDraw];
    [self draw];
    
    //program=0;
    for(Sprite* playerSprite in self.players){
        playerSprite.transform.modelviewMatrix =
        self.baseEffect.transform.modelviewMatrix;
        
        GLKMatrix4 matrix=self.baseEffect.transform.projectionMatrix;
     //   GLKMatrix4Rotate(matrix, GLKMathDegreesToRadians([playerSprite getAngle]), 0.0, 1.0, 0.0);
        
        playerSprite.transform.projectionMatrix=matrix;

        [playerSprite prepareToDraw];
        [playerSprite draw];
    
      //  [self.baseEffect prepareToDraw];
    }
    // ToDo: any other drawing here
    
#ifdef DEBUG
    {  // Report any errors
        GLenum error = glGetError();
        if(GL_NO_ERROR != error)
        {
            NSLog(@"GL Error: 0x%x", error);
        }
    }
#endif
    
}



- (void)preparePointOfViewWithAspectRatio:(GLfloat)aspectRatio
{
    // Do this here instead of -viewDidLoad because we don't
    // yet know aspectRatio in -viewDidLoad.
    //self.baseEffect.transform.projectionMatrix =
    NSLog(@"%f",aspectRatio);
    GLKMatrix4 ortho =GLKMatrix4MakeOrtho(-256*aspectRatio, 256*aspectRatio, -256, 256, 0.0f, 1.0f);
    self.baseEffect.transform.projectionMatrix =ortho;
  /*  GLKMatrix4MakePerspective(
                              GLKMathDegreesToRadians(85.0f),// Standard field of view
                              aspectRatio,
                              0.1f,   // Don't make near plane too close
                              20.0f); // Far arbitrarily far enough to contain scene
    
    // Set initial point of view to reasonable arbitrary values
    // These values make most of the simulated rink visible
    self.baseEffect.transform.modelviewMatrix =
    GLKMatrix4MakeLookAt(
                         0.0, 0.0, 1.0,   // Eye position
                         0.0, 0.0, 0.0,   // Look-at position
                         0.0, 1.0, 0.0);  // Up direction*/
    
}


- (IBAction)actionBegin:(id)sender forEvent:(UIEvent *)event
{NSLog(@"Long action");
    if([[sender currentTitle]isEqualToString:@"Left1"]){
        [[_players objectAtIndex:0] touchesEnded:nil withEvent:nil];
        [[_players objectAtIndex:0] touchesLeftBegan];
        
        //[_player1 moveLeft];
        NSLog(@"LEFT1");
    }
    else{
        if([[sender currentTitle]isEqualToString:@"Right1"]){
            [[_players objectAtIndex:0] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:0] touchesRightBegan];
        }
        else if([[sender currentTitle]isEqualToString:@"Left2"]){
            [[_players objectAtIndex:1] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:1] touchesLeftBegan];
            
        }
        else if([[sender currentTitle]isEqualToString:@"Right2"]){
            [[_players objectAtIndex:1] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:1] touchesRightBegan];
            
            
            
            
        }
        //[_player1 moveRight];
        
        //  NSLog(@"Right");
        
    }
    
}

-(IBAction)touchUpInside:(id)sender{
    [_players objectAtIndex:0];
    
    NSLog(@"TouchUpInside");
    if([[sender currentTitle]isEqualToString:@"Left1"]){
        [[_players objectAtIndex:0] touchesEnded:nil withEvent:nil];
        [[_players objectAtIndex:0] moveLeft];
    }
    else
        if([[sender currentTitle]isEqualToString:@"Right1"]){
            [[_players objectAtIndex:0] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:0] moveRight];
        }
        else if([[sender currentTitle]isEqualToString:@"Left2"])
        {
            [[_players objectAtIndex:1] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:1] moveLeft];
        }
        else if([[sender currentTitle]isEqualToString:@"Right2"]){
            [[_players objectAtIndex:1] touchesEnded:nil withEvent:nil];
            [[_players objectAtIndex:1] moveRight];
            
        }
    // [_board playerMoved:_player1];
    
}

- (IBAction)actionEnd:(id)sender forEvent:(UIEvent *)event
{
    NSString* label=[sender currentTitle];
    
    if([label isEqualToString:@"Right1"]|| [label isEqualToString:@"Left1"])
        [[_players objectAtIndex:0] touchesEnded:nil withEvent:nil];
    else
        [[_players objectAtIndex:1] touchesEnded:nil withEvent:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
  }

-(void)prepareToDraw
{
    if(program==0)
        if([self loadShaders])
            NSLog(@"SHADERS LOADED");
        else
            NSLog(@"SHADERS COULDNT BE LOADED");
    
    
    if(program!=0)
    {
        
        glUseProgram(program);
        
        
        GLKMatrix4 modelViewProjectionMatrix=GLKMatrix4Multiply(self.baseEffect.transform.projectionMatrix, self.baseEffect.transform.modelviewMatrix);
        
        [self.vertexBuffer prepareToDrawWithAttrib:0
                               numberOfCoordinates:3
                                      attribOffset:offsetof(SceneVertex, positionCoords)
                                      shouldEnable:YES];
        
        
        [self.vertexBuffer prepareToDrawWithAttrib:1
                               numberOfCoordinates:2
                                      attribOffset:offsetof(SceneVertex, textureCoords)
                                      shouldEnable:YES];
        
        
        
        glActiveTexture(GL_TEXTURE1);
        if(0 != self.baseEffect.texture2d0.name && self.baseEffect.texture2d0.enabled)
        {
            
            
            glBindTexture(self.baseEffect.texture2d0.target, self.baseEffect.texture2d0.name);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
           
        }
        else
        {
            glBindTexture(GL_TEXTURE_2D, 0);
        }
        
        
        
        glUniformMatrix4fv(u_mvpMatrix,1,0,modelViewProjectionMatrix.m);
        glUniform1i(u_samplers2D1,1);
        //glUniform2f(u_texCoord, 0.0, 0.5f);
        

    }
    
    
}
-(void)draw
{
    glDepthMask(GL_FALSE);
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
                        startVertexIndex:0
                        numberOfVertices:6];
glDepthMask(GL_TRUE);
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
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:
                          @"TextureVShader" ofType:@"vsh"];
    NSLog(@"%@",vertShaderPathname);
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER
                        file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:
                          @"TextureFShader" ofType:@"fsh"];
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
                         "a_textureCoordinates");
    
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
    u_samplers2D1 = glGetUniformLocation(program, "u_samplers2D1");
    //u_texCoord = glGetUniformLocation(program, "u_texCoord");
    
    
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



@end
