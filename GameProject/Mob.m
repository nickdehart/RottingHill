
//
//  Mob.m
//  GameProject
//
//  Created by morris miller on 7/17/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import "Mob.h"
#import <Foundation/Foundation.h>
@implementation Mob

// Initialize the monster sprite
-(id) init {
    self = [super initWithImageNamed: @"zombie1"];
    self.x = 0;
    self.y = 0;
    self.width = 24;
    self.height = 24;
    self.state = 0;
    self.lastAttack = 0;
    self.lastStateChange = 0;
    self.minAgro = 200;
    self.maxAgro = 350;
    [self setAnchorPoint: CGPointMake(0, 0)];
    [self setPosition: CGPointMake(-64, -64)];
    self.hp = 100;
    self.dmg = 0;
    return self;
}

-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
}

// Damage, check if dead and bump
-(void) damage : (float) theta {
    self.hp -= 20;
    self.state = 5;
    if (self.hp <= 0){
        self.gameScene.player.kills++;
        [self reset];
        return;
    }
    
    float vx = 0;
    float vy = 0;
    vx = cos(theta) * 8;
    vy = sin(theta) * 8;
    
    self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    [self move : vx : vy];
}

-(void) reset {
    self.state = 0;
    [self setPosition: CGPointMake(-64, -64)];
}

// Get distance between mob and player
-(int) distToPlayer {
    int dx = abs(self.gameScene.player.x - self.x);
    int dy = abs(self.gameScene.player.y - self.y);
    int distance = sqrt(dx * dx + dy * dy);
    return distance;
}

-(void) update {
    
    // Handle animation
    self.frameNum++;
    if (self.frameNum > 8 * 3) {
        self.frameNum = 0;
    }
    if (self.state != 5) {
        int myFrame = self.frameNum/8;
        if (myFrame == 0) {
            [self setTexture: [SKTexture textureWithImageNamed: @"zombie1"]];
        }
        else if (myFrame == 1) {
            [self setTexture: [SKTexture textureWithImageNamed: @"zombie2"]];
            
        }
        else if (myFrame == 2) {
            [self setTexture: [SKTexture textureWithImageNamed: @"zombie3"]];
            
        }
    }
    
    // Sate 1: Wander mode, pick a random direction and walk that way
    if (self.state == 1) {
        int randAction = arc4random_uniform(2);
        if (randAction == 0) {
            // walk
            self.direction = arc4random_uniform(4);
            self.state = 2;
        }
        else if (randAction == 1) {
            //wait
            self.state = 3;
        }
        self.timer = 0;
    }
    
    // State 2: Walk mode, direction has been picked, walk that direction until
    // time to pick a new direction
    else if (self.state == 2) {
        
        // Player is relatively close, go to pursuit mode
        int distToPlayer = [self distToPlayer];
        if (distToPlayer < self.minAgro) {
            self.state = 4;
            return;
        }
        
        // Player is far away, reset this mob to re spawn closer to player
        if (distToPlayer > 1000) {
            [self reset];
        }
        
        // calculate velocities based on direction
        int vx = 0;
        int vy = 0;
        switch (self.direction) {
            case 0:
                vy = 1;
                break;
            case 1:
                vy = -1;
                break;
            case 2:
                vx = 1;
                break;
            case 3:
                vx = -1;
                break;
            default:
                break;
        }
        
        vx *= 2;
        vy *= 2;
        
        // Try to move mob, if impossible, then reset the state to wander to pick a new direction
        BOOL didMove = [self move: vx :vy];
        if (!didMove) {
            self.state = 1;
        }
        
        // Check if we have walked far enought, if so, set to wait mode
        self.timer++;
        if (self.timer >= 16) {
            self.state = 3;
            self.timer = 0;
        }
    }
    
    // State 3: wait mode. Wait a while then go back to wander mode to pick a new direction
    else if (self.state == 3) {
        
        // If player is close, go to pursuit mode
        int distToPlayer = [self distToPlayer];
        if (distToPlayer < self.minAgro) {
            self.state = 4;
            return;
        }
        
        // If player is really far away reset mob
        if (distToPlayer > 1000) {
            [self reset];
        }
        
        self.timer++;
        if (self.timer >= 8) {
            self.state = 1;
        }
    }
    
    // State 4: pursuit mode
    else if (self.state == 4) {
        
        // If player has escaped far enough, go back to wandering
        int distToPlayer = [self distToPlayer];
        if (distToPlayer >= self.maxAgro) {
            self.state = 1;
            return;
        }
        
        // Player is close enough to attack, so attack him
        if (distToPlayer < 48) {
            long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
            if (time - self.lastAttack > 500) {
                // attack the player
                // deal damage
                // set last attack time
                self.dmg = arc4random_uniform(10);
                self.dmg += 6;
                [self.gameScene.player damage : self.vx * 2 : self.vy * 2 : self.dmg];
                self.lastAttack = time;
            }
        }
        
        // Figure out which way to move when chasing player
        int difX = self.gameScene.player.x - self.x;
        int difY = self.gameScene.player.y - self.y;
        
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
        
        if (hyp < 1) {
            hyp = 0;
        }
        if (hyp > 1) {
            hyp = 2;
        }
        
        float vx = cos(theta) * hyp;
        float vy = sin(theta) * hyp;
        
        [self move : vx : vy];
    }
    
    // State 5: damage mode, blink white
    else if (self.state == 5) {
        //self.color = [SKColor whiteColor];
        //self.colorBlendFactor = 0.8;
        [self setTexture : [SKTexture textureWithImageNamed : @"zombieHurt"]];
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange > 50) {
            self.state = 4;
            //self.colorBlendFactor = 0;
            [self setTexture : [SKTexture textureWithImageNamed : @"zombie1"]];
        }
    }
    
    // Set position on screen based on coordinate system of game world
    [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
    [self setZPosition: self.z];
}

