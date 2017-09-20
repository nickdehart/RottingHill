//
//  GameOverScene.h
//  GameProject
//
//  Created by morris miller on 7/24/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
#import "Database.h"

#ifndef GameOverScene_h
#define GameOverScene_h

@class Database;
@class GameViewController;
@interface GameOverScene : SKScene
@property GameViewController * gameViewController;

@property int state;
@property long long lastStateChange;

@property int viewW;
@property int viewH;

@property int score;
@property int level;
@property int kills;

@property int firstScore;
@property int secondScore;
@property int thirdScore;

@property NSString * firstName;
@property NSString * secondName;
@property NSString * thirdName;

@property SKLabelNode * scoreLabel;
@property SKLabelNode * levelLabel;
@property SKLabelNode * killsLabel;

@property SKLabelNode * firstPlace;
@property SKLabelNode * secondPlace;
@property SKLabelNode * thirdPlace;

-(void) initializeScore : (int) kills : (int) level;

@end

#endif /* GameOverScene_h */
