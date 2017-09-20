//
//  Mob.h
//  GameProject
//
//  Created by morris miller on 7/17/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "TileEngine.h"
#import "GameScene.h"

#ifndef Mob_h
#define Mob_h

@class GameScene;

@interface Mob : SKSpriteNode

@property GameScene * gameScene;

@property int x;
@property int y;
@property int z;
@property float vx;
@property float vy;
@property int width;
@property int height;
@property int frameNum;
@property long long lastAttack;
@property long long lastStateChange;

@property int timer;
@property int direction;
@property float theta;
@property int state;
@property int hp;
@property int dmg;
@property int minAgro;
@property int maxAgro;

-(void) link : (GameScene *) gameScene;
-(void) update;
-(void) damage : (float) theta;
-(int) distToPlayer;
-(BOOL) move : (float) vx : (float) vy;
@end
#endif /* Mob_h */
