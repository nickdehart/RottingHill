//
//  Map.m
//  GameProject
//
//  Created by morris miller on 7/16/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "Map.h"
#import <Foundation/Foundation.h>
@implementation Map

// Initialize all the cells in the map
-(id)init {
    self = [super init];
    self.cells = [[NSMutableArray alloc]init];
    self.cellSize = 64;
    self.lastSpawn = 0;
    self.treeBalance = 0;
    
    int i = 0;
    int j = 0;
    int count = 0;
    for (i = 0; i < 100; i++) {
        NSMutableArray * row = [[NSMutableArray alloc]init];
        [self.cells addObject: row];
        for (j = 0; j < 150; j++) {
            Cell * cell = [[Cell alloc]init];
            cell.hp = 100;
            cell.type = 0;
            cell.x = j * self.cellSize;
            cell.y = i * self.cellSize;
            cell.z = 100 * 150 - count;
            count++;
            [[self.cells objectAtIndex: i] addObject: cell];
        }
    }
    [self createWorld];
    return self;
}

// Spawn a new tree if possible
-(void) update {
    long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    if (time - self.lastSpawn > 5000){
        [self spawnTree];
        self.lastSpawn = time;
    }
}

-(void)link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    int i = 0;
    int j = 0;
    for (i = 0; i < 100; i++) {
        NSMutableArray * row = [self.cells objectAtIndex: i];
        for (j = 0; j < 150; j++) {
            Cell * cell = [row objectAtIndex: j];
            [cell link : gameScene];
        }
    }
}

// Create a new map for the game using a cellular automation algorithm
-(void)createWorld {
    int i = 0;
    int j = 0;
    
    // First set cells randomly to tree or grass
    for (i = 0; i < 100; i++) {
        NSMutableArray * row = [self.cells objectAtIndex: i];
        for (j = 0; j < 150; j++) {
            Cell * cell = [row objectAtIndex: j];
            int randomNumber = arc4random_uniform(100);
            if (randomNumber < 45) {
                cell.type = 0;
                cell.walkable = NO;
            }
            else {
                cell.type = 1;
                cell.walkable = YES;
            }
        }
    }
    
    // Now only allow trees if a tree has at least 3 neighbor trees
    int count = 0;
    for (count = 0; count < 5; count++) {
        for (i = 0; i < 100; i++) {
            NSMutableArray * row = [self.cells objectAtIndex: i];
            for (j = 0; j < 150; j++) {
                Cell * cell = [row objectAtIndex: j];
                int neighborCount = 0;
                if (cell.type == 0) {
                    int k = 0;
                    int l = 0;
                    for (k = i - 1; k < i + 2; k++) {
                        for (l = j - 1; l < j + 2; l++) {
                            if (k >= 0 && l >= 0 && k < 100 && l < 150) {
                                Cell * neighbor = [[self.cells objectAtIndex: k] objectAtIndex: l];
                                if (neighbor.type == 0) {
                                    neighborCount++;
                                }
                            }
                        }
                    }
                    if (neighborCount > 3) {
                        cell.type = 0;
                        cell.walkable = NO;
                    }
                    else {
                        cell.type = 1;
                        cell.walkable = YES;
                    }
                }
            }
        }
    }
    
    // Randomly change some trees into apple trees (10% chance)
    for (i = 0; i < 100; i++) {
        NSMutableArray * row = [self.cells objectAtIndex: i];
        for (j = 0; j < 150; j++) {
            Cell * cell = [row objectAtIndex: j];
            if (cell.type == 0) {
                int rand = arc4random_uniform(10);
                if (rand == 0) {
                    cell.type = 2;
                }
            }
        }
    }
}

// Get a cell based on world coordinates
-(Cell *)GetCellAt:(int)x :(int)y {
    if(x >= 0 && y >=0 && x < self.cellSize*150 && y < self.cellSize*100){
        Cell * cell = [[self.cells objectAtIndex:y/self.cellSize] objectAtIndex:x/self.cellSize];
        return cell;
    }
    return NO;
}

// Get a suitible spawn location for the player
-(Cell *) getSpawn {
    int i = 0;
    for (i = 0; i < 100; i++) {
        int randX = arc4random_uniform(150);
        int randY = arc4random_uniform(100);
        Cell * cell = [[self.cells objectAtIndex: randY] objectAtIndex: randX];
        if (cell.type == 1) {
            return cell;
        }
    }
    return NO;
}

// Get a suitable spawn location for a monster
- (Cell *) getSpawnMob {
    int i = 0;
    for (i = 0; i < 100; i++) {
        // pick a random side of the screen to spawn the player
        int randSide = arc4random_uniform(4);
        int spawnX = 0;
        int spawnY = 0;
        
        // calculate the map cell coordinates of each side of the screen
        
        int north = self.gameScene.tileEngine.viewY + self.gameScene.tileEngine.gridH * self.gameScene.tileEngine.tileSize;
        int south = self.gameScene.tileEngine.viewY;
        int east = self.gameScene.tileEngine.viewX + self.gameScene.tileEngine.gridW * self.gameScene.tileEngine.tileSize;
        int west = self.gameScene.tileEngine.viewX;
                
        // set potential spawn points
        switch (randSide) {
            case 0:
                spawnY = north;
                spawnX = west + arc4random_uniform(self.gameScene.tileEngine.gridW) * self.gameScene.tileEngine.tileSize;
                break;
            case 1:
                spawnY = south;
                spawnX = west + arc4random_uniform(self.gameScene.tileEngine.gridW) * self.gameScene.tileEngine.tileSize;
                break;
            case 2:
                spawnY = south + arc4random_uniform(self.gameScene.tileEngine.gridH) * self.gameScene.tileEngine.tileSize;
                spawnX = east;
                break;
            case 3:
                spawnY = south + arc4random_uniform(self.gameScene.tileEngine.gridH) * self.gameScene.tileEngine.tileSize;
                spawnX = west;
                break;
            default:
                break;
        }
        
        Cell * cell = [self GetCellAt: spawnX : spawnY];
        if (cell != NO && cell.type == 1) {
            return cell;
        }
    }
    return NO;
}

// Create a tree in an appropriate location
-(void) spawnTree {
    if (self.treeBalance < 0) {
        int rand = arc4random_uniform(5);
        if (rand == 0) {
            int i = 0;
            for (i = 0; i < 100; i++) {
                int randX = arc4random_uniform(150);
                int randY = arc4random_uniform(100);
                Cell * cell = [[self.cells objectAtIndex: randY] objectAtIndex: randX];
                int dx = abs(self.gameScene.player.x - cell.x);
                int dy = abs(self.gameScene.player.y - cell.y);
                int distance = sqrt(dx * dx + dy * dy);
                
                if (cell.type == 1 && distance > 1100) {
                    NSLog(@"spawning a new tree");
                    int rand = arc4random_uniform(10);
                    if (rand == 0){
                        cell.type = 2;
                    }
                    else cell.type = 0;
                    cell.walkable = NO;
                    cell.hp = 100;
                    self.treeBalance++;
                    break;
                }
            }
            
        }
    }
}



@end