//
//  Player.h
//  GameProject
//
//  Created by morris miller on 7/13/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

#ifndef Player_h
#define Player_h

@class GameScene;
@class Cell;
@interface Player : SKSpriteNode

@property GameScene * gameScene;

@property int x;
@property int y;
@property int z;
@property int width;
@property int height;
@property int frameNum;
@property int hp;
@property int kills;
@property int state;
@property int face;
@property long long lastStateChange;
@property SKSpriteNode * gun;

-(void) link : (GameScene *) gameScene;
-(void) update;
-(void) spawn  : (Cell *) spawn;
-(void) bump : (float) theta : (int) force;
-(void) damage : (int) vx : (int) vy : (int) dmg;
-(BOOL) hitCheck : (int) x : (int) y;
-(void)dealloc;
@end
#endif /* Player_h */
