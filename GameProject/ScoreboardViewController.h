//
//  ScoreViewController.h
//  GameProject
//
//  Created by morris miller on 7/22/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreboardViewController : UITableViewController
{
    NSArray *scores;
}

-(NSString *) getDbFilePath;
-(void) setScores:(NSArray *) scores_;
-(int) createTable:(NSString *) filePath;
-(int) insert:(NSString *)filePath withInitials:(NSString *)initials withScore:(NSString *)score;
-(int) delete:(NSString *) filePath;

@end
