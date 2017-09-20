//
//  EnemyEngine.m
//  GameProject
//
//  Created by newuser on 7/20/17.
//  Copyright © 2017 morris miller and Nick DeHart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyEngine.h"
@implementation EnemyEngine

// Initialize the monster object instances
-(id) init {
    self = [super init];
    self.level = 1;
    self.lastLevelUp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    self.state = 0;
    // ***** Allocate enemy arrays below *****
    self.mobs = [[NSMutableArray alloc]init];
    self.tanks = [[NSMutableArray alloc]init];
    
    // ***** Don't forget to allocate each individual guy! *****
    self.maxMobs = 128;
    self.maxTanks = 32;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [[Mob alloc]init];
        [self.mobs addObject: mob];
        // ***** simply add an 'if' statement to save time and code *****
        if (i < self.maxTanks){
            Tank * tank = [[Tank alloc]init];
            [self.tanks addObject: tank];
        }
    }
    return self;
}

// Add all enemies to gameScene
-(void) addToScene {
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        mob.zPosition = 200 + i;
        [self.gameScene addChild: mob];
        // ***** Add new enemies below (must be less than maxMobs!!) *****
        if (i < self.maxTanks){
            Tank * tank = [self.tanks objectAtIndex: i];
            tank.zPosition = 328 + i;
            [self.gameScene addChild: tank];
        }
    }
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        [mob link : gameScene];
        // ***** Link new enemies below (must be less than maxMobs!!) *****
        if (i < self.maxTanks) {
            Tank * tank = [self.tanks objectAtIndex: i];
            [tank link : gameScene];
        }
    }
}

-(void) spawnAll {
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        [self spawnMob];
        if (i < self.maxTanks) {
            [self spawnTank];
        }
    }
}

// Spawn a monster using a cell obtained from the map object
-(void) spawnMob {
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        if (mob.state == 0) {
            // spawn mob
            Cell * spawn = [self.gameScene.map getSpawnMob];
            if (spawn != NO) {
                mob.x = spawn.x;
                mob.y = spawn.y;
                mob.z = spawn.z + 1;
                mob.state = 1;
                mob.hp = 100;
                mob.minAgro += (self.level * 10);
                mob.maxAgro += (self.level * 10);
                break;
            }
        }
    }
}

-(void) spawnTank {
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
                    tank.hp = 750;
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
-(void) zSortMobs {
    int i = 0;
    int j = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        if (mob.state != 0) {
            
            for (j = 0; j < self.maxMobs; j++) {
                Mob * mob2 = [self.mobs objectAtIndex: j];
                if (mob2.state != 0) {
                    if (mob != mob2) {
                        if (mob.z == mob2.z) {
                            if (mob.y < mob2.y) {
                                mob.z++;
                            }
                            else if (mob.y == mob2.y) {
                                if (mob.x < mob2.x) {
                                    mob.z++;
                                }
                                else {
                                    mob2.z++;
                                }
                            }
                            else {
                                mob2.z++;
                            }
                        }
                    }
                    [mob setZPosition: mob.z];
                    [mob2 setZPosition: mob2.z];
                }
            }
            
            for (j = 0; j < self.maxTanks; j++) {
                Tank * tank = [self.tanks objectAtIndex: j];
                if (tank.state != 0) {
                        if (mob.z == tank.z) {
                            if (mob.y < tank.y) {
                                mob.z++;
                            }
                            else if (mob.y == tank.y) {
                                if (mob.x < tank.x) {
                                    mob.z++;
                                }
                                else {
                                    tank.z++;
                                }
                            }
                            else {
                                tank.z++;
                            }
                        }
                    [mob setZPosition: mob.z];
                    [tank setZPosition: tank.z];
                }
            }
            
            if (mob.z == self.gameScene.player.z) {
                if (mob.y < self.gameScene.player.y) {
                    mob.z++;
                }
                else if (mob.y == self.gameScene.player.y) {
                    if (mob.x < self.gameScene.player.x) {
                        mob.z++;
                    }
                    else {
                        self.gameScene.player.z++;
                    }
                }
                else {
                    self.gameScene.player.z++;
                }
            }
            [mob setZPosition: mob.z];
            [self.gameScene.player setZPosition: self.gameScene.player.z];
        }
    }
}

// If two monsters are standing on the same cell, we need to z sort them based on postion
// south-western most body will be closest to the "camera" from player perspective
-(void) zSortTanks {
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
            
            for (j = 0; j < self.maxMobs; j++) {
                Mob * mob = [self.mobs objectAtIndex: j];
                if (mob.state != 0) {
                    if (mob.z == tank.z) {
                        if (mob.y < tank.y) {
                            mob.z++;
                        }
                        else if (mob.y == tank.y) {
                            if (mob.x < tank.x) {
                                mob.z++;
                            }
                            else {
                                tank.z++;
                            }
                        }
                        else {
                            tank.z++;
                        }
                    }
                    [mob setZPosition: mob.z];
                    [tank setZPosition: tank.z];
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
                // ***** Spawn new enemies here *****
                [self spawnMob];
                //[self spawnTank];
            }
        }
        
        if (self.level < 30 && time - self.lastLevelUp > 20000) {
            self.level++;
            [self spawnTank];
            self.lastLevelUp = time;
            if (self.level > 30) {
                self.level = 30;
            }
        }
        
        int i = 0;
        for (i = 0; i < self.maxMobs; i++) {
            Mob * mob = [self.mobs objectAtIndex: i];
            if (mob.state != 0) {
                [mob update];
            }
            if (i < self.maxTanks) {
                Tank * tank = [self.tanks objectAtIndex: i];
                if (tank.state != 0) {
                    [tank update];
                }
            }
        }
        
    }
    [self zSortMobs];
    [self zSortTanks];
}

// Check if a point is touching any mobs, if so return that mob
-(Mob *) hitCheckMob : (int) x : (int) y {
    Mob * mob;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        mob = [self.mobs objectAtIndex: i];
        if (mob.state != 0) {
            if (x >= mob.x && y >= mob.y && x <= mob.x + mob.width && y <= mob.y + mob.height) {
                return mob;
            }
        }
    }
    return NO;
}

// Special hit check for bullet. This one is a little bit more inclusive to allow bullet collision with mob's head
-(Mob *) hitCheckBulletMob : (int) x : (int) y {
    Mob * mob;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        mob = [self.mobs objectAtIndex: i];
        if (mob.state != 0) {
            if (x >= mob.x && y >= mob.y && x <= mob.x + mob.width && y <= mob.y + mob.height * 1.5) {
                return mob;
            }
        }
    }
    return NO;
}

// Check if a point is touching any tanks, if so return that tank
-(Tank *) hitCheckTank : (int) x : (int) y {
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
-(Tank *) hitCheckBulletTank : (int) x : (int) y {
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
