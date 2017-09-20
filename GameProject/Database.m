//
//  Database.m
//  GameProject
//
//  Created by morris miller on 7/24/16.
//  Copyright © 2016 morris miller. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import <sqlite3.h>

@implementation Database

-(id) init {
    self = [super init];
    if(![ [NSFileManager defaultManager] fileExistsAtPath:[self getDbFilePath] ]) //if the file does not exist
    {
        [self createTable:[self getDbFilePath]];
    }
    return self;
}

-(NSString *) getDbFilePath {
    NSString *docsPath= NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [docsPath stringByAppendingPathComponent:@"highScores.db"];
}

// Create the table for the high scores
-(int) createTable:(NSString *) filePath {
    sqlite3 *db = NULL;
    int rc=0;
    
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char * query ="CREATE TABLE IF NOT EXISTS highScores ( id INTEGER PRIMARY KEY AUTOINCREMENT, name  TEXT, score INTEGER)";
        char * errMsg;
        rc = sqlite3_exec(db, query, NULL, NULL, &errMsg);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s", rc, errMsg);
        }
        
        sqlite3_close(db);
    }
    
    return rc;
}


// Insert a score
-(int) insert:(NSString *)filePath : (NSString *) name : (int) score {
    NSLog(@"database function, name: %@ score: %d", name, score);
    sqlite3* db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    NSLog(@"Score = %d", score);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO highScores (name, score) VALUES (\"%@\", \"%d\")"
                             , name, score];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] , NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    return rc;
}


// Get all scores
-(NSMutableArray *) getRecords:(NSString*) filePath {
    NSMutableArray * scores =[[NSMutableArray alloc] init];
    sqlite3 * db = NULL;
    sqlite3_stmt * stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from highScores ORDER BY score DESC;";
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString * name = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                int score = sqlite3_column_int(stmt, 2);
                
                Score * scoreObject = [[Score alloc]init];
                scoreObject.name = name;
                scoreObject.score = score;
                [scores addObject : scoreObject];
                
            }
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    return scores;
}

// Delete all scores
-(int) deleteAll:(NSString *) filePath
{
    sqlite3 *db = NULL;
    int rc=0;
    rc = sqlite3_open_v2([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM highScores"];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String], NULL, NULL, &errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete records  rc:%d, msg=%s", rc, errMsg);
        }
        sqlite3_close(db);
    }
    
    return  rc;
}


@end
