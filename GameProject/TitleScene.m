//
//  TitleScene.m
//  GameProject
//
//  Created by morris miller on 7/23/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "TitleScene.h"

@implementation TitleScene

-(void)didMoveToView:(SKView *)view {
    // Get screen dimensions
    int screenW = [[UIScreen mainScreen] bounds].size.width;
    int screenH = [[UIScreen mainScreen] bounds].size.height;
    
    // create the start game button
    self.button = [[SKLabelNode alloc]initWithFontNamed: @"Courier"];
    [self.button setPosition: CGPointMake(screenW/2, screenH/8)];
    self.button.text = @"Start Game";
    self.button.name = @"startButton";
    [self.button setZPosition: 2];
    
    // add the button to the scene
    [self addChild: self.button];
    
    // create the background image and size it appropriately based on screen dimensions
    SKSpriteNode * bg = [[SKSpriteNode alloc]initWithImageNamed : @"background"];
    bg.anchorPoint = CGPointMake(0.5, 0.5);
    [bg setPosition: CGPointMake(screenW/2, screenH/2)];
    [self addChild : bg];
    [bg setZPosition : 0];
    float scaleFactor = screenW / bg.size.width;
    [bg setXScale : scaleFactor];
    [bg setYScale : scaleFactor];
    
    // Construct URL to sound file
    //NSString *path = [NSString stringWithFormat:@"%@/gameSongDrumAndBass.wav", [[NSBundle mainBundle] resourcePath]];
    //NSURL *soundUrl = [NSURL fileURLWithPath:path];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch * touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        // if next button touched, start transition to next scene
        if ([node.name isEqualToString:@"startButton"]) {
            [self.gameViewController startGame];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   
}

-(void)update:(CFTimeInterval)currentTime {

}

-(void) dealloc {

}

@end
