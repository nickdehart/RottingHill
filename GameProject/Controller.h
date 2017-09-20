//
//  Controller.h
//  GameProject
//
//  Created by morris miller on 7/14/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "GameScene.h"

#ifndef Controller_h
#define Controller_h

@class GameScene;

@interface Controller : NSObject

@property SKShapeNode * circle1;
@property int circle1X;
@property int circle1Y;

@property SKShapeNode * circle2;
@property int circle2X;
@property int circle2Y;

@property SKShapeNode * stick1;
@property UITouch * stick1Touch;
@property int stick1X;
@property int stick1Y;
@property float stick1Hyp;
@property float stick1Theta;

@property SKShapeNode * stick2;
@property UITouch * stick2Touch;
@property int stick2X;
@property int stick2Y;
@property float stick2Hyp;
@property float stick2Theta;

@property GameScene * gameScene;

-(void) link : (GameScene *) gameScene;
-(void) update;
-(void) addToScene;
-(void) touch: (CGPoint) pt : (UITouch *) touch;
-(void) untouch: (CGPoint) pt : (UITouch *) touch;

@end
#endif /* Controller_h */
