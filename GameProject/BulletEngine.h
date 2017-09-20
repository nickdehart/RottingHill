//
//  BulletEngine.h
//  GameProject
//
//  Created by morris miller on 7/18/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "Bullet.h"

#ifndef BulletEngine_h
#define BulletEngine_h

@class GameScene;
@class Bullet;

@interface BulletEngine : NSObject

@property NSMutableArray * bullets;
@property long long lastShotTime;
@property int maxBullets;

@property GameScene * gameScene;

-(void) addToScene;
-(void) link : (GameScene *) gameScene;
-(void) update;
-(void) spawn;

@end

#endif /* BulletEngine_h */
