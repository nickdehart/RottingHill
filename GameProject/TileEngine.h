//
//  TileEngine.h
//  GameProject
//
//  Created by morris miller on 7/15/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Tile.h"

#ifndef TileEngine_h
#define TileEngine_h

@class GameScene;
@class MobEngine;
@class Cell;
@class Tile;

@interface TileEngine : NSObject

@property NSMutableArray * tiles;

@property GameScene * gameScene;

@property int screenW;
@property int screenH;
@property int gridW;
@property int gridH;

@property int originX;
@property int originY;
@property int viewX;
@property int viewY;
@property int viewW;
@property int viewH;
@property int tileSize;

@property int shake;

@property int playerDirection;
@property MobEngine * mobEngine;

-(void)addToScene;
-(void)link : (GameScene *) gameScene;
-(void)spawn : (Cell *) spawn;
-(void)setAll;
-(void)update;
-(void)move : (int) vx : (int) vy;

@end

#endif /* TileEngine_h */
