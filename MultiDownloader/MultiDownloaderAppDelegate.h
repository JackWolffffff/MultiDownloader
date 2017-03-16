//
//  MultiDownloaderAppDelegate.h
//  MultiDownloader
//
//  Created by danal on 11-8-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MultiDownloaderViewController;

@interface MultiDownloaderAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MultiDownloaderViewController *viewController;

@end
