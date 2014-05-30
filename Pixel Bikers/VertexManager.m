//
//  VertexManager.m
//  Curves
//
//  Created by Wojciech Granicki on 12.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import "VertexManager.h"

@implementation VertexManager



+(GLKVector3)SceneVector3UnitNormal:(GLKVector3)vectorA vectorB:(GLKVector3)vectorB
{
    return GLKVector3Normalize(
                               GLKVector3CrossProduct(vectorA, vectorB));
}

+(GLKVector3) SceneTriangleFaceNormal:(Triangle) triangle
{
    GLKVector3 vectorA = GLKVector3Subtract(
                                            triangle.vertices[1].positionCoords,
                                            triangle.vertices[0].positionCoords);
    GLKVector3 vectorB = GLKVector3Subtract(
                                            triangle.vertices[2].positionCoords,
                                            triangle.vertices[0].positionCoords);
    
    return [VertexManager SceneVector3UnitNormal:vectorA vectorB:vectorB];
}

+(Triangle)SceneTriangleMake:(SceneVertex)vectorA vectorB:(SceneVertex)vectorB vectorC:(SceneVertex)vectorC
{
    Triangle _tr;
    _tr.vertices[0]=vectorA;
    _tr.vertices[1]=vectorB;
    _tr.vertices[2]=vectorC;
    return _tr;
}

+(SceneVertex) makeSceneVertex:(GLKVector3)vertex withNormal:(GLKVector3)normal andTexturePos:(GLKVector2)texturePos
{
    SceneVertex v;
    v.positionCoords=vertex;
    v.normal=normal;
    v.textureCoords=texturePos;
    
    return v;
}

+(void) SceneTrianglesUpdateFaceNormals:(Triangle*)triangles
{
    int i;
    
    for (i=0; i<120; i++)
    {
        GLKVector3 faceNormal = [VertexManager SceneTriangleFaceNormal:triangles[i]];
        triangles[i].vertices[0].normal = faceNormal;
        triangles[i].vertices[1].normal = faceNormal;
        triangles[i].vertices[2].normal = faceNormal;
    }
}

+(Square) getSquare
{
    Square square;
    square.angle=0.0;
    square.speed=0.02;
    square.translationVector=GLKVector3Make(0.0f,0.0f,0.0f);
    
    Triangle triangles[2];
    triangles[0].vertices[0]=[VertexManager makeSceneVertex:GLKVector3Make(0.0f, 0.0f, 0.0f)    //A
                                           withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                        andTexturePos:GLKVector2Make(0.0f, 0.0f)];
    
    triangles[0].vertices[1]=[VertexManager makeSceneVertex:GLKVector3Make(1.0f, 0.0f, 0.0f)    //B
                                           withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                        andTexturePos:GLKVector2Make(10.5f, 0.0f)];

    
    triangles[0].vertices[2]=[VertexManager makeSceneVertex:GLKVector3Make(1.0f, 1.0f, 0.0f)    //C
                                           withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                        andTexturePos:GLKVector2Make(10.5f, 10.5f)];

    triangles[1].vertices[2]=[VertexManager makeSceneVertex:GLKVector3Make(0.0f, 1.0f, 0.0f)    //D
                                           withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                        andTexturePos:GLKVector2Make(0.0f, 10.5f)];
    
    
    triangles[1].vertices[0]=triangles[0].vertices[0];
    triangles[1].vertices[1]=triangles[0].vertices[2];
    
    GLKVector3 facenormal;
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[0]];
    triangles[0].vertices[0].normal=triangles[0].vertices[1].normal=triangles[0].vertices[2].normal=facenormal;
    
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[1]];
    triangles[0].vertices[0].normal=triangles[1].vertices[1].normal=triangles[2].vertices[2].normal=facenormal;
    
    square.triangles[0]=triangles[0];
    square.triangles[1]=triangles[1];
    
    return square;
}

