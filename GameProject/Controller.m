//
//  Controller.m
//  GameProject
//
//  Created by morris miller on 7/14/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "Controller.h"
#import "GameScene.h"
#import <Foundation/Foundation.h>
@implementation Controller

- (id)init {
    self = [super init];
    // get screen dimensions
    float screenW = [[UIScreen mainScreen] bounds].size.width;
    float screenH = [[UIScreen mainScreen] bounds].size.height;
    
    // Set up user interface elements of the controller
    // Controller consists of two control sticks which each consist of 2 circles
    CGRect circle = CGRectMake(50, 50, 100.0, 100.0);
    self.circle1 = [[SKShapeNode alloc] init];
    self.circle1.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    
    self.circle1.fillColor = [SKColor darkGrayColor];
    self.circle1.lineWidth = 0;
    self.circle1.zPosition = 150200;
    self.circle1.alpha = 0.5;
    
    CGRect circle2 = CGRectMake(screenW - 150, 50, 100.0, 100.0);
    self.circle2 = [[SKShapeNode alloc] init];
    self.circle2.path = [UIBezierPath bezierPathWithOvalInRect:circle2].CGPath;
    self.circle2.fillColor = [SKColor darkGrayColor];
    self.circle2.lineWidth = 0;
    self.circle2.zPosition = 150200;
    self.circle2.alpha = 0.5;
    
    self.circle1X = 100;
    self.circle1Y = 100;
    self.circle2X = screenW - 100;
    self.circle2Y = 100;
    
    self.stick1X = self.circle1X;
    self.stick1Y = self.circle1Y;
    self.stick2X = self.circle2X;
    self.stick2Y = self.circle2Y;
    
    CGRect circle3 = CGRectMake(self.stick1X - 10, self.stick1Y - 10, 20, 20);
    self.stick1 = [[SKShapeNode alloc] init];
    self.stick1.path = [UIBezierPath bezierPathWithOvalInRect:circle3].CGPath;
    self.stick1.fillColor = [SKColor lightGrayColor];
    self.stick1.lineWidth = 0;
    self.stick1.zPosition = 150200;
    self.stick1.alpha = 0.5;
    
    CGRect circle4 = CGRectMake(self.stick2X - 10, self.stick2Y - 10, 20, 20);
    self.stick2 = [[SKShapeNode alloc] init];
    self.stick2.path = [UIBezierPath bezierPathWithOvalInRect:circle4].CGPath;
    self.stick2.fillColor = [SKColor lightGrayColor];
    self.stick2.lineWidth = 0;
    self.stick2.zPosition = 150200;
    self.stick2.alpha = 0.5;
    
    return self;
}

-(void)link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

-(void)addToScene {
    [self.gameScene addChild: self.circle1];
    [self.gameScene addChild: self.circle2];
    [self.gameScene addChild: self.stick1];
    [self.gameScene addChild: self.stick2];
}

// Use trigonometry to find the direction each stick is being pushed, if any.
-(void)update {
    
    // Get disntace from center of stick 1
    int difX = self.stick1X - self.circle1X;
    int difY = self.stick1Y - self.circle1Y;

    int dx = abs(difX);
    int dy = abs(difY);
    int dist = sqrt(dx*dx + dy*dy);
    
    // Calculate the theta (angle of direction) for stick 1
    double theta = 0;
    float force = 0;
    self.stick1Hyp = sqrt(dx*dx + dy*dy);

    
    if (difX > 0 && difY >= 0) {
        theta = asin(dy/self.stick1Hyp);
        force = 1;
    }
    if (difX <= 0 && difY > 0) {
        theta = M_PI/2 + asin(dx/self.stick1Hyp);
        force = 1;
    }
    if (difX < 0 && difY <= 0) {
        theta = M_PI + asin(dy/self.stick1Hyp);
        force = 1;
    }
    if (difX >= 0 && difY < 0) {
        theta = M_PI/2 * 3 + asin(dx/self.stick1Hyp);
        force = 1;
    }
    
    // If the hypotenuse is small, then set it to zero
    if (self.self.stick1Hyp < 1) {
        self.self.stick1Hyp = 0;
    }
    
    // Hypotenuse value maxes out at 2
    if (self.self.stick1Hyp > 2) {
        self.self.stick1Hyp = 2;
    }
    self.stick1Theta = theta;

    // Now repeat everything for stick 2
    difX = self.stick2X - self.circle2X;
    difY = self.stick2Y - self.circle2Y;
    
    dx = abs(difX);
    dy = abs(difY);
    dist = sqrt(dx*dx + dy*dy);
    
    theta = 0;
    force = 0;
    self.stick2Hyp = sqrt(dx*dx + dy*dy);
    
    if (difX > 0 && difY >= 0) {
        theta = asin(dy/self.stick2Hyp);
        force = 1;
    }
    if (difX <= 0 && difY > 0) {
        theta = M_PI/2 + asin(dx/self.stick2Hyp);
        force = 1;
    }
    if (difX < 0 && difY <= 0) {
        theta = M_PI + asin(dy/self.stick2Hyp);
        force = 1;
    }
    if (difX >= 0 && difY < 0) {
        theta = M_PI/2 * 3 + asin(dx/self.stick2Hyp);
        force = 1;
    }
    
    if (self.self.stick2Hyp < 1) {
        self.self.stick2Hyp = 0;
    }
    if (self.self.stick2Hyp >= 1) {
        self.self.stick2Hyp = 24;
    }
    self.stick2Theta = theta;
}

// If the touch is close engouh to either stick, then it will effect that stick
// We save a reference to that touch so that we can detect the letting go of that stick
-(void)touch: (CGPoint) pt : (UITouch *) touch {
    
    int difX = pt.x - self.circle1X;
    int difY = pt.y - self.circle1Y;
    int dx = abs(difX);
    int dy = abs(difY);
    int dist = sqrt(dx*dx + dy*dy);
    
    if (dist < 100) {
        self.stick1X = pt.x;
        self.stick1Y = pt.y;
        self.stick1Touch = touch;
    }
    
    difX = pt.x - self.circle2X;
    difY = pt.y - self.circle2Y;
    dx = abs(difX);
    dy = abs(difY);
    dist = sqrt(dx*dx + dy*dy);
    if (dist < 100) {
        self.stick2X = pt.x;
        self.stick2Y = pt.y;
        self.stick2Touch = touch;
    }
}

-(void)untouch: (CGPoint) pt : (UITouch *) touch{
    if (touch == self.stick1Touch) {
        self.stick1X = self.circle1X;
        self.stick1Y = self.circle1Y;
    }
    if (touch == self.stick2Touch) {
        self.stick2X = self.circle2X;
        self.stick2Y = self.circle2Y;
    }
}

@end