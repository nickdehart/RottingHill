//
//  TitleScene.h
//  GameProject
//
//  Created by morris miller on 7/23/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"

#ifndef TitleScene_h
#define TitleScene_h


@class GameViewController;
@interface TitleScene : SKScene
@property SKLabelNode * button;
@property GameViewController * gameViewController;

-(void) dealloc;

@end

#endif /* TitleScene_h */
