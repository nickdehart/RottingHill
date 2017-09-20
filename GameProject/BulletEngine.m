//
//  BulletEngine.m
//  GameProject
//
//  Created by morris miller on 7/18/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletEngine.h"
@implementation BulletEngine

// Initialize bullet obejct instances
- (id) init {
    self = [super init];
    self.bullets = [[NSMutableArray alloc]init];
    self.lastShotTime = 0;
    self.maxBullets = 32;
    int i = 0;
    for (i = 0; i < self.maxBullets; i++) {
        Bullet * bullet = [[Bullet alloc]init];
        bullet.zPosition = 250 + i;
        [self.bullets addObject: bullet];
    }
    return self;
}

- (void) addToScene {
    int i = 0;
    for (i = 0; i < self.maxBullets; i++) {
        Bullet * bullet = [self.bullets objectAtIndex: i];
        [self.gameScene addChild: bullet];
    }
}

- (void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    for (i = 0; i < self.maxBullets; i++) {
        Bullet * bullet = [self.bullets objectAtIndex: i];
        [bullet link : gameScene];
    }
}

- (void) update {
    int i = 0;
    for (i = 0; i < self.maxBullets; i++) {
        Bullet * bullet = [self.bullets objectAtIndex: i];
        if (bullet.state != 0) {
            [bullet update];
        }
    }
}

// Try to shoot a bullet if there has been enough time since last shot
- (void) spawn {
    long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    if (time - self.lastShotTime > 100) {
        int i = 0;
        for (i = 0; i < self.maxBullets; i++) {
            Bullet * bullet = [self.bullets objectAtIndex: i];
            if (bullet.state == 0) {
                [self.gameScene.gameViewController.soundPlayer playShot];
                [bullet spawn];
                self.lastShotTime = time;
                break;
            }
        }
    }
}

@end