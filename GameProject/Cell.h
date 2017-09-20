//
//  Cell.h
//  GameProject
//
//  Created by morris miller on 7/16/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"

#ifndef Cell_h
#define Cell_h
@class GameScene;
@interface Cell : NSObject
@property int type;
@property int hp;
@property int x;
@property int y;
@property int z;
@property BOOL walkable;
@property GameScene * gameScene;

-(void) link : (GameScene *) gameScene;
-(void) damage : (int) ammount;
@end

#endif /* Cell_h */
