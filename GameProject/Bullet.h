//
//  Bullet.h
//  GameProject
//
//  Created by morris miller on 7/18/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

#ifndef Bullet_h
#define Bullet_h

@class GameScene;

@interface Bullet : SKSpriteNode

@property int x;
@property int y;
@property int z;
@property int vx;
@property int vy;
@property float theta;

@property int state;
@property int tileSize;
@property long long lastStateChange;

@property GameScene * gameScene;

-(void) link : (GameScene *) gameScene;
-(void) update;
-(void) spawn;

@end

#endif /* Bullet_h */
