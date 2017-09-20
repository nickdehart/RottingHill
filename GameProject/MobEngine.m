//
//  MobEngine.m
//  GameProject
//
//  Created by morris miller on 7/17/self.maxMobs.
//  Copyright © 20self.maxMobs morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MobEngine.h"
@implementation MobEngine

// Initialize the monster object instances
-(id) init {
    self = [super init];
    self.mobs = [[NSMutableArray alloc]init];
    self.level = 1;
    self.lastLevelUp = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    self.state = 0;

    self.maxMobs = 128;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [[Mob alloc]init];
        [self.mobs addObject: mob];
    }
    return self;
}

-(void) addToScene {
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        mob.zPosition = 200 + i;
        [self.gameScene addChild: mob];
    }
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        Mob * mob = [self.mobs objectAtIndex: i];
        [mob link : gameScene];
    }
}

-(void) spawnAll {
    int i = 0;
    for (i = 0; i < self.maxMobs; i++) {
        [self spawn];
    }
}

// Spawn a monster using a cell obtained form the map object
-(void) spawn {
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

// If two monsters are standing on the same cell, we need to z sort them based on postion
// south-western most body will be closest to the "camera" from player perspective
-(void) zSort {
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
        for (i = 0; i < self.maxMobs; i++) {
            Mob * mob = [self.mobs objectAtIndex: i];
            if (mob.state != 0) {
                [mob update];
            }
        }

    }
    [self zSort];
}

// Check if a point is touching any mobs, if so return that mob
-(Mob *) hitCheck : (int) x : (int) y {
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
-(Mob *) hitCheckBullet : (int) x : (int) y {
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
@end
