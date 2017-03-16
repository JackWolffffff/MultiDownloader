//
//  MultiDownloaderViewController.m
//  MultiDownloader
//
//  Created by danal on 11-8-10.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MultiDownloaderViewController.h"
#import "MultiTaskDownloader.h"

@implementation MultiDownloaderViewController
@synthesize taskDownloader;
@synthesize table;

- (void)dealloc
{
    [super dealloc];
    [taskDownloader release];
    [table release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor clearColor];
    self.table.dataSource = self;
    [self.view addSubview:self.table];
    
    self.taskDownloader = [[MultiTaskDownloader alloc] init];
    taskDownloader.delegate = self;
    taskDownloader.concurrentTaskCount = 3;
    [taskDownloader addTaskUrl:@"http://s1.img.766.com/208/110113/2152/502229.jpg"];
    [taskDownloader addTaskUrl:@"http://www.wallcoo.com/nature/Japan_Hokkaido_Furano_Country_field_1920x1200/wallpapers/1920x1080/Japan-Hokkaido-Landscape-WUXGA_country_field_0149.jpg"];
    [taskDownloader addTaskUrl:@"http://www.sodoos.com/cms/uploads/allimg/100224/8-100224215U8.jpg"];
    [taskDownloader addTaskUrl:@"http://www.sodoos.com/cms/uploads/allimg/100224/8-100224215I7.jpg"];
    [taskDownloader addTaskUrl:@"http://www.sodoos.com/cms/uploads/allimg/100224/8-100224220106.jpg"];
    [taskDownloader addTaskUrl:@"http://www.sodoos.com/cms/uploads/allimg/100224/8-100224215S3.jpg"];
    [taskDownloader addTaskUrl:@"http://www.sodoos.com/cms/uploads/allimg/100224/8-100224220138.jpg"];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
-(void)showToLogView:(NSString *)text{
    //    NSString *oldText = [logView text];
    //    NSString *newText = [oldText stringByAppendingFormat:@"%@\n",text];
//    logView.text = text;
    //    CGSize _size = logView.contentSize;
    //    CGPoint _p = CGPointMake(0, _size.height - logView.bounds.size.height);
    //    [logView setContentOffset:_p];
}

-(IBAction)batchDownload{
    [self.taskDownloader start];
}

#pragma mark - 
-(void)taskDidReceivedMessage:(NSString *)message taskLoader:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader{
    [self performSelectorOnMainThread:@selector(showToLogView:) withObject:message waitUntilDone:NO];
}

-(void)taskProgressDidUpdated:(CGFloat)progress taskLoader:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader{
    NSInteger index = threadLoader.taskid - 1;     //increasing from 1
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];

    UIProgressView *pv = (UIProgressView *)[cell.contentView viewWithTag:index +10];
    pv.progress = progress;
}

-(void)taskDidFinished:(MultiTaskDownloader *)taskLoader threadLoader:(MultiThreadDownloader *)threadLoader{
    NSInteger index = threadLoader.taskid - 1;     //increasing from 1
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
    
    UIImageView *thumbView = (UIImageView *)[cell.contentView viewWithTag:index +100];
    thumbView.image = [UIImage imageWithContentsOfFile:threadLoader.savePath];
}

#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static    NSString *cellid = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid] autorelease];
        
        UIImageView *thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 34)];
        thumbView.tag = indexPath.row + 100;        //100
        [cell.contentView   addSubview:thumbView];
        [thumbView release];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(100, 5, 200, 10)];
        progressView.progress = .0f;
        progressView.tag = indexPath.row +10;       //10
        [cell.contentView addSubview:progressView];
        [progressView release];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 200, 20)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.text = [[self.taskDownloader.taskUrlListArray objectAtIndex:indexPath.row] lastPathComponent];
        [cell.contentView addSubview:textLabel];
        [textLabel  release];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [self.taskDownloader.taskUrlListArray count];
}
@end
