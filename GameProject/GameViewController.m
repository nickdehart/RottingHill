//
//  GameViewController.m
//  GameProject
//
//  Created by morris miller on 7/13/16.
//  Copyright (c) 2016 morris miller. All rights reserved.
//

#import "GameViewController.h"
#import "TitleScene.h"
#import "GameScene.h"

@implementation GameViewController

- (void)viewWillLayoutSubviews
{
    [super viewDidLoad];
    
    // Create database and sound player instances
    self.database = [[Database alloc]init];
    self.soundPlayer = [[SoundPlayer alloc]init];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    // Create scene instances
    self.titleScene = [[TitleScene alloc]init];
    self.titleScene.scaleMode = SKSceneScaleModeResizeFill;
    self.titleScene.gameViewController = self;
    
    // Start the title music and present the title scene
    [self.soundPlayer playTitleMusic];
    [skView presentScene: self.titleScene];
}

-(void) startGame {
    [self.soundPlayer stopTitleMusic];
    [self.soundPlayer playGameMusic];
    
    SKTransition *transition = [SKTransition flipVerticalWithDuration : 0.5];
    SKView * skView = (SKView *)self.view;
    
    self.gameScene = [[GameScene alloc]init];
    self.gameScene.scaleMode = SKSceneScaleModeResizeFill;
    self.gameScene.gameViewController = self;
    
    [skView presentScene : self.gameScene transition : transition];
}

-(void) goToMenu {
    [self.soundPlayer playTitleMusic];
    
    SKTransition *transition = [SKTransition flipVerticalWithDuration : 0.5];
    SKView * skView = (SKView *)self.view;
    
    self.titleScene = [[TitleScene alloc]init];
    self.titleScene.scaleMode = SKSceneScaleModeResizeFill;
    self.titleScene.gameViewController = self;
    
    [skView presentScene : self.titleScene transition : transition];
}

-(void) goToGameOver {
    [self.soundPlayer stopGameMusic];
    int kills = self.gameScene.player.kills;
    int level = self.gameScene.enemyEngine.level;
    
    SKTransition *transition = [SKTransition flipVerticalWithDuration : 0.5];
    SKView * skView = (SKView *)self.view;
    self.gameOverScene = [[GameOverScene alloc]init];
    self.gameOverScene.scaleMode = SKSceneScaleModeResizeFill;
    self.gameOverScene.gameViewController = self;
    
    [self.gameOverScene initializeScore : kills : level];
    
    [self.gameScene removeAllActions];
    [self.gameScene removeAllChildren];
    
    [skView presentScene : self.gameOverScene transition : transition];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
