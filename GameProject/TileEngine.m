//
//  TileEngine.m
//  GameProject
//
//  Created by morris miller on 7/15/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
/*
 
 The tile engine comprises the scrolling tile background in the game. The tiles in the tile engines get their properties from the map object which holds the terrain data for the game.
 
 */

#import "TileEngine.h"
#import <Foundation/Foundation.h>

@implementation TileEngine
-(id) init {
    self = [super init];
    self.tiles = [[NSMutableArray alloc]init];
    
    // get screen dimensions
    self.screenW = [[UIScreen mainScreen] bounds].size.width;
    self.screenH = [[UIScreen mainScreen] bounds].size.height;
    
    self.tileSize = 64;
    self.viewW = self.screenW;
    self.viewH = self.screenH;
   
    // set up game view port within screen
    self.originX = 0;
    self.originY = -self.tileSize; //0;  //used to be -self.tileSize

    self.viewX = 0;
    self.viewX = 0;
    
    // Calculate how many tiles we need to cover the screen
    self.gridW = ceil(self.viewW/self.tileSize) + 2;
    self.gridH = ceil(self.viewH/self.tileSize) + 3;

    // Create the tile object instances
    int i = 0;
    int j = 0;
    for (i = 0; i < self.gridH; i++) {
        NSMutableArray * row = [[NSMutableArray alloc]init];
        [self.tiles addObject: row];
        for (j = 0; j < self.gridW; j++) {
            Tile * tile = [[Tile alloc] init];
            tile.x = j * self.tileSize;
            tile.y = i * self.tileSize;
            [tile setPosition: CGPointMake(self.originX + tile.x, self.originY + tile.y)];
            [[self.tiles objectAtIndex: i] addObject: tile];
        }
    }
    
    return self;
}

-(void)addToScene {
    int i = 0;
    int j = 0;
    for (i = 0; i < self.gridH; i++) {
        NSArray * row = [self.tiles objectAtIndex: i];
        for (j = 0; j < self.gridW; j++) {
            Tile * tmp = [row objectAtIndex: j];
            [self.gameScene addChild: tmp];
        }
    }
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

// Set the viewport location based on player's spawn point
-(void) spawn : (Cell *) spawn {
    self.viewX = spawn.x - (self.gridW - 1)/2 * self.tileSize;
    self.viewY = spawn.y - (self.gridH - 1)/2 * self.tileSize;
    [self setAll];
    [self update];
}

// Tell each tile to set it's type and texture based on the corresponding cell from the map
-(void) setAll {
    int i = 0;
    int j = 0;
    for (i = 0; i < self.gridH; i++) {
        NSArray * row = [self.tiles objectAtIndex: i];
        for (j = 0; j < self.gridW; j++) {
            Tile * tmp = [row objectAtIndex: j];
            Cell * cell = [self.gameScene.map GetCellAt: self.viewX + tmp.x : self.viewY + tmp.y];
            [tmp setType : cell];
        }
    }
}

// Check if the player is getting far off center from the view port. If so we need to move the view port
-(void)update {
    
    int difX = self.gameScene.player.x - (self.viewX + self.viewW/2);
    int difY = self.gameScene.player.y - (self.viewY + self.viewH/2);
    
    int dx = abs(difX);
    int dy = abs(difY);
    double theta = 0;
    float force = 0;
    float hyp = sqrt(dx*dx + dy*dy);
    
    
    if (difX > 0 && difY >= 0) {
        theta = asin(dy/hyp);
        force = 1;
    }
    if (difX <= 0 && difY > 0) {
        theta = M_PI/2 + asin(dx/hyp);
        force = 1;
    }
    if (difX < 0 && difY <= 0) {
        theta = M_PI + asin(dy/hyp);
        force = 1;
    }
    if (difX >= 0 && difY < 0) {
        theta = M_PI/2 * 3 + asin(dx/hyp);
        force = 1;
    }
    
    if (hyp < 16) {
        hyp = 0;
    }
    else {
        hyp = 4;
    }
    
    
    float vx = cos(theta) * hyp;
    float vy = sin(theta) * hyp;
    [self move : vx : vy];
}

// Move the view port by scrolling the tiles across the screen.
// When a tile goes off screen, wrap it to the other side and set its texture and type based on the corresponding map cell
-(void) move : (int) vx : (int) vy {
    int i = 0;
    int j = 0;
    
    self.viewX += vx;
    self.viewY += vy;
    
    for (i = 0; i < self.gridH; i++) {
        NSArray * row = [self.tiles objectAtIndex: i];
        for (j = 0; j < self.gridW; j++) {
            Tile * tmp = [row objectAtIndex: j];
            tmp.x -= vx;
            tmp.y -= vy;
            
            int gridWPix = (self.gridW - 1) * self.tileSize;
            int gridHPix = (self.gridH - 1) * self.tileSize;
            
            BOOL wrap = NO;
            if (tmp.x > gridWPix) {
                tmp.x -= gridWPix + self.tileSize;
                wrap = YES;
            }
            if (tmp.x < -self.tileSize) {
                tmp.x += gridWPix + self.tileSize;
                wrap = YES;
            }
            if (tmp.y > gridHPix) {
                tmp.y -= gridHPix + self.tileSize;
                wrap = YES;
            }
            if (tmp.y < -self.tileSize) {
                tmp.y += gridHPix + self.tileSize;
                wrap = YES;
            }
            
            if (wrap) {
                Cell * cell = [self.gameScene.map GetCellAt: self.viewX + tmp.x : self.viewY + tmp.y];
                [tmp setType : cell];
            }
            [tmp setPosition: CGPointMake(self.originX + tmp.x, self.originY + tmp.y)];
            [tmp setZPosition: tmp.z];
        }
    }
}
@end
