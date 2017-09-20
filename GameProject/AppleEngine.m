//
//  AppleEngine.m
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppleEngine.h"

@implementation AppleEngine
- (id) init {
    self = [super init];
    self.apples = [[NSMutableArray alloc]init];
    self.maxApples = 128;
    int i = 0;
    for (i = 0; i < self.maxApples; i++) {
        Apple * apple = [[Apple alloc]init];
        [self.apples addObject: apple];
    }
    return self;
}

- (void) addToScene {
    int i = 0;
    for (i = 0; i < self.maxApples; i++) {
        Apple * apple = [self.apples objectAtIndex: i];
        [self.gameScene addChild: apple];
    }
}

- (void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    for (i = 0; i < self.maxApples; i++) {
        Apple * apple = [self.apples objectAtIndex: i];
        [apple link : gameScene];
    }
}

- (void) update {
    int i = 0;
    for (i = 0; i < self.maxApples; i++) {
        Apple * apple = [self.apples objectAtIndex: i];
        if (apple.state != 0) {
            [apple update];
        }
    }
}

- (void) spawn : (int) x : (int) y : (int) z {
    int i = 0;
    for (i = 0; i < self.maxApples; i++) {
        Apple * apple = [self.apples objectAtIndex: i];
        if (apple.state == 0) {
            [apple spawn : x : y : z];
            break;
        }
    }
}

@end