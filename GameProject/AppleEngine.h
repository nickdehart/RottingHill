//
//  AppleEngine.h
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Apple.h"

#ifndef AppleEngine_h
#define AppleEngine_h

@interface AppleEngine : NSObject

@property int maxApples;

@property NSMutableArray * apples;

@property GameScene * gameScene;

- (void) addToScene;
- (void) link : (GameScene *) gameScene;
- (void) update;
- (void) spawn : (int) x : (int) y : (int) z;

@end

#endif /* AppleEngine_h */
