//
//  MutilTaskDownloader.h
//  wow
//
//  Created by danal on 11-8-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MultiThreadDownloader.h"

@protocol MultiTaskDownloaderDelegate;

@interface MultiTaskDownloader : NSObject <MultiThreadDownloaderDelegate>{
    NSMutableArray *taskUrlListArray;
    NSInteger concurrentTaskCount;
    NSInteger   maxIndexOfStarted;
    id<MultiTaskDownloaderDelegate> delegate;
}

@property(retain,nonatomic) id<MultiTaskDownloaderDelegate> delegate;
@property(assign,nonatomic) NSInteger concurrentTaskCount;
@property(retain,nonatomic) NSMutableArray *taskUrlListArray;

-(void)start;
-(void)addTaskUrl:(NSString *)aUrl;
@end


@protocol MultiTaskDownloaderDelegate <NSObject>
@optional
-(void)taskDidFinished:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader;
-(void)taskDidReceivedMessage:(NSString *)message taskLoader:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader;
-(void)taskProgressDidUpdated:(CGFloat)progress taskLoader:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader;

@end