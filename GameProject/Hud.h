//
//  hud.h
//  GameProject
//
//  Created by morris miller on 7/23/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

#ifndef hud_h
#define hud_h

@class GameScene;

@interface Hud : NSObject
@property GameScene * gameScene;

@property SKLabelNode * health;
@property SKLabelNode * kills;
@property SKLabelNode * gameOver;
@property SKLabelNode * level;

-(void) update;
-(void) link : (GameScene *) gameScene;
-(void) showGameOver;

@end

#endif /* hud_h */