+(Square)getSquareAt:(GLKVector3)A B:(GLKVector3)B C:(GLKVector3)C D:(GLKVector3)D
{
    Square square;
    square.angle=0.0;
    square.speed=0.02;
    square.alphaColor=0.2f;
    square.translationVector=GLKVector3Make(0.0f,0.0f,0.0f);
    Triangle triangles[2];
    triangles[0].vertices[0]=[VertexManager makeSceneVertex:A    //A
                                                 withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                              andTexturePos:GLKVector2Make(0.0, 0.0)];
    
    triangles[0].vertices[1]=[VertexManager makeSceneVertex:B    //B
                                                 withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                              andTexturePos:GLKVector2Make(9.5f, 0.0)];
    
    
    triangles[0].vertices[2]=[VertexManager makeSceneVertex:C    //C
                                                 withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                              andTexturePos:GLKVector2Make(9.5f, 9.5f)];
    
    triangles[1].vertices[2]=[VertexManager makeSceneVertex:D    //D
                                                 withNormal:GLKVector3Make(0.0f, 0.0f, 0.0f)
                                              andTexturePos:GLKVector2Make(0.0, 9.5f)];
    
    
    triangles[1].vertices[0]=triangles[0].vertices[0];
    triangles[1].vertices[1]=triangles[0].vertices[2];
    
    GLKVector3 facenormal;
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[0]];
    triangles[0].vertices[0].normal=triangles[0].vertices[1].normal=triangles[0].vertices[2].normal=facenormal;
    
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[1]];
    triangles[0].vertices[0].normal=triangles[1].vertices[1].normal=triangles[2].vertices[2].normal=facenormal;
    
    square.triangles[0]=triangles[0];
    square.triangles[1]=triangles[1];
    
    return square;


}
+(Square)getSquareFromSceneVertices:(SceneVertex)A B:(SceneVertex)B C:(SceneVertex)C D:(SceneVertex)D
{
    Square square;
    square.angle=0.0;
    square.speed=0.02;
    Triangle triangles[2];
    square.translationVector=GLKVector3Make(0.0f,0.0f,0.0f);
    
    triangles[0].vertices[0]=A;
    triangles[0].vertices[1]=B;
    triangles[0].vertices[2]=C;
    triangles[1].vertices[2]=D;
    
    triangles[1].vertices[0]=triangles[0].vertices[0];
    triangles[1].vertices[1]=triangles[0].vertices[2];
    
    GLKVector3 facenormal;
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[0]];
    triangles[0].vertices[0].normal=triangles[0].vertices[1].normal=triangles[0].vertices[2].normal=facenormal;
    
    facenormal=[VertexManager SceneTriangleFaceNormal:triangles[1]];
    triangles[0].vertices[0].normal=triangles[1].vertices[1].normal=triangles[2].vertices[2].normal=facenormal;
    
    square.triangles[0]=triangles[0];
    square.triangles[1]=triangles[1];
    
    return square;
}
+(Square)getSquareAtPoint:(GLKVector3)point //lewy dolny wierzcholek
{
    GLKVector3 v1=GLKVector3Make(point.x, point.y, point.z);
    GLKVector3 v2=GLKVector3Make(point.x+1.0f, point.y, point.z);
    GLKVector3 v3=GLKVector3Make(point.x+1.0f, point.y+1.0f, point.z);
    GLKVector3 v4=GLKVector3Make(point.x, point.y+1.0f, point.z);
    
    return [VertexManager getSquareAt:v1 B:v2 C:v3 D:v4];
}



+(Square*) specialEffectSquares
{
    
    /*
            ******
            *    *
            ******
                ******
                *    *
                ******
        ******     ******
        *    *     *    *
        ******     ******
                        ******
                        *    *
                        ******

     
     */
    GLKVector3 A=GLKVector3Make(0.0f, 0.0f, 0.0f);
    GLfloat x1=A.x;
    GLfloat y1=A.y;

    Square* squares=malloc(10*sizeof(Square));
    
    //3 dolne //rysuje w dol od A
    for(int k=1;k<4;k++){
        Square square=[VertexManager getSquareAtPoint:GLKVector3Make(x1-k,y1-k,0.0f)];
        squares[k-1]=square;
    }
    
    //3 gorne //rysuje w gore od D
    for(int k=1;k<4;k++){
        Square square=[VertexManager getSquareAtPoint:GLKVector3Make(x1-k,y1+k,0.0f)];
        squares[k+2]=square;
    }
    
    //4 srodkowe
    //gorne 2 //rysuje w gore
        
    squares[6]=[VertexManager getSquareAtPoint:GLKVector3Make(x1-2.0f, 0.5f, 0.0f)];
    squares[7]=[VertexManager getSquareAtPoint:GLKVector3Make(x1-3.0f, 1.0f, 0.0f)];
    
    //dolne 2 //rysuje w dol
    
    squares[8]=[VertexManager getSquareAtPoint:GLKVector3Make(x1-2.0f, 0.0f, 0.0f)];
    squares[9]=[VertexManager getSquareAtPoint:GLKVector3Make(x1-3.0f, -1.0f, 0.0f)];
    
    
    
    
    return squares;

}

+(Square**)  backgroundSquaresWithWidth:(int)Width andHeight:(int)Height paintWith:(Color*)colors
{
    
    Square** squares;
    squares=(Square**)malloc(Width*sizeof(Square));
    for (int i = 0; i < Width; i++)
        squares[i] = (Square*) malloc(Height*sizeof(Square));
    

    for(int i=0;i<Width;i++)
        for(int k=0;k<Height; k++){
            squares[i][k]=[VertexManager getSquareAtPoint:GLKVector3Make(i, k, 0.0f)];
            if(colors!=nil){
                int colorNumber=(i)%2;//(i+k)%2 dla mieszanych kratek
                squares[i][k].color=colors[colorNumber];
            }
        }
    
    

    return squares;
}

+(Color)getRedColor
{
    Color Red;
    Red.Red=1.0f;
    Red.Green=45.0f/255.0f;
    Red.Blue=85.0f/255.0f;
    return Red;
}

+(Color)getBlueColor
{
    Color Blue;
    Blue.Red=0.0f;
    Blue.Green=122.0f/255.0f;
    Blue.Blue=1.0f;
    return Blue;
}
+(GLfloat) modulo:(GLfloat)number max:(GLfloat)max
{
    GLfloat result = 0.0;
    while(number>=max)
        number-=max;
    while(number<0.0f)
        number+=max;
    result=fabsf(number);
    return result;
}

@end
