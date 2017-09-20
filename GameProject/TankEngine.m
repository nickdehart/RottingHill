//
//  TankEngine.m
//  GameProject
//
//  Created by newuser on 7/17/17.
//  Copyright © 2017 morris miller and Nick DeHart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TankEngine.h"
@implementation TankEngine

// Initialize the monster object instances
-(id) init {
    self = [super init];
    self.tanks = [[NSMutableArray alloc]init];
    self.level = 1;
    self.lastLevelUp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    self.state = 0;
    
    self.maxTanks = 32;
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        Tank * tank = [[Tank alloc]init];
        [self.tanks addObject: tank];
    }
    return self;
}

-(void) addToScene {
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        Tank * tank = [self.tanks objectAtIndex: i];
        tank.zPosition = 200 + i;
        [self.gameScene addChild: tank];
    }
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        Tank * tank = [self.tanks objectAtIndex: i];
        [tank link : gameScene];
    }
}

-(void) spawnAll {
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        [self spawn];
    }
}

// Spawn a monster using a cell obtained form the map object
-(void) spawn {
    int i = 0;
    if (self.level > 2) {
        for (i = 0; i < self.level; i++) {
            Tank * tank = [self.tanks objectAtIndex: i];
            if (tank.state == 0) {
                // spawn tank
                Cell * spawn = [self.gameScene.map getSpawnMob];
                if (spawn != NO) {
                    tank.x = spawn.x;
                    tank.y = spawn.y;
                    tank.z = spawn.z + 1;
                    tank.state = 1;
                    tank.hp = 100;
                    tank.minAgro += (self.level * 10);
                    tank.maxAgro += (self.level * 10);
                    break;
                }
            }
        }
    }
}

// If two monsters are standing on the same cell, we need to z sort them based on postion
// south-western most body will be closest to the "camera" from player perspective
-(void) zSort {
    int i = 0;
    int j = 0;
    for (i = 0; i < self.maxTanks; i++) {
        Tank * tank = [self.tanks objectAtIndex: i];
        if (tank.state != 0) {
            
            for (j = 0; j < self.maxTanks; j++) {
                Tank * tank2 = [self.tanks objectAtIndex: j];
                if (tank2.state != 0) {
                    if (tank != tank2) {
                        if (tank.z == tank2.z) {
                            if (tank.y < tank2.y) {
                                tank.z++;
                            }
                            else if (tank.y == tank2.y) {
                                if (tank.x < tank2.x) {
                                    tank.z++;
                                }
                                else {
                                    tank2.z++;
                                }
                            }
                            else {
                                tank2.z++;
                            }
                        }
                    }
                    [tank setZPosition: tank.z];
                    [tank2 setZPosition: tank2.z];
                }
            }
            
            if (tank.z == self.gameScene.player.z) {
                if (tank.y < self.gameScene.player.y) {
                    tank.z++;
                }
                else if (tank.y == self.gameScene.player.y) {
                    if (tank.x < self.gameScene.player.x) {
                        tank.z++;
                    }
                    else {
                        self.gameScene.player.z++;
                    }
                }
                else {
                    self.gameScene.player.z++;
                }
            }
            [tank setZPosition: tank.z];
            [self.gameScene.player setZPosition: self.gameScene.player.z];
        }
    }
}


// Try to spawn a monster if it is time, increase the level and spawn rate if it is time
-(void) update {
    if (self.state == 0) {
        self.lastLevelUp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        self.state = 1;
    }
    if (self.state == 1) {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastSpawnTime > 100 + 2000 - (2000 * self.level/30)) {
            int rand = arc4random_uniform(3);
            if (rand == 0) {
                self.lastSpawnTime = time;
                [self spawn];
            }
        }
        
        if (self.level < 30 && time - self.lastLevelUp > 20000) {
            self.level++;
            self.lastLevelUp = time;
            if (self.level > 30) {
                self.level = 30;
            }
        }
        
        int i = 0;
        for (i = 0; i < self.maxTanks; i++) {
            Tank * tank = [self.tanks objectAtIndex: i];
            if (tank.state != 0) {
                [tank update];
            }
        }
        
    }
    [self zSort];
}

// Check if a point is touching any tanks, if so return that tank
-(Tank *) hitCheck : (int) x : (int) y {
    Tank * tank;
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        tank = [self.tanks objectAtIndex: i];
        if (tank.state != 0) {
            if (x >= tank.x && y >= tank.y && x <= tank.x + tank.width && y <= tank.y + tank.height) {
                return tank;
            }
        }
    }
    return NO;
}

// Special hit check for bullet. This one is a little bit more inclusive to allow bullet collision with tank's head
-(Tank *) hitCheckBullet : (int) x : (int) y {
    Tank * tank;
    int i = 0;
    for (i = 0; i < self.maxTanks; i++) {
        tank = [self.tanks objectAtIndex: i];
        if (tank.state != 0) {
            if (x >= tank.x && y >= tank.y && x <= tank.x + tank.width && y <= tank.y + tank.height * 1.5) {
                return tank;
            }
        }
    }
    return NO;
}
@end
