//
//  Apple.h
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

#ifndef Apple_h
#define Apple_h

@class GameScene;

@interface Apple : SKSpriteNode
@property int state;
@property int width;
@property int height;
@property int x;
@property int y;
@property int z;

@property GameScene * gameScene;

-(void) update;
-(void) link : (GameScene *) gameScene;
-(void) spawn : (int) x : (int) y : (int) z;

@end

#endif /* Apple_h */
