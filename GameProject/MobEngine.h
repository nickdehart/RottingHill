//
//  MobEngine.h
//  GameProject
//
//  Created by morris miller on 7/17/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Mob.h"
#import "Map.h"
#import "TileEngine.h"
#import "Player.h"

#ifndef MobEngine_h
#define MobEngine_h

@class Mob;
@class GameScene;
@class Map;
@class TileEngine;
@class Player;

@interface MobEngine : NSObject

@property NSMutableArray * mobs;

@property GameScene * gameScene;

@property long long lastSpawnTime;
@property long long lastLevelUp;
@property int level;
@property int maxMobs;
@property int state;

-(void) addToScene;
-(void) link : (GameScene *) gameScene;
-(void) spawnAll;
-(void) spawn;
-(void) update;
-(Mob *) hitCheck : (int) x : (int) y;
-(Mob *) hitCheckBullet : (int) x : (int) y;


@end

#endif /* MobEngine_h */
