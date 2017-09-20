//
//  Bullet.m
//  GameProject
//
//  Created by morris miller on 7/18/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bullet.h"
@implementation Bullet
-(id) init {
    self = [super initWithImageNamed: @"flash"];
    self.tileSize = 64;
    self.x = -16;
    self.y = -16;
    self.anchorPoint = CGPointMake(0, 0);
    self.position = CGPointMake(self.x, self.y);
    self.state = 0;
    self.lastStateChange = 0;
    return self;
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

-(void) addtoScene {
    
}

// Move the bullet
// Reset if it went off screen
// Damage players or trees when collision is detected
-(void) update {
    [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
    [self setZPosition: self.z];
    
    if (self.state == 1) {
        Cell * SW = [self.gameScene.map GetCellAt: self.x : self.y];
        if (SW != NO) self.z = SW.z + 1;
        
        [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
        [self setZPosition: self.z];
        
        Mob * SWMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x : self.y];
        Mob * SEMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + 16 : self.y];
        Mob * NWMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x : self.y + 16];
        Mob * NEMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + 16 : self.y + 16];
        
        if (SWMob != NO) {
            [SWMob damage: self.theta];
            [self explode];
            return;
        }
        
        if (SEMob != NO) {
            [SEMob damage: self.theta];
            [self explode];
            return;
        }
        
        if (NWMob != NO) {
            [NWMob damage: self.theta];
            [self explode];
            return;
        }
        
        if (NEMob != NO) {
            [NEMob damage: self.theta];
            [self explode];
            return;
        }
        
        Tank * SWTank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x : self.y];
        Tank * SETank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x + 16 : self.y];
        Tank * NWTank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x : self.y + 16];
        Tank * NETank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x + 16 : self.y + 16];
        
        if (SWTank != NO) {
            [SWTank damage: self.theta];
            [self explode];
            return;
        }
        
        if (SETank != NO) {
            [SETank damage: self.theta];
            [self explode];
            return;
        }
        
        if (NWTank != NO) {
            [NWTank damage: self.theta];
            [self explode];
            return;
        }
        
        if (NETank != NO) {
            [NETank damage: self.theta];
            [self explode];
            return;
        }

        // Make bullet blink when first shot
        [self setTexture:[SKTexture textureWithImageNamed:@"flash"]];
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange > 20){
            [self setTexture:[SKTexture textureWithImageNamed:@"bullet"]];
            self.state = 2;
            self.lastStateChange = time;
        }
    }
    
    // Bullet is flying, do hit detection
    else if (self.state == 2){
        
        int vx = self.vx;
        int vy = self.vy;
        
        Cell * SW = [self.gameScene.map GetCellAt: self.x + vx : self.y + vy];
        Cell *  SE = [self.gameScene.map GetCellAt: self.x + vx + 16 : self.y + vy];
        Cell *  NW = [self.gameScene.map GetCellAt: self.x + vx : self.y + vy + 16];
        Cell *  NE = [self.gameScene.map GetCellAt: self.x + vx + 16 : self.y + vy + 16];
        
        // check if bullet is off map, if so explode bullet
        if ((SW == NO || SE == NO || NW == NO || NE == NO) || (self.x < 0 ||self.y < 0 || self.x > 150 * self.tileSize || self.y > 100 * self.tileSize)) {
            [self explode];
        }
        else {
            
            if (SW.walkable == YES && SE.walkable == YES && NW.walkable == YES && NE.walkable == YES) {
                
                // We haven't hit a tree, so check if we hit a mob
                Mob * SWMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + vx : self.y + vy];
                Mob * SEMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + vx + 16 : self.y + vy];
                Mob * NWMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + vx : self.y + vy + 16];
                Mob * NEMob = [self.gameScene.enemyEngine hitCheckBulletMob: self.x + vx + 16 : self.y + vy + 16];
                
                self.x += vx;
                self.y += vy;
                self.z = SW.z + 1;
                
                // If we hit any mob, then damage it and explode bullet
                if (SWMob != NO) {
                    [SWMob damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (SEMob != NO) {
                    [SEMob damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (NWMob != NO) {
                    [NWMob damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (NEMob != NO) {
                    [NEMob damage: self.theta];
                    [self explode];
                    return;
                }
                
                Tank * SWTank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x : self.y];
                Tank * SETank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x + 16 : self.y];
                Tank * NWTank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x : self.y + 16];
                Tank * NETank = [self.gameScene.enemyEngine hitCheckBulletTank: self.x + 16 : self.y + 16];
                
                if (SWTank != NO) {
                    [SWTank damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (SETank != NO) {
                    [SETank damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (NWTank != NO) {
                    [NWTank damage: self.theta];
                    [self explode];
                    return;
                }
                
                if (NETank != NO) {
                    [NETank damage: self.theta];
                    [self explode];
                    return;
                }
            }
            else {
                // damage the cell that was hit
                self.x += vx;
                self.y += vy;
                self.z = SW.z + 1;
                
                if (SW.walkable == NO) {
                    [SW damage : 5];
                }
                if (SE.walkable == NO) {
                    [SE damage: 5];
                }
                if (NW.walkable == NO) {
                    [NW damage: 5];
                }
                if (NE.walkable == NO) {
                    [NE damage: 5];
                }
                [self explode];
            }
        }
    }
    
    // Make the bullet flash
    else if (self.state == 3) {
        self.x += self.vx;
        self.y += self.vy;
        [self setTexture:[SKTexture textureWithImageNamed:@"flash"]];
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange > 20){
            self.lastStateChange = time;
            [self reset];
        }
    }
}

-(void) explode {
    [self setTexture:[SKTexture textureWithImageNamed:@"flash"]];
    self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    self.state = 3;
}

-(void) reset {
    self.state = 0;
    [self setTexture: [SKTexture textureWithImageNamed: @"flash"]];
    [self setPosition: CGPointMake(-16, -16)];
}

-(void) spawn {
    [self setTexture:[SKTexture textureWithImageNamed:@"flash"]];
    int rand = arc4random_uniform(5) - 2;
    float randOffset = M_PI/32 * rand;
    
    self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    self.theta = self.gameScene.controller.stick2Theta;
    
    self.vx = cos(self.gameScene.controller.stick2Theta + randOffset) * self.gameScene.controller.stick2Hyp;
    self.vy = sin(self.gameScene.controller.stick2Theta + randOffset) * self.gameScene.controller.stick2Hyp;
    
    self.x = self.gameScene.player.x + arc4random_uniform(9) - 4 + self.vx;
    self.y = self.gameScene.player.y + arc4random_uniform(9) - 4 + self.vy;
    
    self.z = self.gameScene.player.z + 1;
    
    self.state = 1;
}

@end
