//
//  EnemyEngine.h
//  GameProject
//
//  Created by newuser on 7/20/17.
//  Copyright © 2017 morris miller and Nick DeHart. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Map.h"
#import "TileEngine.h"
#import "Player.h"
// ***** Import extra enemies below *****
#import "Mob.h"
#import "Tank.h"

#ifndef EnemyEngine_h
#define EnemyEngine_h

@class GameScene;
@class Map;
@class TileEngine;
@class Player;
// ***** Add new enemy class below *****
@class Mob;
@class Tank;

@interface EnemyEngine : NSObject

// ***** Add new enemy pointer array below *****
@property NSMutableArray * mobs;
@property NSMutableArray * tanks;

@property GameScene * gameScene;

@property long long lastSpawnTime;
@property long long lastLevelUp;
@property int level;
@property int state;

// ***** Make property for max of each enemy *****
@property int maxMobs;
@property int maxTanks;

-(void) addToScene;
-(void) link : (GameScene *) gameScene;
-(void) spawnAll;
-(void) update;
-(Mob *) hitCheckMob : (int) x : (int) y;
-(Mob *) hitCheckBulletMob : (int) x : (int) y;
-(Tank *) hitCheckTank : (int) x : (int) y;
-(Tank *) hitCheckBulletTank : (int) x : (int) y;
// ***** Make spawn function for new enemies *****
-(void) spawnMob;
-(void) spawnTank;


@end

#endif /* EnemyEngine_h */
