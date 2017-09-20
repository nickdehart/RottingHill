//
//  Player.m
//  GameProject
//
//  Created by morris miller on 7/13/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@implementation Player

// Initialize the player's member data
- (id)init {
    self = [super initWithImageNamed:@"man1"];
    self.width = 32;
    self.height = 24;
    self.frameNum = 0;
    self.kills = 0;
    self.hp = 100;
    self.state = 0;
    self.anchorPoint = CGPointMake(0, 0);
    self.face = 0;
    
    self.gun = [[SKSpriteNode alloc]initWithImageNamed: @"gun1"];
    self.gun.anchorPoint = CGPointMake(0, 0);
    
    return self;
}

// Set reference to the game scene and add children to it
-(void) link : (GameScene *) gameScene {
    self.gameScene = gameScene;
    [self.gameScene addChild: self.gun];
}

// Spawn the player at a given map cell
-(void) spawn: (Cell *) spawn {
    self.x = spawn.x;
    self.y = spawn.y;
    self.z = (spawn.z + 1);
    
    [self setXScale : (1)];
    [self.gun setXScale : (1)];
    
    [self.gun setPosition : CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX - 25, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
    [self.gun setZPosition : self.z + 1];
    
    [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
    [self setZPosition: self.z];
}

-(void) update {
    
    // State 0: Normal play mode
    if (self.state == 0) {
        // Update frame property for animation
        self.frameNum++;
        if (self.frameNum > 8 * 3) {
            self.frameNum = 0;
        }
        int myFrame = self.frameNum/8;
        
        // Set texture based on animation frame number
        if (myFrame == 0) {
            [self setTexture: [SKTexture textureWithImageNamed: @"man1"]];
            [self.gun setTexture : [SKTexture textureWithImageNamed: @"gun1"]];
        }
        else if (myFrame == 1) {
            [self setTexture: [SKTexture textureWithImageNamed: @"man2"]];
            [self.gun setTexture : [SKTexture textureWithImageNamed: @"gun2"]];
        }
        else if (myFrame == 2) {
            [self setTexture: [SKTexture textureWithImageNamed: @"man3"]];
            [self.gun setTexture : [SKTexture textureWithImageNamed: @"gun3"]];
        }
        
        // If the right stick is being pushed, set the player's facing direction accordingly
        if (self.gameScene.controller.stick2Hyp > 0) {
            if (self.gameScene.controller.stick2Theta > M_PI/2 && self.gameScene.controller.stick2Theta < M_PI/2 * 3) {
                self.face = 0;
            }
            else {
                self.face = 1;
            }
            
            // Tell the bullet engine to try to shoot a bullet
            [self.gameScene.bulletEngine spawn];
            [self bump : self.gameScene.controller.stick2Theta - M_PI : 2];
        }
        
        // Velocity x and y
        float vx = 0;
        float vy = 0;
        
        // Set velocities based on left control stick using trig functions
        vx = cos(self.gameScene.controller.stick1Theta) * self.gameScene.controller.stick1Hyp;
        vy = sin(self.gameScene.controller.stick1Theta) * self.gameScene.controller.stick1Hyp;
        
        // Scale velocities by magic number to give desired player speed
        vx *= 2;
        vy *= 2;
        
        // Call move function with velocities
        [self move : vx : vy];
    }
    
    // State 0: Dead state. Wait 5 seconds to create dramatic pause
    else if (self.state == 1) {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange >= 5000) {
            self.gameScene.state = 2;
        }
    }
    
    // State 2: Aquired damage. Player flashes white. Wait 50 ms then set texture back to normal
    else if (self.state == 2) {
        long long time = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        if (time - self.lastStateChange >= 50) {
            self.state = 0;
            [self setTexture : [SKTexture textureWithImageNamed : @"man1"]];
            [self.gun setTexture : [SKTexture textureWithImageNamed : @"gun1"]];
        }
    }
    
    // As long as player is not dead we set his facing direction based on the right stick
    // Direction is achieved by scaling and setting positions of player and gun sprites
    if (self.state != 1) {
        if (self.face == 0) {
            [self setXScale : (1)];
            [self.gun setXScale : (1)];
            [self.gun setPosition : CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX - 25, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
            [self.gun setZPosition : self.z + 1];
            
            [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
            [self setZPosition: self.z];
        }
        else if (self.face == 1) {
            [self setXScale : (-1)];
            [self.gun setXScale : (-1)];
            [self.gun setPosition : CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX + 25 + self.width, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
            [self.gun setZPosition : self.z + 1];
            
            [self setPosition: CGPointMake(self.gameScene.tileEngine.originX + self.x - self.gameScene.tileEngine.viewX + self.width, self.gameScene.tileEngine.originY + self.y - self.gameScene.tileEngine.viewY)];
            [self setZPosition: self.z];
        }
    }
}

// Move function. This checks for collisions and moves the player if possible
-(void) move : (int) vx : (int) vy {
    
    // Calculate coordinates of the 4 sides of the player's hit box
    // At the location which it will be if movement is completed
    int south = self.y + vy;
    int north = self.y + self.height + vy;
    int west = self.x + vx;
    int east = self.x + self.width + vx;
    
    // Get the cells that each corner of the player is contacting
    Cell * SWCell = [self.gameScene.map GetCellAt: west : south];
    Cell * SECell = [self.gameScene.map GetCellAt: east : south];
    Cell * NWCell = [self.gameScene.map GetCellAt: west : north];
    Cell * NECell = [self.gameScene.map GetCellAt: east : north];
    
    // Make sure all cells can be walked upon
    if (SWCell.walkable == YES && SECell.walkable == YES && NWCell.walkable == YES && NECell.walkable == YES) {
        
        // Check for collisions with the enemies at each of the player's corners
        Mob * SWMob = [self.gameScene.enemyEngine hitCheckMob: west : south];
        Mob * SEMob = [self.gameScene.enemyEngine hitCheckMob: east : south];
        Mob * NWMob = [self.gameScene.enemyEngine hitCheckMob: west : north];
        Mob * NEMob = [self.gameScene.enemyEngine hitCheckMob: east : north];
        
        // If we are touching an enemy, then we can't move that way, so return
        if (SWMob != NO || SEMob != NO || NWMob != NO || NEMob != NO) {
            return;
        }
        
        // Check for collisions with the enemies at each of the player's corners
        Tank * SWTank = [self.gameScene.enemyEngine hitCheckTank: west : south];
        Tank * SETank = [self.gameScene.enemyEngine hitCheckTank: east : south];
        Tank * NWTank = [self.gameScene.enemyEngine hitCheckTank: west : north];
        Tank * NETank = [self.gameScene.enemyEngine hitCheckTank: east : north];
        
        // If we are touching an enemy, then we can't move that way, so return
        if (SWTank != NO || SETank != NO || NWTank != NO || NETank != NO) {
            return;
        }
        
        // Movement is valid, so apply velocities to position
        self.x += vx;
        self.y += vy;
        
        // Set the Z coordinate of the player to be just above the tile his south west corner occupies
        self.z = SWCell.z + 1;
    }
}

// Bump the player in a given direction
-(void) bump : (float) theta : (int) force {
    int vx = 0;
    int vy = 0;
    vx = cos(theta) * force;
    vy = sin(theta) * force;
    [self move : vx : vy];
}

// Apply damage to player
-(void) damage : (int) vx : (int) vy : (int) dmg {
    if (self.state != 1) {
        
        // Calculate damage and apply it to health
        //int dmg = arc4random_uniform(10);
        //dmg += 6;
        self.hp -= dmg;
        
        // Play damage sound
        [self.gameScene.gameViewController.soundPlayer playHurt];
        
        // Set player to the damaged state, siwtch to damaged player textures
        // State will go back to normal after a short delay causing the player to blink
        self.state = 2;
        self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        [self setTexture : [SKTexture textureWithImageNamed : @"manHurt"]];
        [self.gun setTexture : [SKTexture textureWithImageNamed : @"gunHurt"]];
        
        // If the player is dead, then animate the death
        if (self.hp <= 0){
            [self setTexture : [SKTexture textureWithImageNamed : @"man1"]];
            [self.gun setTexture : [SKTexture textureWithImageNamed : @"gun1"]];
            
            
            if (self.face == 0) {
                [self.gun runAction: [SKAction rotateByAngle : M_PI/2 duration : 0]];
                [self.gun setPosition : CGPointMake(self.x - self.gameScene.tileEngine.viewX + 40, self.y - self.gameScene.tileEngine.viewY - 86)];
                
                [self runAction: [SKAction rotateByAngle : M_PI/2 duration : 0]];
                [self setAnchorPoint : CGPointMake(0, 1)];
            }
            
            else if (self.face == 1) {
                [self.gun runAction: [SKAction rotateByAngle : M_PI/2 duration : 0]];
                [self.gun setPosition : CGPointMake(self.x - self.gameScene.tileEngine.viewX + 72, self.y - self.gameScene.tileEngine.viewY  - 14)];
                
                [self runAction: [SKAction rotateByAngle : M_PI/2 duration : 0]];
                [self setAnchorPoint : CGPointMake(1, 1)];
            }
            
            // Show the game over banner for a few seconds
            self.hp = 0;
            [self.gameScene.hud showGameOver];
            self.state = 1;
            self.lastStateChange = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
        }
        [self move : vx : vy];
    }
}


// Check if a point is touching the player
-(BOOL) hitCheck : (int) x : (int) y {
    if (x >= self.x && x <= self.x + self.width && y >= self.y && y <= self.y + self.height) {
        return YES;
    }
    return NO;
}

-(void)dealloc {

}
@end
