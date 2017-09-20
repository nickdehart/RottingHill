//
//  GameOverScene.m
//  GameProject
//
//  Created by morris miller on 7/24/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameOverScene.h"

@implementation GameOverScene
-(void)didMoveToView:(SKView *)view {
    
    // Get screen dimensions
    self.viewW = [[UIScreen mainScreen] bounds].size.width;
    self.viewH = [[UIScreen mainScreen] bounds].size.height;
    
    // Create interface object instances
    self.scoreLabel = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    self.levelLabel = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    self.killsLabel = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    
    self.firstPlace = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    self.secondPlace = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    self.thirdPlace = [[SKLabelNode alloc]initWithFontNamed:@"Courier"];
    
    SKSpriteNode * cup = [[SKSpriteNode alloc]initWithImageNamed : @"cup"];
    SKSpriteNode * cup2 = [[SKSpriteNode alloc]initWithImageNamed : @"cup2"];
    SKSpriteNode * cup3 = [[SKSpriteNode alloc]initWithImageNamed : @"cup3"];
    
    [cup setAnchorPoint : CGPointMake(0, 0)];
    [cup2 setAnchorPoint : CGPointMake(0, 0)];
    [cup3 setAnchorPoint : CGPointMake(0, 0)];
    
    [self addChild : cup];
    [self addChild : cup2];
    [self addChild : cup3];
    
    // Create restart button
    SKLabelNode * restartButton = [[SKLabelNode alloc]initWithFontNamed: @"Courier"];
    restartButton.text = @"restart";
    restartButton.fontSize = 20;
    restartButton.name = @"restartButton";
    [restartButton setPosition : CGPointMake(self.viewW/8, self.viewH/8)];
    [self addChild : restartButton];
    
    // More interface setup
    self.killsLabel.fontSize = 16;
    self.killsLabel.text = @"kills: ";
    [self.killsLabel setPosition : CGPointMake(self.viewW/8, self.viewH/8 * 4)];
    
    self.levelLabel.fontSize = 16;
    self.levelLabel.text = @"level: ";
    [self.levelLabel setPosition : CGPointMake(self.viewW/8, self.viewH/8 * 3)];
    
    self.scoreLabel.fontSize = 16;
    self.scoreLabel.text = @"score: ";
    [self.scoreLabel setPosition : CGPointMake(self.viewW/6, self.viewH/8 * 2)];
    
    self.firstPlace.fontSize = 16;
    [self.firstPlace setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 5)];
    [cup setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 5 + 30)];
    
    self.secondPlace.fontSize = 16;
    self.secondPlace.text = @"";
    [self.secondPlace setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 3)];
    [cup2 setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 3 + 30)];
    
    self.thirdPlace.fontSize = 16;
    self.thirdPlace.text = @"";
    [self.thirdPlace setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 1)];
    [cup3 setPosition : CGPointMake(self.viewW/8 * 5, self.viewH/8 * 1 + 30)];
    
    // Kill count presentation mode
    self.state = 0;
    
    // Last state change is now
    self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    // Add interface objects to scene
    [self addChild : self.scoreLabel];
    [self addChild : self.levelLabel];
    [self addChild : self.killsLabel];
    [self addChild : self.firstPlace];
    [self addChild : self.secondPlace];
    [self addChild : self.thirdPlace];

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        SKNode *node = [self nodeAtPoint:location];
        
        // if next button touched, start transition to next scene
        if ([node.name isEqualToString:@"restartButton"]) {
            if (self.state == 3) [self.gameViewController startGame];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode: self];
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    // State 0: present kill count and level reached then wait 2 seconds
    if (self.state == 0) {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange > 2000) {
            self.state = 1;
            self.lastStateChange = time;
        }
    }
    
    // State 1: score calculation mode 60 ms wait for animated counting effect
    else if (self.state == 1) {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange > 60) {
            if (self.kills > 0) {
                [self.gameViewController.soundPlayer playCoin];
                self.kills--;
                self.score += 100;
            }
            else {
                if (self.level > 0) {
                    [self.gameViewController.soundPlayer playCoin];
                    self.level--;
                    self.score += 50;
                }
                else {
                    self.state = 2;
                }
            }
            self.lastStateChange = time;
        }
    }
    
    // State 2: check for high score and if so present banner and get initials
    else if (self.state == 2) {
        if (self.score > self.firstScore || self.score > self.secondScore || self.score > self.thirdScore) {
            SKLabelNode * highScoreBanner = [[SKLabelNode alloc]initWithFontNamed: @"Courier"];
            highScoreBanner.fontSize = 60;
            highScoreBanner.text = @"HIGH SCORE";
            [highScoreBanner setPosition: CGPointMake(self.viewW/2, self.viewH - self.viewH/6)];
            [highScoreBanner setZPosition : 100];
            [self addChild : highScoreBanner];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"Enter your name:" delegate:self cancelButtonTitle:@"Submit" otherButtonTitles:nil , nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
        }
        self.state = 3;
    }
    
    // Put text in labels
    [self.killsLabel setText: [NSString stringWithFormat: @"kills: %d", self.kills]];
    [self.levelLabel setText: [NSString stringWithFormat: @"level: %d", self.level]];
    [self.scoreLabel setText: [NSString stringWithFormat: @"score: %d", self.score]];
    
    self.firstPlace.text = [NSString stringWithFormat : @"%@ %d", self.firstName, self.firstScore];
    self.secondPlace.text = [NSString stringWithFormat : @"%@ %d", self.secondName, self.secondScore];
    self.thirdPlace.text = [NSString stringWithFormat : @"%@ %d", self.thirdName, self.thirdScore];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // The user created a new item, add it
    NSLog(@"button index : %d", buttonIndex);
    if (buttonIndex == 0) {
        // Get the input text
        NSString *newName = [[alertView textFieldAtIndex:0] text];
        NSLog(@"name : %@ score: %d", newName, self.score);
        [self.gameViewController.database insert : [self.gameViewController.database getDbFilePath]: newName : self.score];
        [self getScoresFromDB];
    }
}

-(void) initializeScore : (int) kills : (int) level {
    self.score = 0;
    self.kills = kills;
    self.level = level;
    self.state = 0;
    [self getScoresFromDB];
}

-(void) getScoresFromDB {
    NSString * path = [self.gameViewController.database getDbFilePath];
    NSMutableArray * scoreRecords = [self.gameViewController.database getRecords : path];
    
    //UN-COMMENT TO DELETE ALL RECORDS
    //[self.gameViewController.database deleteAll: path];
    
    Score * highest;
    
    // Get top 3 score records
    int i = 0;
    if (i < scoreRecords.count){
        highest = [scoreRecords objectAtIndex : i];
        self.firstName = highest.name;
        self.firstScore = highest.score;
    }
    else {
        self.firstName = @"";
        self.firstScore = 0;
    }
    i++;
    if (i < scoreRecords.count){
        highest = [scoreRecords objectAtIndex : i];
        self.secondName = highest.name;
        self.secondScore = highest.score;
    }
    else {
        self.secondName = @"";
        self.secondScore = 0;
    }
    i++;
    if (i < scoreRecords.count){
        highest = [scoreRecords objectAtIndex : i];
        self.thirdName = highest.name;
        self.thirdScore = highest.score;
    }
    else {
        self.thirdName = @"";
        self.thirdScore = 0;
    }
}

@end