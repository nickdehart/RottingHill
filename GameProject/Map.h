//
//  Map.h
//  GameProject
//
//  Created by morris miller on 7/16/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#include <stdlib.h>
#import "Cell.h"
#import "GameScene.h"

#ifndef Map_h
#define Map_h

@class Cell;
@class GameScene;

@interface Map : NSObject

@property NSMutableArray * cells;
@property int cellSize;
@property int treeBalance;
@property GameScene * gameScene;
@property long long lastSpawn;

- (void)update;
- (void) createWorld;
- (void) link : (GameScene *) gameScene;
- (Cell *) GetCellAt: (int) x : (int) y;
- (Cell *) getSpawn;
- (Cell *) getSpawnMob;
-(void) spawnTree;

@end

#endif /* Map_h */
