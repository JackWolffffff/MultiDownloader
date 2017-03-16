//
//  MultiDownloaderViewController.h
//  MultiDownloader
//
//  Created by danal on 11-8-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MultiThreadDownloader.h"
#import "MultiTaskDownloader.h"

@interface MultiDownloaderViewController : UIViewController <MultiTaskDownloaderDelegate,UITableViewDataSource>{
    IBOutlet UITableView *table;
    MultiTaskDownloader *taskDownloader;
}
@property(retain,nonatomic) UITableView *table;
@property(retain,nonatomic) MultiTaskDownloader *taskDownloader;

-(IBAction)batchDownload;
-(void)showToLogView:(NSString *)text;
@end
