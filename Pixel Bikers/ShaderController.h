//
//  ShaderController.h
//  Pixel Bikers
//
//  Created by Wojciech Granicki on 21.02.2014.
//  Copyright (c) 2014 Wojciech Granicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
@interface ShaderController : NSObject
@property(strong, nonatomic)NSMutableArray* uniforms;
@property(strong, nonatomic)NSMutableArray* attributes;

@end
