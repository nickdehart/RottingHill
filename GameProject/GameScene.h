//
//  GameScene.h
//  GameProject
//

//  Copyright (c) 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Controller.h"
#import "TileEngine.h"
#import "Map.h"
#import "EnemyEngine.h"
#import "TankEngine.h"
#import "BulletEngine.h"
#import "GameViewController.h"
#import "BulletEngine.h"
#import "Hud.h"
#import "Score.h"
#import "AppleEngine.h"

#ifndef GameScene_h
#define GameScene_h

@class Controller;
@class TileEngine;
@class EnemyEngine;
//@class TankEngine;
@class Player;
@class BulletEngine;
@class GameViewController;
@class Hud;
@class Score;
@class AppleEngine;

@interface GameScene : SKScene

@property GameViewController * gameViewController;
@property Player * player;
@property Controller * controller;
@property TileEngine * tileEngine;
@property Map * map;
@property EnemyEngine * enemyEngine;
//@property TankEngine * tankEngine;
@property BulletEngine * bulletEngine;
@property Hud * hud;
@property AppleEngine * appleEngine;

@property int state;

@end
#endif
