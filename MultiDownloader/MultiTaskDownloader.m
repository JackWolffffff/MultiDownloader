//
//  MutilTaskDownloader.m
//  wow
//
//  Created by danal on 11-8-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MultiTaskDownloader.h"
#import "MultiThreadDownloader.h"

@interface MultiTaskDownloader()
-(void)startNext;
@end

@implementation MultiTaskDownloader
@synthesize taskUrlListArray;
@synthesize concurrentTaskCount;
@synthesize delegate;

-(id)init{
    if ((self = [super init])) {
        concurrentTaskCount = 1;
        maxIndexOfStarted = 0;
        self.taskUrlListArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [taskUrlListArray release];
    [delegate release];
}

-(void)start{
    for (int i = 0; i< self.concurrentTaskCount; i++) {
        [self startNext];
    }
}

-(void)startNext{
    if (maxIndexOfStarted < [self.taskUrlListArray count]) {
            
        NSString *urlString = [self.taskUrlListArray objectAtIndex:maxIndexOfStarted++];
        MultiThreadDownloader *loader = [[MultiThreadDownloader alloc] init];
        loader.taskid = maxIndexOfStarted;
        loader.delegate = self;
        loader.urlString = urlString;
        loader.maxConcurrent = 3;
        [loader start];
        [loader release];
    }
}

-(void)addTaskUrl:(NSString *)aUrl{
    [self.taskUrlListArray addObject:aUrl];
}

#pragma mark - MultiThreadDownloaderDelegate
-(void)taskDidFinished:(MultiThreadDownloader *)loader{
//    [self startNext];     //no effect
    if ([delegate respondsToSelector:@selector(taskDidFinished:threadLoader:)]) {
        [delegate taskDidFinished:self threadLoader:loader];
    }
    [self performSelectorOnMainThread:@selector(startNext) withObject:nil waitUntilDone:NO];
}

-(void)taskMessageDidReceived:(NSString *)message loader:(MultiThreadDownloader *)loader{
    if ([delegate respondsToSelector:@selector(taskDidReceivedMessage:taskLoader:threadLoader:)]) {
        [delegate taskDidReceivedMessage:message taskLoader:self threadLoader:loader];
    }
}

-(void)taskProgressDidUpdated:(CGFloat)progress loader:(MultiThreadDownloader *)loader{
    if ([delegate respondsToSelector:@selector(taskProgressDidUpdated:taskLoader:threadLoader:)]) {
        [delegate taskProgressDidUpdated:progress taskLoader:self threadLoader:loader];
    }
}
@end
