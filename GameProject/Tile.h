//
//  Tile.h
//  GameProject
//
//  Created by morris miller on 7/15/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "Cell.h"
#ifndef Tile_h
#define Tile_h

@class cell;
@interface Tile : SKSpriteNode

@property int x;
@property int y;
@property int worldX;
@property int worldY;
@property int tileSize;
@property int z;
-(void) setType : (Cell *) cell;

@end

#endif /* Tile_h */
