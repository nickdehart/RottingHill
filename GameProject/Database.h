//
//  Database.h
//  GameProject
//
//  Created by morris miller on 7/24/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import "GameViewController.h"
#import "Score.h"

#ifndef Database_h
#define Database_h

@class Score;
@class GameViewController;
@interface Database : NSObject

@property GameViewController * gameViewcontroller;

-(NSString *) getDbFilePath;
-(int) createTable:(NSString *) filePath;
-(int) insert:(NSString *)filePath : (NSString *) name : (int) score;
-(NSMutableArray *) getRecords:(NSString*) filePath;
-(int) deleteAll:(NSString *) filePath;

@end
#endif /* Database_h */
