//
//  GameScene.m
//  GameProject
//
//  Created by morris miller on 7/13/16.
//  Copyright (c) 2016 morris miller. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    // Create all object instances for the game
    self.player = [[Player alloc]init];
    self.controller = [[Controller alloc]init];
    self.tileEngine = [[TileEngine alloc]init];
    self.enemyEngine = [[EnemyEngine alloc]init];
    //self.tankEngine = [[TankEngine alloc]init];
    self.bulletEngine = [[BulletEngine alloc]init];
    self.map = [[Map alloc]init];
    self.hud = [[Hud alloc]init];
    self.appleEngine = [[AppleEngine alloc]init];
    self.state = 0;
    
    // Give each object a reference to the Game Scene object
    [self.tileEngine link : self];
    [self.enemyEngine link : self];
    //[self.tankEngine link : self];
    [self.bulletEngine link : self];
    [self.player link : self];
    [self.controller link : self];
    [self.map link: self];
    [self.hud link: self];
    [self.appleEngine link: self];
    
    // Add all children to the scene
    [self addChild: self.player];
    [self.controller addToScene];
    [self.tileEngine addToScene];
    [self.enemyEngine addToScene];
    //[self.tankEngine addToScene];
    [self.bulletEngine addToScene];
    [self.appleEngine addToScene];
    
    // Get a spawn point for the player
    Cell * spawnCell = [self.map getSpawn];
    
    // Spawn the player
    [self.tileEngine spawn : spawnCell];
    [self.player spawn : spawnCell];
    
    // Set the state to play mode
    self.state = 1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Send touches to the controller
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [self.controller touch: location : touch];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [self.controller touch: location : touch];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode: self];
        [self.controller untouch: location : touch];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    // Call update functions if in play mode
    if (self.state == 1) {
        [self.controller update];
        [self.player update];
        [self.tileEngine update];
        [self.enemyEngine update];
        //[self.tankEngine update];
        [self.bulletEngine update];
        [self.hud update];
        [self.appleEngine update];
        [self.map update];
    }
    
    // Go to game over scene if in game over mode
    else if (self.state == 2) {
        self.state = 3;
        [self.gameViewController goToGameOver];
    }
}

@end
