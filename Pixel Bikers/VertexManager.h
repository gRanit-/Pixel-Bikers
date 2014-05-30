//
//  VertexManager.h
//  Curves
//
//  Created by Wojciech Granicki on 12.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface VertexManager : NSObject


typedef struct {
    GLfloat Red;
    GLfloat Green;
    GLfloat Blue;
    GLfloat Alpha;
}Color;

typedef struct {
    GLKVector3  positionCoords;//X Y Z
    GLKVector2 textureCoords;// U V
    GLKVector3  normal;//X Y Z
}SceneVertex;

typedef struct{
    SceneVertex vertices[3];
}Triangle;

typedef struct {
    SceneVertex vertices[360];
    GLfloat angle;
    GLfloat speed;
    
}CircleVertex;

typedef struct {
    SceneVertex* vertices;
    GLfloat angle1;
    GLfloat angle2;
    GLfloat R;
}SphereVertex;
struct Squ{

    Triangle triangles[2];
    GLfloat angle;
    GLfloat speed;
    GLfloat alphaColor;
    GLKVector3 translationVector;
    Color color;
};
typedef struct Squ Square;

+(Color)getRedColor;
+(Color)getBlueColor;
+(Square*) specialEffectSquares;
+(Square**)  backgroundSquaresWithWidth:(int)Width andHeight:(int)Height paintWith:(Color*)colors;
+(Square)getSquareAt:(GLKVector3)A B:(GLKVector3)B C:(GLKVector3)C D:(GLKVector3)D;
+(Square)getSquareAtPoint:(GLKVector3)point;
+(SceneVertex) makeSceneVertex:(GLKVector3)vertex withNormal:(GLKVector3)normal andTexturePos:(GLKVector2)texturePos;
+(GLfloat) modulo:(GLfloat)number max:(GLfloat)max;
+(GLKVector3)SceneVector3UnitNormal:(GLKVector3)vectorA vectorB:(GLKVector3)vectorB;
+(GLKVector3) SceneTriangleFaceNormal:(Triangle) triangle;
+(Triangle)SceneTriangleMake:(SceneVertex)vectorA vectorB:(SceneVertex)vectorB vectorC:(SceneVertex)vectorC;
+(void) SceneTrianglesUpdateFaceNormals:(Triangle*)triangles;
+(Square) getSquare;
@end
