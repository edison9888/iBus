//
//  LineList_test_Controller.m
//  iBus-iPhone
//
//  Created by yanghua on 5/29/13.
//  Copyright (c) 2013 yanghua. All rights reserved.
//

#import "LineListController.h"
#import "LineListCell.h"
#import "SubLineViewController.h"
#import "LineDao.h"
#import "StationDao.h"
#import "FetchStationInfoOperation.h"
#import "StationListController.h"

static NSString *lineCellIdentifier=@"lineCellIdentifier";

@interface LineListController () <UIFolderTableViewDelegate>

@property (nonatomic,retain) SubLineViewController *subLineViewCtrller;
@property (nonatomic,retain) NSDictionary *currentLineInfo;


@end

@implementation LineListController

- (void)dealloc{
    [_currentLineInfo release],_currentLineInfo=nil;
    [_subLineViewCtrller release],_subLineViewCtrller=nil;
    
    [super dealloc];
}

- (void)loadView{
    self.view=[[[UIView alloc] initWithFrame:Default_Frame_WithoutStatusBar] autorelease];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.title=@"线路列表";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView=[[[UIFolderTableView alloc] initWithFrame:Default_TableView_Frame style:UITableViewStylePlain] autorelease];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.folderDelegate=self;
	self.dataSource=[LineDao getLineList];
    [self.tableView reloadData];
    
    [self fetchStationInfoAsync];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",self.dataSource.count);
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineListCell *cell=(LineListCell*)[tableView dequeueReusableCellWithIdentifier:lineCellIdentifier];
    if (!cell) {
        cell=[[[LineListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lineCellIdentifier] autorelease];
    }
    
    [cell initSubViewsWithModel:self.dataSource[indexPath.row]];
    [cell changeArrowWithUp:NO];
    [cell resizeSubViews];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LineListCell *currentCell=(LineListCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [currentCell changeArrowWithUp:YES];
    
    self.currentLineInfo=self.dataSource[indexPath.row];
    SubLineViewController *subVC = [[SubLineViewController alloc] initWithLineInfo:self.currentLineInfo];
    subVC.lineListCtrller=self;
    
    self.tableView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVC.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               self.tableView.scrollEnabled = YES;
                               [currentCell changeArrowWithUp:NO];
                           }];
    
    [subVC release];
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}


- (void)handleGesture:(UISwipeGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state==UIGestureRecognizerStateBegan) {
        [gestureRecognizer view].backgroundColor=EDGESTATION_VIEW_HIGHLIGHT_COLOR;
    }else if(gestureRecognizer.state==UIGestureRecognizerStateEnded){
        [gestureRecognizer view].backgroundColor=EDGESTATION_VIEW_HIGHLIGHT_COLOR;
    }else if (gestureRecognizer.state==UIGestureRecognizerStateCancelled){
        [gestureRecognizer view].backgroundColor=EDGESTATION_VIEW_NORMAL_COLOR;
    }
    
    StationListController *stationListCtrller=[[[StationListController alloc] initWithRefreshHeaderViewEnabled:NO andLoadMoreFooterViewEnabled:NO andTableViewFrame:Default_TableView_Frame] autorelease];
    stationListCtrller.lineId=self.currentLineInfo[@"lineId"];
    stationListCtrller.lineName=self.currentLineInfo[@"lineName"];
    
    switch (gestureRecognizer.view.tag) {
        case TAG_LEFT_TO_RIGHT:
        {
            stationListCtrller.identifier=@"1";
        }
            break;
            
        case TAG_RIGHT_TO_LEFT:
        {
            stationListCtrller.identifier=@"2";
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:stationListCtrller animated:YES];
}

- (void)fetchStationInfoAsync{
    if (![StationDao checkIsInited]) {
        FetchStationInfoOperation *fenchLineInfoOperation=[[[FetchStationInfoOperation alloc] init] autorelease];
        [((AppDelegate*)appDelegateObj).operationQueueCenter addOperation:fenchLineInfoOperation];
    }
}


@end
