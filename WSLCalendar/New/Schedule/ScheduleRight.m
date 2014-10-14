//
//  ScheduleRight.m
//  E-Mobile
//
//  Created by donnie on 13-12-16.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import "ScheduleRight.h"

//#import "MBProgressHUD.h"
//#import "MobileData.h"
//#import "ALAlertBanner.h"

@interface ScheduleRight ()

@end

@implementation ScheduleRight

//@synthesize functionDelegate;
@synthesize scheduleDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

-(void) initView {
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bg.backgroundColor = UIColorFromRGB(0x2E3641, 1.0);
    [self.view addSubview:bg];
    
    
    theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [theTable setDelegate:self];
    [theTable setDataSource:self];
    [theTable setBackgroundColor:[UIColor clearColor]];
    [theTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [theTable setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [theTable setSeparatorColor:[UIColor clearColor]];
    [theTable setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
    [theTable setAutoresizesSubviews:YES];
    theTable.backgroundView.alpha = 0;
    
    [self.view addSubview:theTable];

}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 30, 30)];
        icon.tag = 10001;
        icon.contentMode = UIViewContentModeScaleToFill;
        
        [cell.contentView addSubview:icon];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, WIDTH-50-10, 30)];
        label.tag = 10002;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = UIColorFromRGB(0xC1CfDA,1.0);
        label.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
        label.shadowColor = UIColorFromRGB(0x000000, 0.01);
        label.shadowOffset = CGSizeMake(1,1);
        
        [cell.contentView addSubview:label];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, WIDTH, 1)];
        line.backgroundColor = UIColorFromRGB(0x343D49, 1.0);
        
        [cell.contentView addSubview:line];
        
        
        UIView *spinnerview = [[UIView alloc] init];
        spinnerview.frame = CGRectMake(180, 15, 24, 24);
        spinnerview.tag=10003;
        spinnerview.hidden = NO;
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [spinner setCenter:CGPointMake(12, 12)];
        spinner.hidesWhenStopped = NO;
        spinner.tag=10004;
        
        [spinnerview addSubview:spinner];
        
        [cell.contentView addSubview:spinnerview];
        
        
        
        UIView *selectedBg = [[UIView alloc] initWithFrame:cell.bounds];
        selectedBg.backgroundColor = UIColorFromRGB(0x474E59, 1.0);
        
        cell.selectedBackgroundView = selectedBg;
        
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIImageView *icon = (UIImageView *)[cell viewWithTag:10001];
    UILabel *label = (UILabel *)[cell viewWithTag:10002];
    UIView *spinnerview = (UIView *)[cell viewWithTag:10003];
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[cell viewWithTag:10004];
    
    if (indexPath.row==0) {
        icon.image = [UIImage imageNamed:@"crate_cal.png"];
        label.text = @"新建日程";
        spinnerview.hidden = YES;
        [spinner stopAnimating];
    }
    if (indexPath.row==1) {
        icon.image = [UIImage imageNamed:@"to_local.png"];
        label.text = @"E-Mobile⇒手机";
        
        if (isSyncToMobile) {
            spinnerview.hidden = NO;
            [spinner startAnimating];
        } else {
            spinnerview.hidden = YES;
            [spinner stopAnimating];
        }
        
    }
    if (indexPath.row==2) {
        icon.image = [UIImage imageNamed:@"upload.png"];
        label.text = @"手机⇒E-Mobile";

        if (isSyncToPC) {
            spinnerview.hidden = NO;
            [spinner startAnimating];
        } else {
            spinnerview.hidden = YES;
            [spinner stopAnimating];
        }
        
    }
    
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
/**/
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *moduleInfo = [functionDelegate getModuleInfo];
//    NSString *module = [moduleInfo objectForKey:@"module"];
//    NSString *scope = [moduleInfo objectForKey:@"scope"];
    
    if (indexPath.row == 0) {
        
        [scheduleDelegate addSchedule];
        
    } else if (indexPath.row == 1) {
        
        if (!isSyncToMobile) {

        isSyncToMobile = YES;
            
        [theTable reloadData];
        
        __block int syncCnt = 0;
//        [MBProgressHUD showHUDAddedTo:[self.view superview] animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MobileData sharedInstance] syncScheduleToMobile:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    isSyncToMobile = NO;
                    
                    [theTable reloadData];
                
//                    [MBProgressHUD hideHUDForView:[self.view superview] animated:YES];
                    if (syncCnt == 0) {
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"日程同步完成!"
                                                                         subtitle:@""];
                        [banner show];
                        syncCnt = syncCnt + 1;
                    }
                    
                });
                
            }];
            
        });
            
        }
        
    } else if (indexPath.row == 2) {
        
        if (!isSyncToMobile) {
        
        isSyncToPC = YES;
            
        [theTable reloadData];
        
        __block int syncCnt = 0;
//        [MBProgressHUD showHUDAddedTo:[self.view superview] animated:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[MobileData sharedInstance] syncScheduleToServer:module scope:scope complete:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    isSyncToPC = NO;
                    
                    [theTable reloadData];
                    
//                    [MBProgressHUD hideHUDForView:[self.view superview] animated:YES];
                    if (syncCnt == 0) {
                        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                                            style:ALAlertBannerStyleSuccess
                                                                         position:ALAlertBannerPositionUnderNavBar
                                                                            title:@"日程同步完成!"
                                                                         subtitle:@""];
                        [banner show];
                        syncCnt = syncCnt + 1;
                    }
                });
                
            }];
            
        });
            
        }
    }
}
*/
@end
