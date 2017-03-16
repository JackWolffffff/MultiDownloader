//
//  MyOperation.m
//  wow
//
//  Created by danal on 11-8-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "OperationThread.h"


@implementation OperationThread
@synthesize path;
@synthesize startOffset;
@synthesize length;
@synthesize opid;
@synthesize  urlString;
@synthesize fh;
@synthesize delegate;

-(void)dealloc{
    [super dealloc];
    [path release];
    [urlString release];
    [connection release];
    [request release];
    [fh release];
    [delegate release];
}

-(void)main{
//        NSLog(@"%d %llu %llu",opid,startOffset,length);
        [self echoLog:[NSString stringWithFormat:@"Thread %d created.",opid]];
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString] cachePolicy:0 timeoutInterval:60];
        NSString *rangeValue = [NSString stringWithFormat:@"bytes=%llu-%llu",startOffset,startOffset + length - 1];
        [request setValue:rangeValue forHTTPHeaderField:@"Range"];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
        receivedLength = 0;
        done = NO;
    
        if (connection != nil) {
            do{
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];    //这个NSRunLoop貌似很有用!!!
            } while (!done) ;
        }

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
//    NSLog(@"-------------------response received-----------------");
    [self echoLog:[NSString stringWithFormat:@"Thread %d start to download.",opid]];
    dataRecv = [[NSMutableData alloc] init];
    condition =[[NSCondition alloc] init];
    self.fh = [NSFileHandle fileHandleForWritingAtPath:path];
    [fh seekToFileOffset:startOffset];
    currentOffset = startOffset;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
//    NSLog(@"recvd length:%d",[data length]);
    unsigned long long len = [data length];
    if ([delegate respondsToSelector:@selector(lengthOfReceivedData:)]) {
        [delegate lengthOfReceivedData:len];
    }
    receivedLength += len;
    [self.fh writeData:data];
    currentOffset += len;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)_connection{
    
    [condition lock];
    [self.fh closeFile];
    [condition unlock];
    done = YES;
    connection = nil;
    request = nil;
//    NSLog(@"thread %d finished",opid);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"err%@",[error description]);
    [self  echoLog:@"cannot connect to the resource "];
}


-(void)echoLog:(NSString *)log{
    if ([delegate respondsToSelector:@selector(threadMessageDidReceived:)]) {
        [delegate threadMessageDidReceived:log];
    }
}
@end
