//
//  Tile.m
//  GameProject
//
//  Created by morris miller on 7/15/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import "Tile.h"
#import <Foundation/Foundation.h>
@implementation Tile

-(id)init {
    self = [super initWithImageNamed:@"grass"];
    self.tileSize = 64;
    if (self) {
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);
        self.zPosition = 99;
        self.x = 0;
        self.y = 0;
        self.z = 0;
        self.worldX = 0;
        self.worldY = 0;
    }
    return self;
}

// Set type and texture based on a cell which came from the map object.
-(void) setType : (Cell *) cell {
    if (cell == NO) {
        [self setSize: CGSizeMake(self.tileSize, self.tileSize)];
        [self setTexture: [SKTexture textureWithImageNamed: @"blank"]];
    }
    else {
        int type = cell.type;
        self.z = cell.z;
        if (type == 0) {
            [self setSize: CGSizeMake(self.tileSize, self.tileSize + self.tileSize/2)];
            [self setTexture: [SKTexture textureWithImageNamed: @"tree"]];
        }
        else if (type == 1) {
            [self setSize: CGSizeMake(self.tileSize, self.tileSize)];
            [self setTexture: [SKTexture textureWithImageNamed: @"grass"]];
        }
        else if (type == 2) {
            [self setSize: CGSizeMake(self.tileSize, self.tileSize + self.tileSize/2)];
            [self setTexture: [SKTexture textureWithImageNamed: @"appleTree"]];
        }
        else if (type == 3) {
            [self setSize: CGSizeMake(self.tileSize, self.tileSize + self.tileSize/2)];
            [self setTexture: [SKTexture textureWithImageNamed: @"damagedTree"]];
        }
        else if (type == 4) {
            [self setSize: CGSizeMake(self.tileSize, self.tileSize + self.tileSize/2)];
            [self setTexture: [SKTexture textureWithImageNamed: @"damagedAppleTree"]];
        }
        
    }
}
@end