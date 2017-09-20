//
//  TankEngine.h
//  GameProject
//
//  Created by newuser on 7/17/17.
//  Copyright © 2017 morris miller and Nick DeHart. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Tank.h"
#import "Map.h"
#import "TileEngine.h"
#import "Player.h"

#ifndef TankEngine_h
#define TankEngine_h

@class Tank;
@class GameScene;
@class Map;
@class TileEngine;
@class Player;

@interface TankEngine : NSObject

@property NSMutableArray * tanks;

@property GameScene * gameScene;

@property long long lastSpawnTime;
@property long long lastLevelUp;
@property int level;
@property int maxTanks;
@property int state;

-(void) addToScene;
-(void) link : (GameScene *) gameScene;
-(void) spawnAll;
-(void) spawn;
-(void) update;
-(Tank *) hitCheck : (int) x : (int) y;
-(Tank *) hitCheckBullet : (int) x : (int) y;


@end

#endif /* TankEngine_h */