// Try to move, perform hit detection
-(BOOL) move : (float) vx : (float) vy {
    self.vx = vx;
    self.vy = vy;
    
    int north = self.y + self.height + self.vy;
    int south = self.y + self.vy;
    int east = self.x + self.width + self.vx;
    int west = self.x + self.vx;
    
    BOOL SWPlayer = [self.gameScene.player hitCheck : west : south];
    BOOL SEPlayer = [self.gameScene.player hitCheck : east : south];
    BOOL NWPlayer = [self.gameScene.player hitCheck : west : north];
    BOOL NEPlayer = [self.gameScene.player hitCheck : east : north];
    
    if (SWPlayer || SEPlayer || NWPlayer || NEPlayer) {
        self.state = 1;
        return NO;
    }
    
    Cell * SW = [self.gameScene.map GetCellAt: west : south];
    Cell * SE = [self.gameScene.map GetCellAt: east : south];
    Cell * NW = [self.gameScene.map GetCellAt: west : north];
    Cell * NE = [self.gameScene.map GetCellAt: east : north];
    
    if (SW.walkable == YES && SE.walkable == YES && NW.walkable == YES && NE.walkable == YES) {
        
        Mob * SWMob = [self.gameScene.enemyEngine hitCheckMob: west : south];
        Mob * SEMob = [self.gameScene.enemyEngine hitCheckMob: east : south];
        Mob * NWMob = [self.gameScene.enemyEngine hitCheckMob: west : north];
        Mob * NEMob = [self.gameScene.enemyEngine hitCheckMob: east : north];
        
        
        if ((SWMob != NO && SWMob != self) || (SEMob != NO && SEMob != self)||(NWMob != NO && NWMob != self) ||(NEMob != NO && NEMob != self)) {
            self.state = 1;
            return NO;
        }
        else {
            self.x += vx;
            self.y += vy;
            self.z = SW.z + 1;
            return YES;
        }
    }
    else {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastAttack > 500) {
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
            self.lastAttack = time;
        }
    }
    return NO;
}
@end
