//
//  Cell.m
//  GameProject
//
//  Created by morris miller on 7/16/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "Cell.h"
#import <Foundation/Foundation.h>
@implementation Cell

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

// Damage a tree cell
-(void) damage : (int) ammount {
    self.hp -= ammount;
    if (self.hp <= 50) {
        if (self.type == 0){
            self.type = 3;
            [self.gameScene.tileEngine setAll];
        }
        if (self.type == 2){
            self.type = 4;
            [self.gameScene.tileEngine setAll];
        }
    }
    if (self.hp <= 0) {
        self.hp = 0;
        if (self.type == 4) {
            [self.gameScene.appleEngine spawn: self.x : self.y : self.z + 1];
        }
        self.gameScene.map.treeBalance--;
        self.type = 1;
        self.walkable = YES;
        [self.gameScene.tileEngine setAll];
    }
}

@end