//
//  Apple.m
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Apple.h"

@implementation Apple

-(id) init {
    self = [super initWithImageNamed: @"apple"];
    self.state = 0;
    self.width = 16;
    self.height = 16;
    self.anchorPoint = CGPointMake(0, 0);
    [self setPosition: CGPointMake(-64, -64)];
    return self;
}

// Check if player has touched apple, if so heal player and reset apple
-(void) update {
    if (self.state == 1) {
        int north = self.y + self.height;
        int south = self.y;
        int east = self.x + self.width;
        int west = self.x;
        
        BOOL SWPlayer = [self.gameScene.player hitCheck : west : south];
        BOOL SEPlayer = [self.gameScene.player hitCheck : east : south];
        BOOL NWPlayer = [self.gameScene.player hitCheck : west : north];
        BOOL NEPlayer = [self.gameScene.player hitCheck : east : north];
        
        if (SWPlayer || SEPlayer || NWPlayer || NEPlayer) {
            [self.gameScene.gameViewController.soundPlayer playPowerup];
            self.gameScene.player.hp += 20;
            if (self.gameScene.player.hp > 100) {
                self.gameScene.player.hp = 100;
            }
            [self reset];
        }
        [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
        [self setZPosition: self.z];
    }
    else if (self.state == 2) {
        [self setPosition : CGPointMake (-64, -64)];
        self.state = 0;
    }
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

-(void) reset {
    NSLog(@"reset apple");
    self.state = 2;
}

-(void) spawn : (int) x : (int) y : (int) z {
    self.state = 1;
    self.x = x;
    self.y = y;
    self.z = z;
}

@end