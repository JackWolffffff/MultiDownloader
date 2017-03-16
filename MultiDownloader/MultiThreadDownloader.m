//
//  MultiDownloader.m
//  wow
//
//  Created by danal on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MultiThreadDownloader.h"


@implementation MultiThreadDownloader
@synthesize urlString;
@synthesize maxConcurrent;
@synthesize  delegate;
@synthesize savePath;
@synthesize receivedLength;
@synthesize size;
@synthesize taskid;

-(id)init{
    if ((self = [super init])) {
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
    [urlString release];
    [savePath release];
    [delegate release];
    [queue release];

}

-(void)echoLog:(NSString *)log{
    if ([delegate respondsToSelector:@selector(taskMessageDidReceived:loader:)]) {
        [delegate taskMessageDidReceived:log loader:self];
    }
}

-(void)start{
    NSURLRequest *_request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:10];
    NSURLConnection *_connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:YES];
    [_request release];
    [_connection release];

}

#pragma mark - 
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",[error description]);
    [self  echoLog:@"cannot connect to the resource "];
}

-(void)connection:(NSURLConnection *)_connection didReceiveResponse:(NSURLResponse *)response{
    [_connection cancel];
    //get file size
    size = [response expectedContentLength];
    [self echoLog:[NSString stringWithFormat:@"file size:%llu",size]];
    
    if (maxConcurrent < 1) {
        maxConcurrent = 1;
    }
    //create file
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *fullname = [urlString lastPathComponent];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:fullname];
    [fm createFileAtPath:path contents:nil attributes:nil];
    
    self.savePath = path;
    unsigned long long offset = size/maxConcurrent;
    offset += size%maxConcurrent;
    unsigned long long location = 0;
    receivedLength = 0;
   queue = [[NSOperationQueue alloc] init];
    
    completedOpreationCount = 0;
    for (int i = 0; i < maxConcurrent; i++) {
        OperationThread *op = [[OperationThread alloc] init];
        op.delegate = self;
        [op setCompletionBlock:^{
            [self echoLog:[NSString stringWithFormat:@"Thread %d completed",i+1]];
            completedOpreationCount++;
        } ];
        op.opid = i+1;
        op.urlString = self.urlString;
        op.path = path;
        op.startOffset = location;
        op.length = location + offset > size ? size - location : offset;
        [queue addOperation:op];
        [op release];
        
        location += offset;
    }

}

#pragma mark -
-(void)threadMessageDidReceived:(NSString *)message{
    [self echoLog:message];
}

-(void)lengthOfReceivedData:(unsigned long long)length{
    receivedLength += length;
    if ([delegate respondsToSelector:@selector(taskProgressDidUpdated:loader:)]) {
        
        [delegate taskProgressDidUpdated:1.0*receivedLength/size loader:self];
    }
    if (receivedLength == size) {
        [queue cancelAllOperations];
        if ([delegate respondsToSelector:@selector(taskDidFinished:)]) {
            [delegate taskDidFinished:self];
        }
    }
    [self echoLog:[NSString stringWithFormat:@"%.0f%%: %llu / %llu finished.",100.0*receivedLength/size,receivedLength,size]];
    
}

@end
