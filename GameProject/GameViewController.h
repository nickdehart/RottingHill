//
//  GameViewController.h
//  GameProject
//

//  Copyright (c) 2016 morris miller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "TitleScene.h"
#import "GameScene.h"
#import "Database.h"
#import "SoundPlayer.h"
#import "GameOverScene.h"

@class TitleScene;
@class GameScene;
@class Database;
@class GameOverScene;
@class SoundPlayer;

@interface GameViewController : UIViewController

@property TitleScene * titleScene;
@property GameScene * gameScene;
@property GameOverScene * gameOverScene;
@property Database * database;
@property SoundPlayer * soundPlayer;

-(void) startGame;
-(void) goToGameOver;
-(void) goToMenu;

@end
