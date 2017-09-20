//
//  SoundPlayer.m
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoundPlayer.h"

@implementation SoundPlayer

-(id) init {
    self = [super init];
    // Construct URL to sound file
    NSString *path = [NSString stringWithFormat:@"%@/gameSongDrumAndBass.wav", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.titleMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.titleMusic.numberOfLoops = -1;
    
    // Construct URL to sound file
    path = [NSString stringWithFormat:@"%@/gameSong.wav", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.gameMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.gameMusic.numberOfLoops = -1;
    
    // Construct URL to sound file
    path = [NSString stringWithFormat:@"%@/coin1improved.wav", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.coin = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.coin.volume = 0.25;
    
    // Construct URL to sound file
    path = [NSString stringWithFormat:@"%@/shotimproved.wav", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.shot = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    // Construct URL to sound file
    path = [NSString stringWithFormat:@"%@/hurt.wav", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.hurt = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.hurt.volume = 0.5;
    
    // Construct URL to sound file
    path = [NSString stringWithFormat:@"%@/powerup.wav", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    // Create audio player object and initialize with URL to sound
    self.powerup = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    self.powerup.volume = 0.5;
    
    return self;
}

-(void) playTitleMusic {
    self.titleMusic.currentTime = 0;
    [self.titleMusic play];
}

-(void) stopTitleMusic {
    [self.titleMusic stop];
}

-(void) playGameMusic {
    self.gameMusic.currentTime = 0;
    [self.gameMusic play];
}

-(void) stopGameMusic {
    [self.gameMusic stop];
}

-(void) playCoin {
    [self.coin stop];
    self.coin.currentTime = 0;
    [self.coin play];
}

-(void) playShot {
    [self.shot stop];
    self.shot.currentTime = 0;
    [self.shot play];
}

-(void) playHurt {
    [self.hurt stop];
    self.hurt.currentTime = 0;
    [self.hurt play];
}
-(void) playPowerup {
    [self.powerup stop];
    self.powerup.currentTime = 0;
    [self.powerup play];
}

@end