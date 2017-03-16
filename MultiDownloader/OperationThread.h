//
//  MyOperation.h
//  wow
//
//  Created by danal on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define UUL unsigned long long

@protocol OperationThreadDelegate ;

@interface OperationThread : NSOperation {
    NSInteger opid;
    NSString *urlString;
    NSURLConnection *connection;
    NSMutableURLRequest *request;
    NSString *path;
    unsigned long long startOffset;
    unsigned long long length;
    UUL receivedLength;
    UUL currentOffset;
    BOOL done;
    NSFileHandle *fh;
    NSMutableData *dataRecv;
    NSCondition *condition;
    id<OperationThreadDelegate> delegate;
}
@property(retain) id<OperationThreadDelegate> delegate;
@property(retain) NSFileHandle *fh;
@property(retain) NSString *urlString;
@property(assign) NSInteger opid;
@property(retain) NSString *path;
@property(assign) unsigned long long startOffset;
@property(assign) unsigned long long length;

-(void)echoLog:(NSString *)log;
@end

@protocol OperationThreadDelegate <NSObject>
-(void)threadMessageDidReceived:(NSString *)message;
-(void)lengthOfReceivedData:(unsigned long long)length;
@end