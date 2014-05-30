//
//  ViewController.h
//  Pixel Bikers
//
//  Created by Wojciech Granicki on 19.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
@class  AGLKVertexAttribArrayBuffer;
@class  Sprite;
@interface ViewController : GLKViewController


@property (strong, nonatomic) GLKBaseEffect* baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer* vertexBuffer;
@property (strong, nonatomic) GLKTextureInfo* bikerTexture;
@property (strong, nonatomic) GLKTextureInfo* roadTexture;
@property (strong, nonatomic) Sprite *playerSprite;
@property (strong,nonatomic)  NSMutableArray* players;
@property(strong,nonatomic) NSTimer* timer;





@end
