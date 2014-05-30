//
//  Sprite.h
//  Pixel Bikers
//
//  Created by Wojciech Granicki on 20.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "VertexManager.h"
@class  AGLKVertexAttribArrayBuffer;
@interface Sprite : NSObject <GLKNamedEffect>


@property (strong, nonatomic) GLKEffectPropertyTexture *texture2d0;
@property (strong, nonatomic) GLKEffectPropertyTransform *transform;
@property(strong, nonatomic) GLKBaseEffect* spriteEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer *vertexBuffer;
@property (strong,nonatomic) NSMutableData* spriteAttributesData;
@property(weak,nonatomic) NSTimer* timer;



-(float)getAngle;
-(void)moveRight;
-(void)moveLeft;
-(void)updatePosition;
-(void)touchesLeftBegan;
-(void)touchesRightBegan;
-(void)touchesEnded:(NSSet*)touches  withEvent:(UIEvent*)event;
-(id)init;
- (void)prepareToDraw;
- (void)draw;







@end
