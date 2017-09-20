//
//  hud.m
//  GameProject
//
//  Created by morris miller on 7/23/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hud.h"

@implementation Hud

-(id) init {
    self = [super init];
    
    // Create interface objects for the Heads Up Display
    self.health = [[SKLabelNode alloc] initWithFontNamed: @"Courier"];
    self.kills = [[SKLabelNode alloc] initWithFontNamed: @"Courier"];
    self.gameOver = [[SKLabelNode alloc] initWithFontNamed: @"Courier"];
    self.level = [[SKLabelNode alloc] initWithFontNamed: @"Courier"];
    return self;
}

// Set reference to the game scene and add children to it
-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    
    [gameScene addChild: self.health];
    [gameScene addChild: self.kills];
    [gameScene addChild: self.gameOver];
    [gameScene addChild: self.level];
    
    // Set up the interface which displays health, level, kills, and game over banner
    self.health.fontSize = 14;
    self.health.zPosition = 50000;
    [self.health setPosition: CGPointMake(self.gameScene.tileEngine.viewW/8, self.gameScene.tileEngine.viewH - self.gameScene.tileEngine.viewH/10)];
    self.health.text = @"health: ";
    
    self.kills.fontSize = 14;
    self.kills.zPosition = 50000;
    [self.kills setPosition: CGPointMake(self.gameScene.tileEngine.viewW - self.gameScene.tileEngine.viewW/8, self.gameScene.tileEngine.viewH - self.gameScene.tileEngine.viewH/10)];
    self.kills.text = @"kills: ";
    
    self.gameOver.fontSize = 20;
    self.gameOver.zPosition = 50000;
    [self.gameOver setPosition: CGPointMake(-64, -64)];
    self.gameOver.text = @"Game Over";
    
    self.level.fontSize = 20;
    self.level.zPosition = 50000;
    [self.level setPosition: CGPointMake(self.gameScene.tileEngine.viewW/2, self.gameScene.tileEngine.viewH - self.gameScene.tileEngine.viewH/10)];
    self.level.text = @"level: ";
}

-(void) update {
    // Update the text in the HUD labels
    self.health.text = [NSMutableString stringWithFormat: @"health: %d", self.gameScene.player.hp];
    self.kills.text = [NSMutableString stringWithFormat: @"kills: %d", self.gameScene.player.kills];
    self.level.text = [NSMutableString stringWithFormat: @"level: %d", self.gameScene.enemyEngine.level];
}

-(void) showGameOver {
    // Present the game over banner
    [self.gameOver setPosition: CGPointMake(self.gameScene.tileEngine.viewW/2, self.gameScene.tileEngine.viewH/2)];
}

@end
