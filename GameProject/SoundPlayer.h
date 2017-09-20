//
//  SoundPlayer.h
//  GameProject
//
//  Created by morris miller on 7/25/16.
//  Copyright © 2016 morris miller. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#ifndef SoundPlayer_h
#define SoundPlayer_h
@interface SoundPlayer : NSObject
@property AVAudioPlayer * titleMusic;
@property AVAudioPlayer * gameMusic;

@property AVAudioPlayer * coin;
@property AVAudioPlayer * shot;
@property AVAudioPlayer * hurt;
@property AVAudioPlayer * powerup;

-(void) playTitleMusic;
-(void) stopTitleMusic;
-(void) playGameMusic;
-(void) stopGameMusic;

-(void) playCoin;
-(void) playShot;
-(void) playHurt;
-(void) playPowerup;
@end

#endif /* SoundPlayer_h */
