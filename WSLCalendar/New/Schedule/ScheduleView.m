//
//  ScheduleView.m
//  E-Mobile
//
//  Created by donnie on 13-11-11.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <EventKit/EventKit.h>

//#import "AppDelegate.h"
#import "MobileUtils.h"
//#import "MobileData.h"

#import "ScheduleView.h"
//#import "ScheduleRight.h"
#import "ScheduleNewView.h"
#import "ScheduleData.h"

//#import "MMDrawerController.h"
//#import "MainView.h"
//#import "DetailView.h"

#define CALENDAR_LIST_ROW_HEIGHT 40.000
#define CALENDAR_LIST_SECTION_HEIGHT 25.000

@interface ScheduleView ()

@end

@implementation ScheduleView

//@synthesize mainDelegate;
@synthesize selectedDate;
@synthesize previousDate;
@synthesize currSender;
@synthesize moduleInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        selectedDate = [NSDate date];
        datas = [[NSMutableArray alloc] init];
//        moduleInfo = [[NSMutableDictionary alloc] init];
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

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
//    [self loadData];
    
    [self showView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

#pragma mark init


//-(void) initData:(NSDictionary *)params {
//    
//    moduleInfo = [params mutableCopy];
//    
//}


-(void) initView {
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bg.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [self.view addSubview:bg];
    
    calendarMode = EMScheduleCalendarModeMonth;
    
    
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleView.backgroundColor = UIColorFromRGB(0x0076FF, 1.0);
    [self.view addSubview:titleView];
    
    
    
    
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, 28)];
    dateView.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
    [self.view addSubview:dateView];
    
    
    
    weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 72, WIDTH, 18)];
    weekView.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
    [self.view addSubview:weekView];
    
    

    CGFloat cHeight = CALENDAR_BOX_HEIGHT;
    if (calendarMode==EMScheduleCalendarModeMonth) {
        cHeight = 6 * CALENDAR_BOX_HEIGHT;
    }
    
    
    
    calendarMirrorView = [[UIView alloc] init];
    calendarMirrorView.frame = CGRectMake(0, 90, WIDTH, cHeight);
    calendarMirrorView.backgroundColor = [UIColor clearColor];
    [calendarMirrorView.layer setMasksToBounds:YES];
    [self.view addSubview:calendarMirrorView];
    
    
    [self initCalendarView:calendarMirrorView];
    
    
    

    calendarView = [[UIView alloc] init];
    calendarView.frame = CGRectMake(0, 90, WIDTH, cHeight);
    calendarView.backgroundColor = [UIColor clearColor];
    [calendarView.layer setMasksToBounds:YES];
    [self.view addSubview:calendarView];

    
    [self initCalendarView:calendarView];
    
    
    
    
    

    calendarMirrorLeft = [[UIImageView alloc] init];
    calendarMirrorLeft.frame = calendarView.frame;
    calendarMirrorLeft.hidden = YES;
    [self.view addSubview:calendarMirrorLeft];
    
    
    calendarMirrorMiddle = [[UIImageView alloc] init];
    calendarMirrorMiddle.frame = calendarView.frame;
    calendarMirrorMiddle.hidden = YES;
    [self.view addSubview:calendarMirrorMiddle];
    
    
    calendarMirrorRight = [[UIImageView alloc] init];
    calendarMirrorRight.frame = calendarView.frame;
    calendarMirrorRight.hidden = YES;
    [self.view addSubview:calendarMirrorRight];
    

    //滑动处理
    UIPanGestureRecognizer *calendarRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureCalendar:)];
    [calendarRecognizer setMinimumNumberOfTouches:1];
    [calendarView addGestureRecognizer:calendarRecognizer];
    
    
    theTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 90+cHeight, WIDTH, HEIGHT-110-cHeight)];
    [theTable setDelegate:self];
    [theTable setDataSource:self];
    [theTable setBackgroundColor:UIColorFromRGB(0xF0F0F0, 1.0)];
    [theTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [theTable setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
    [theTable setSeparatorColor:[UIColor clearColor]];
    [theTable setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
    [theTable setAutoresizesSubviews:YES];
    theTable.backgroundView.alpha = 0;
    
    [self.view addSubview:theTable];
    
}
/* load data from local database */
/*
 loadData method 
 load schedule data from local DB
 when needed , use it
 */
/*
-(void) loadData {
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];
    NSDate *endDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:41];
    
    datas = [[MobileData sharedInstance] getSchedules:nil MID:nil EID:nil user:[MobileData sharedInstance].resultServerCurrentId startDate:startDate endDate:endDate includeDel:NO];

    [self setupCalendarMirror];

    [theTable reloadData];
    
    int section = -1;
    NSDate *currentDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    for (int i=0; i<7; i++) {
        if ([[MobileUtils getFormatterDate:@"yyyy-MM-dd" date:currentDate] isEqualToString:[MobileUtils getFormatterDate:@"yyyy-MM-dd" date:selectedDate]]) {
            section = i;
            break;
        }
        currentDate = [MobileUtils getOperationDate:currentDate component:NSCalendarUnitDay value:1];
    }
    if (section>-1) {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        if (scrollIndexPath)
        [theTable scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
}*/

-(void) showView {
    
//    [mainDelegate hideToolView];
    
    isScheduleNew = NO;
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    /*
     schedule right 
     keep local calendar and WSLCalendar same
     */
    /*
    if (((MMDrawerController *)self.view.window.rootViewController).rightDrawerViewController==nil) {
        ScheduleRight * rightView = [[ScheduleRight alloc] init];
        rightView.view.frame = CGRectMake(0, 0, width/3 * 2, height);
        rightView.functionDelegate = self;
        rightView.scheduleDelegate = self;
        [((MMDrawerController *)self.view.window.rootViewController) setRightDrawerViewController:rightView];
        [(MMDrawerController *)self.view.window.rootViewController setMaximumRightDrawerWidth:width/3 * 2];
    }
    ((ScheduleRight *)((MMDrawerController *)self.view.window.rootViewController).rightDrawerViewController).functionDelegate = self;
    ((ScheduleRight *)((MMDrawerController *)self.view.window.rootViewController).rightDrawerViewController).scheduleDelegate = self;

     */
    [self showTitleView];
    
    [self showDateView];
    
    [self showCalendarView:calendarView date:selectedDate];
    
    [self showCalendarColor];
    
    [self showWeekView];
    
//    [self showRefreshView:theTable];
    
}


-(NSDictionary *) getModuleInfo {
    return moduleInfo;
}

-(void) setupCalendarMirror {
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    NSDate *lastDate = [MobileUtils getLastDateOfMonth:selectedDate];
    
    NSDate *previous = nil;
    NSDate *next = nil;
    
    if (calendarMode==EMScheduleCalendarModeMonth) {
        previous = [MobileUtils getOperationDate:firstDate component:NSCalendarUnitMonth value:-1];
        next = [MobileUtils getOperationDate:lastDate component:NSCalendarUnitDay value:1];
    } else {
        NSDate *wsdate = [MobileUtils getFirstDateOfWeek:selectedDate];
        previous = [MobileUtils getOperationDate:wsdate component:NSCalendarUnitDay value:-7];
        next = [MobileUtils getOperationDate:wsdate component:NSCalendarUnitDay value:7];
    }
    
    [self showCalendarView:calendarMirrorView date:previous];
    UIImage *leftImage = [self getCalendarScreenShot:calendarMirrorView];
    calendarMirrorLeft.image = leftImage;
    
    [self showCalendarView:calendarMirrorView date:next];
    UIImage *rightImage = [self getCalendarScreenShot:calendarMirrorView];
    calendarMirrorRight.image = rightImage;

    [self showCalendarView:calendarView date:selectedDate];

    [self showCalendarColor];
    
    [self showCalendarMark];
    
    UIImage *middleImage = [self getCalendarScreenShot:calendarView];
    calendarMirrorMiddle.image = middleImage;
    
}

- (void) addSchedule {
//    isScheduleNew = NO;
//    if (!isScheduleNew) {
//    
//        ScheduleNewView *snv = [[ScheduleNewView alloc] init];
//        
//        ScheduleData *scheduleData = nil;
//        if (scheduleData==nil) {
//            scheduleData = [[ScheduleData alloc] init];
//            scheduleData.startdate = [MobileUtils getFormatterDate:@"yyyy-MM-dd HH:mm:ss" date:[NSDate date]];
//            scheduleData.enddate = [MobileUtils getFormatterDate:@"yyyy-MM-dd HH:mm:ss" date:[MobileUtils getOperationDate:[NSDate date] component:NSCalendarUnitDay value:1]];
//            scheduleData.scheduletype = @"";
//            scheduleData.urgentlevel = @"";
//            scheduleData.alarmway = @"";
//            scheduleData.alarmstart = @"";
//            scheduleData.alarmend = @"";
//            scheduleData.canfinish = @"0";
//            scheduleData.canedit = @"1";
//        }
//        snv.scheduleData = scheduleData;
//        snv.moduleInfoDictionary = self.moduleInfo;
//        snv.functionDelegate = self;
//        
////        [(MMDrawerController *)self.view.window.rootViewController closeDrawerAnimated:YES completion:nil];
//        
//        isScheduleNew = YES;
////        ScheduleNewView *newSchedule = [[ScheduleNewView alloc] init];
////        [self.navigationController presentModalViewController:newSchedule animated:YES];
//        
//        
//        
//        [self addNewSchedule];
////        [mainDelegate gotoNewScheduleView:scheduleData :self.moduleInfo];
////        [mainDelegate showView:EMShowContentCustom withCustom:snv withGesture:EMGestureTypeTitle withShowType:EMShowTypePopup withParams:nil withComplete:nil];
//    
//    }
}

//-(void)addNewSchedule{
//    ScheduleNewView *newScheduleView;
//    if (newScheduleView==nil) {
//        
//        newScheduleView = [[ScheduleNewView alloc] init];
//        
//        [self addChildViewController:newScheduleView];
////        [containerView addSubview:newScheduleView.view];
////        [newScheduleView.view setFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
////        newScheduleView.scheduleData = data;
////        newScheduleView.moduleInfoDictionary =dict;
//        [newScheduleView beginAppearanceTransition:YES animated:NO];
//        newScheduleView.mainDelegate = self;
////        newScheduleView.functionDelegate = scheduleView;
//        [newScheduleView endAppearanceTransition];
//        [newScheduleView didMoveToParentViewController:self];
//        
//        [newScheduleView.view sizeToFit];
//    } else {
//        newScheduleView.mainDelegate = self;
////        newScheduleView.functionDelegate = scheduleView;
////        newScheduleView.scheduleData = data;
////        newScheduleView.moduleInfoDictionary =dict;
//        [newScheduleView showView];
//    }
//    
//    [UIView
//     animateWithDuration:0.3
//     delay:0.0
//     options:UIViewAnimationOptionCurveEaseInOut
//     animations:^{
//         [newScheduleView.view setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//     }
//     completion:^(BOOL finished) {
//         
//     }];
//}

- (NSMutableArray *) getSchedulesByDate:(NSDate *) date {
    
    if (date==nil) return [[NSMutableArray alloc] init];
    
    NSDate *sDate = date;

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSUIntegerMax fromDate: date];
    if ([components hour]==0) {
        [components setHour: 23];
    }
    if ([components minute]==0) {
        [components setMinute: 59];
    }
    if ([components second]==0) {
        [components setSecond: 59];
    }
    NSDate *eDate = [gregorian dateFromComponents: components];
    
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    for (ScheduleData *sd in datas) {
        BOOL flag = NO;
        
        NSDate *startDate = [dateFormatter dateFromString:sd.startdate];
        NSDate *endDate = [dateFormatter dateFromString:sd.enddate];
        
        if (startDate!=nil && endDate!=nil && sDate!=nil && eDate!=nil){
            if ([sDate compare:startDate]==NSOrderedDescending && [eDate compare:endDate]==NSOrderedAscending) {
                flag = YES;
            }
            if ([sDate compare:startDate]==NSOrderedDescending && [sDate compare:endDate]==NSOrderedAscending) {
                flag = YES;
            }
            if ([eDate compare:startDate]==NSOrderedDescending && [eDate compare:endDate]==NSOrderedAscending) {
                flag = YES;
            }
            if ([startDate compare:sDate]==NSOrderedDescending && [startDate compare:eDate]==NSOrderedAscending) {
                flag = YES;
            }
            if ([endDate compare:sDate]==NSOrderedDescending && [endDate compare:eDate]==NSOrderedAscending) {
                flag = YES;
            }
        }
        
        if (flag) {
            [result addObject:sd];
        }
    }

    return result;
}


#pragma mark Title View

- (void) showTitleView {
    
    CGFloat width = self.view.frame.size.width;

    UILabel *titleLable = (UILabel *)[titleView viewWithTag:11];
    if (titleLable==nil) {
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, width-60-60, 30)];
        titleLable.tag = 11;
        titleLable.backgroundColor=[UIColor clearColor];
        titleLable.textAlignment=UITextAlignmentCenter;
        titleLable.text=@"日程";
        titleLable.textColor=[UIColor whiteColor];
        titleLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
        [titleView addSubview:titleLable];
    }
    
    UIButton *backBtn = (UIButton *)[titleView viewWithTag:12];
    if (backBtn==nil) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, 0, 54, 44);
        backBtn.tag = 12;
        [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];

        UIImageView *backLine = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 2, 44)];
        backLine.image=[UIImage imageNamed:@"top_line.png"];
        [backBtn addSubview:backLine];

        UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
        backIcon.image=[UIImage imageNamed:@"top_icon_back.png"];
        [backBtn addSubview:backIcon];
        
        [titleView addSubview:backBtn];
        
        [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:13];
    if (rightBtn==nil) {
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame=CGRectMake(width-54, 0, 54, 44);
        rightBtn.tag = 13;
        [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
        
        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
        rightIcon.image=[UIImage imageNamed:@"top_icon_menu.png"];
        [rightBtn addSubview:rightIcon];
        
        UIImageView *rightLine=[[UIImageView alloc] initWithFrame:CGRectMake(width-54-2, 0, 2, 44)];
        rightLine.image=[UIImage imageNamed:@"top_line.png"];
        [titleView addSubview:rightLine];
        
        [titleView addSubview:rightBtn];
        
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark Calendar View

- (void) showDateView {
    
    CGFloat width = self.view.frame.size.width;

    NSString *month = [MobileUtils getFormatterDate:@"yyyy.M" date:selectedDate];
    UILabel *monthLabel = (UILabel *)[dateView viewWithTag:1000];
    if (monthLabel==nil) {
        monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 100, 28)];
        monthLabel.tag = 1000;
        monthLabel.backgroundColor = [UIColor clearColor];
        monthLabel.textAlignment = NSTextAlignmentLeft;
        monthLabel.textColor = UIColorFromRGB(0x0076FF,1.0);
        monthLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:16];
        monthLabel.shadowColor = UIColorFromRGB(0x000000, 0.03);
        monthLabel.shadowOffset = CGSizeMake(1,1);
        
        [dateView addSubview:monthLabel];
    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [monthLabel.layer addAnimation:animation forKey:@"changeTextTransition"];
    monthLabel.text = month;
    
//    UIButton *addBtn = (UIButton *)[dateView viewWithTag:100];
//    if (addBtn==nil) {
//        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        addBtn.frame=CGRectMake(width-16-16, 0, 32, 32);
//        addBtn.tag = 100;
//        [addBtn setContentMode:UIViewContentModeCenter];
//        [addBtn setImage:[UIImage imageNamed:@"icon_add.png"] forState:UIControlStateNormal];
//        [addBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
//        [dateView addSubview:addBtn];
//        
//        [addBtn addTarget:self action:@selector(addBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
}

- (void) showWeekView {
    
    NSArray *weekNames = [[NSArray alloc] initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thur",@"Fri",@"Sat", nil];
    
    for (int i=0; i<[weekNames count]; i++) {
        
        NSString *weekName = [weekNames objectAtIndex:i];
        
        UILabel *label = (UILabel *)[weekView viewWithTag:i+1];
        if (label==nil) {
        
            label = [[UILabel alloc] initWithFrame:CGRectMake(3+CALENDAR_BOX_WIDTH*i, 0, CALENDAR_BOX_WIDTH, 18)];
            label.tag = i+1;
            label.text = weekName;
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColorFromRGB(0x6B6C6C,1.0);
            label.font=[UIFont fontWithName:@"MicrosoftYaHei" size:10];
            label.shadowColor = UIColorFromRGB(0x000000, 0.01);
            label.shadowOffset = CGSizeMake(1,1);
            
            [weekView addSubview:label];
        }
    }
}

- (void) initCalendarView:(UIView *)cv {
    
    CGFloat width = self.view.frame.size.width;
    
    for (UIView *view in cv.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 3;
    CGFloat y = 0;
    int index = 0;
    
    for (int i=0; i<6; i++) {
        
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, CALENDAR_BOX_HEIGHT)];
        wView.tag = 100+i+1;
        
        wView.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
        
        [cv addSubview:wView];
        
        for (int j=0; j<7; j++) {
            
            UIView *dView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, CALENDAR_BOX_WIDTH, CALENDAR_BOX_HEIGHT)];
            dView.tag = 10000+index;
            [wView addSubview:dView];
            
            
            UIImageView *dBg = [[UIImageView alloc] initWithFrame:CGRectMake((CALENDAR_BOX_WIDTH-CALENDAR_BOX_HEIGHT)/2-2, 2, CALENDAR_BOX_HEIGHT, CALENDAR_BOX_HEIGHT)];
            dBg.layer.cornerRadius = CALENDAR_BOX_HEIGHT/2;
            dBg.layer.masksToBounds = YES;
            dBg.tag = 1000;
            
            [dView addSubview:dBg];
            
            
            UIImageView *dFlag = [[UIImageView alloc] initWithFrame:CGRectMake((CALENDAR_BOX_WIDTH-4)/2+1, CALENDAR_BOX_HEIGHT-8, 4, 4)];
            dFlag.layer.cornerRadius = 4/2;
            dFlag.layer.masksToBounds = YES;
            dFlag.tag = 1001;
            
            [dView addSubview:dFlag];
            
            
            UILabel * dLabel = [[UILabel alloc] initWithFrame:dView.bounds];
            dLabel.backgroundColor = [UIColor clearColor];
            dLabel.textAlignment = NSTextAlignmentCenter;
            dLabel.font=[UIFont fontWithName:@"HelveticaNeue-Light" size:16];//Helvetica-Light//HelveticaNeue-Light
            dLabel.shadowColor = UIColorFromRGB(0x000000, 0.01);
            dLabel.shadowOffset = CGSizeMake(1,1);
            dLabel.tag = 1002;
            
            [dView addSubview:dLabel];
            
            
            UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            dBtn.tag = 1003;
            dBtn.frame = dView.bounds;
            [dBtn addTarget:self action:@selector(calendarDayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [dView addSubview:dBtn];
            
            index ++;
            x += CALENDAR_BOX_WIDTH;
            
        }
        
        x = 3;
        y += CALENDAR_BOX_HEIGHT;
        
    }
}

- (void) showCalendarView:(UIView *)cv date:(NSDate *)date {
    
    CGFloat width = self.view.frame.size.width;
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:date];
    NSDate *lastDate = [MobileUtils getLastDateOfMonth:date];
    
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];
    
    int selectedWeek = 0;
    for (int i=0; i<6; i++) {
        NSDate *sDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:i*7];
        NSDate *eDate = [MobileUtils getOperationDate:sDate component:NSCalendarUnitDay value:6];
        if (([date compare:sDate]==NSOrderedDescending&&[date compare:eDate]==NSOrderedAscending)
            ||[date compare:sDate]==NSOrderedSame||[date compare:eDate]==NSOrderedSame){
            selectedWeek = i;
            break;
        }
    }
    
    CGFloat x = 3;
    CGFloat y = 0;
    
    if (calendarMode==EMScheduleCalendarModeWeek) {
        y = 0 - CALENDAR_BOX_HEIGHT * selectedWeek;
    }
    
    NSDate *currentDate = startDate;
    int index = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0; i<6; i++) {
        
        UIView *wView = [cv viewWithTag:100+i+1];
        if (wView) {
            wView.frame = CGRectMake(0, y, width, CALENDAR_BOX_HEIGHT);
            wView.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
            
            for (int j=0; j<7; j++) {
                
                NSString *day = [MobileUtils getFormatterDate:@"d" date:currentDate];
//                NSString *key = [MobileUtils getFormatterDate:@"yyyy-MM-dd" date:currentDate];
                
                UIView *dView = [wView viewWithTag:10000+index];
                if (dView) {
                    
                    dView.frame = CGRectMake(x, 0, CALENDAR_BOX_WIDTH, CALENDAR_BOX_HEIGHT);
                    [wView addSubview:dView];
                    
                    UIColor *fontColor = UIColorFromRGB(0x6B6C6C,1.0);
                    if ([currentDate compare:firstDate]==NSOrderedAscending||[currentDate compare:lastDate]==NSOrderedDescending) {
                        fontColor = UIColorFromRGB(0xD0D0D0,1.0);
                    }
//                    if (showColor) {
//                        if ([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:date]]) {
//                            fontColor = UIColorFromRGB(0xFFFFFF,1.0);
//                        } else if ([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
//                            fontColor = UIColorFromRGB(0x6B6C6C,1.0);
//                        }
//                    }
                    
                    UIImageView *dBg = (UIImageView *)[dView viewWithTag:1000];
                    if (dBg) {
                        dBg.frame = CGRectMake((CALENDAR_BOX_WIDTH-CALENDAR_BOX_HEIGHT)/2+1, 0, CALENDAR_BOX_HEIGHT, CALENDAR_BOX_HEIGHT);
                    
//                        if (showColor) {
//                            if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:date]]) {
//                                dBg.backgroundColor = UIColorFromRGB(0x017AFD, 1.0);
//                            } else if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
//                                dBg.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
//                                dBg.layer.borderWidth = 1.5;
//                                dBg.layer.borderColor = UIColorFromRGB(0x017AFD, 1.0).CGColor;
//                            } else {
//                                dBg.backgroundColor = [UIColor clearColor];
//                                dBg.layer.borderWidth = 0;
//                                dBg.layer.borderColor = [UIColor clearColor].CGColor;
//                            }
//                        } else {
                            dBg.backgroundColor = [UIColor clearColor];
                            dBg.layer.borderWidth = 0;
                            dBg.layer.borderColor = [UIColor clearColor].CGColor;
//                        }
                    }
                    
                    UIImageView *dFlag = (UIImageView *)[dView viewWithTag:1001];
                    if (dFlag) {
                        dFlag.frame = CGRectMake((CALENDAR_BOX_WIDTH-4)/2+1, CALENDAR_BOX_HEIGHT-8, 4, 4);
                        
//                        if (showColor) {
//                            if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:date]]) {
//                                dFlag.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
//                            } else {
//                                dFlag.backgroundColor = UIColorFromRGB(0x017AFD, 1.0);
//                            }
//                        } else {
//                            dFlag.backgroundColor = [UIColor clearColor];
//                        }
//                        NSMutableArray *ds = [self getSchedulesByDate:currentDate];
//                        if ([ds count]>0) {
//                            dFlag.hidden = NO;
//                        } else {
//                            dFlag.hidden = YES;
//                        }
                    }

                    UILabel * dLabel = (UILabel *)[dView viewWithTag:1002];
                    if (dLabel) {
                        dLabel.frame = dView.bounds;
                        dLabel.text = day;
                        dLabel.textColor = fontColor;
                    }
                    
                    UIButton *dBtn = (UIButton *)[dView viewWithTag:1003];
                    if (dBtn) {
                        dBtn.frame = dView.bounds;
                    }

                    index++;
                    currentDate = [MobileUtils getOperationDate:currentDate component:NSCalendarUnitDay value:1];
                    x += CALENDAR_BOX_WIDTH;
                }
            }
            
            x = 3;
            y += CALENDAR_BOX_HEIGHT;
            
        }
    }
}




- (void) showCalendarMark {
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];

    NSDate *currentDate = startDate;
    
    int index = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0; i<6; i++) {
        
        UIView *wView = [calendarView viewWithTag:100+i+1];

        for (int j=0; j<7; j++) {
        
            UIView *dView = [wView viewWithTag:10000+index];
            
            NSMutableArray *ds = [self getSchedulesByDate:currentDate];
            
            UIImageView *dFlag = (UIImageView *)[dView viewWithTag:1001];
            if (dFlag) {

                UIColor *color = UIColorFromRGB(0xFFFFFF, 1.0);
                if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:selectedDate]]) {
                    color = UIColorFromRGB(0xFFFFFF, 1.0);
                } else {
                    color = UIColorFromRGB(0x017AFD, 1.0);
                }
                
                if ([ds count]>0) {
                    dFlag.backgroundColor = color;
                    dFlag.hidden = NO;
                } else {
                    dFlag.backgroundColor = [UIColor clearColor];
                    dFlag.hidden = YES;
                }
            }
            
            currentDate = [MobileUtils getOperationDate:currentDate component:NSCalendarUnitDay value:1];
            index ++;
        }
    }
}


- (void) showCalendarColor {
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    NSDate *lastDate = [MobileUtils getLastDateOfMonth:selectedDate];
    
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];
    
    NSDate *currentDate = startDate;
    
    int index = 0;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    for (int i=0; i<6; i++) {
        
        UIView *wView = [calendarView viewWithTag:100+i+1];
        
        for (int j=0; j<7; j++) {
            
            UIView *dView = [wView viewWithTag:10000+index];
            
            UIImageView *dBg = (UIImageView *)[dView viewWithTag:1000];
            if (dBg) {
                if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:selectedDate]]) {
                    dBg.backgroundColor = UIColorFromRGB(0x017AFD, 1.0);
                } else if([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
                    dBg.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
                    dBg.layer.borderWidth = 1.5;
                    dBg.layer.borderColor = UIColorFromRGB(0x017AFD, 1.0).CGColor;
                } else {
                    dBg.backgroundColor = [UIColor clearColor];
                    dBg.layer.borderWidth = 0;
                    dBg.layer.borderColor = [UIColor clearColor].CGColor;
                }
            }
            
            UIColor *fontColor = UIColorFromRGB(0x6B6C6C,1.0);
            if ([currentDate compare:firstDate]==NSOrderedAscending||[currentDate compare:lastDate]==NSOrderedDescending) {
                fontColor = UIColorFromRGB(0xD0D0D0,1.0);
            }
            if ([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:selectedDate]]) {
                fontColor = UIColorFromRGB(0xFFFFFF,1.0);
            } else if ([[dateFormatter stringFromDate:currentDate] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
                fontColor = UIColorFromRGB(0x6B6C6C,1.0);
            }
            
            UILabel * dLabel = (UILabel *)[dView viewWithTag:1002];
            if (dLabel) {
                dLabel.textColor = fontColor;
            }
            
            currentDate = [MobileUtils getOperationDate:currentDate component:NSCalendarUnitDay value:1];
            index ++;
        }
    }
}



-(UIImage *) getCalendarScreenShot:(UIView *)cv {
    UIGraphicsBeginImageContext(cv.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [cv.layer renderInContext:context];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}




#pragma mark Event for Title View


-(void) backBtnPressed:(id) sender {

//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [mainDelegate hideView:NO withComplete:nil];
//    [mainDelegate showToolView];
//    [mainDelegate removeScheduleView];
    
}


-(void) rightBtnPressed:(id) sender {
    
//    [(MMDrawerController *)self.view.window.rootViewController toggleDrawerSide:MMDrawerSideRight animated:YES completion:^(BOOL finished){
//        [MobileUtils playSound:@"pop" withType:@"aif"];
//    }];
    
}



#pragma mark Event for Date View

-(void) addBtnPressed:(id) sender {
    
    [self addSchedule];
    
}




#pragma mark Event for Calendar View


- (void) handleGestureCalendar:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint velocity = [recognizer velocityInView:self.view];

    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;

    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    NSDate *lastDate = [MobileUtils getLastDateOfMonth:selectedDate];
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];

    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {

        if (isLeftRightDraging) {

            CGRect left = calendarMirrorLeft.frame;
            CGRect middle = calendarMirrorMiddle.frame;
            CGRect right = calendarMirrorRight.frame;

            CGPoint offset = [recognizer translationInView:self.view];
            
            CGFloat lx = left.origin.x + offset.x;
            CGFloat mx = middle.origin.x + offset.x;
            CGFloat rx = right.origin.x + offset.x;
            
            left.origin.x = lx;
            middle.origin.x = mx;
            right.origin.x = rx;
            
            calendarMirrorLeft.frame = left;
            calendarMirrorMiddle.frame = middle;
            calendarMirrorRight.frame = right;
                
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
        } else if(isUpDownDraging){
            
            CGRect outer = calendarView.frame;
            CGRect table = theTable.frame;
            
            CGPoint offset = [recognizer translationInView:self.view];
            
            CGFloat oh = outer.size.height + offset.y;
            CGFloat ty = table.origin.y + offset.y;
            CGFloat th = table.size.height - offset.y;
            
            if (oh<CALENDAR_BOX_HEIGHT) {
                oh=CALENDAR_BOX_HEIGHT;
            }
            if (oh>6*CALENDAR_BOX_HEIGHT) {
                oh=6*CALENDAR_BOX_HEIGHT;
            }
            
            if (ty<outer.origin.y+CALENDAR_BOX_HEIGHT) {
                ty=outer.origin.y+CALENDAR_BOX_HEIGHT;
            }
            if (ty>outer.origin.y+6*CALENDAR_BOX_HEIGHT) {
                ty=outer.origin.y+6*CALENDAR_BOX_HEIGHT;
            }
            
            if (ty+th<height) {
                th=table.size.height;
            }
            
            outer.size.height = oh;
            table.origin.y = ty;
            table.size.height = th;
            
            calendarView.frame = outer;
            calendarMirrorView.frame = outer;
            
            theTable.frame = table;

            int selectedWeek = 0;
            for (int i=0; i<6; i++) {
                NSDate *sDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:i*7];
                NSDate *eDate = [MobileUtils getOperationDate:sDate component:NSCalendarUnitDay value:6];
                if (([selectedDate compare:sDate]==NSOrderedDescending&&[selectedDate compare:eDate]==NSOrderedAscending)
                    ||[selectedDate compare:sDate]==NSOrderedSame||[selectedDate compare:eDate]==NSOrderedSame){
                    selectedWeek = i+1;
                    break;
                }
            }
            
            for (int i=1; i<7; i++) {
                
                CGRect week = [calendarView viewWithTag:100+i].frame;

                CGFloat wy = week.origin.y + offset.y;
                
                CGFloat wby = (i-1) * CALENDAR_BOX_HEIGHT;
                CGFloat wty = wby - (selectedWeek-1) * CALENDAR_BOX_HEIGHT;
                
                if (wy<wty) wy = wty;
                if (wy>wby) wy = wby;
                
                week.origin.y = wy;
                
                [calendarView viewWithTag:100+i].frame = week;
                [calendarMirrorView viewWithTag:100+i].frame = week;
            }
            
            [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            
        } else {
            
            if (fabs(velocity.x) > fabs(velocity.y)) {
                
                isLeftRightDraging = YES;
                isUpDownDraging = NO;
                
                CGRect left = calendarView.frame;
                left.origin.x = -left.size.width;
                
                CGRect middle = calendarView.frame;
                
                CGRect right = calendarView.frame;
                right.origin.x = right.size.width;
                
                calendarMirrorLeft.frame = left;
                calendarMirrorLeft.hidden = NO;
                [self.view bringSubviewToFront:calendarMirrorLeft];
                
                calendarMirrorRight.frame = right;
                calendarMirrorRight.hidden = NO;
                [self.view bringSubviewToFront:calendarMirrorRight];
                
                calendarMirrorMiddle.frame = middle;
                calendarMirrorMiddle.hidden = NO;
                [self.view bringSubviewToFront:calendarMirrorMiddle];
                
            } else {
                isLeftRightDraging = NO;
                isUpDownDraging = YES;
                
            }
        }
    }
    if ([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
        
        if (isLeftRightDraging) {
            
            NSDate *previous = nil;
            NSDate *next = nil;
            
            if (calendarMode==EMScheduleCalendarModeMonth) {
                previous = [MobileUtils getOperationDate:firstDate component:NSCalendarUnitMonth value:-1];
                next = [MobileUtils getOperationDate:lastDate component:NSCalendarUnitDay value:1];
            } else {
                NSDate *wsdate = [MobileUtils getFirstDateOfWeek:selectedDate];
                previous = [MobileUtils getOperationDate:wsdate component:NSCalendarUnitDay value:-7];
                next = [MobileUtils getOperationDate:wsdate component:NSCalendarUnitDay value:7];
            }
            
            CGRect left = calendarView.frame;
            left.origin.x = -left.size.width;
            
            CGRect middle = calendarView.frame;
            
            CGRect right = calendarView.frame;
            right.origin.x = right.size.width;
            
            CGFloat mx = calendarMirrorMiddle.frame.origin.x;

            __block int flag = 0;

            if (mx>=-width/4 && mx<=width/4) {
                flag = 0;
            } else if (mx>width/4) {
                flag = -1;
            } else if (mx<-width/4) {
                flag = 1;
            }
            
            if (flag == -1) {
                previousDate = selectedDate;
                selectedDate = previous;
            } else if(flag == 1) {
                previousDate = selectedDate;
                selectedDate = next;
            }
            
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 if (flag==-1) {
                     calendarMirrorLeft.frame = middle;
                     calendarMirrorRight.frame = right;
                     calendarMirrorMiddle.frame = right;
                 } else if(flag==1) {
                     calendarMirrorRight.frame = middle;
                     calendarMirrorLeft.frame = left;
                     calendarMirrorMiddle.frame = left;
                 } else {
                     calendarMirrorMiddle.frame = middle;
                     calendarMirrorLeft.frame = left;
                     calendarMirrorRight.frame = right;
                 }
             }
             completion:^(BOOL finished) {
                 calendarMirrorLeft.hidden = YES;
                 calendarMirrorMiddle.hidden = YES;
                 calendarMirrorRight.hidden = YES;
                 
                 if (flag!=0) {
                     [self showDateView];
                     
                     [self showCalendarView:calendarView date:selectedDate];
                     
                     [self showCalendarColor];
                     
//                     [self loadData];
                 }
             }];

            isLeftRightDraging = NO;
                
        } else {
            
            CGRect outer = calendarView.frame;
            CGRect table = theTable.frame;
            
            CGFloat cth = 6*CALENDAR_BOX_HEIGHT;
            CGFloat ch = outer.size.height;
            
            int flag = 0;
            if (velocity.y<0 && ch<=cth/3) {
                flag = 0;
            } else if(velocity.y>0 && ch>=cth/3) {
                flag = 1;
            }
            
            CGFloat oh = CALENDAR_BOX_HEIGHT;
            CGFloat sy = outer.origin.y+CALENDAR_BOX_HEIGHT;
            CGFloat ty = outer.origin.y+CALENDAR_BOX_HEIGHT;
            CGFloat th = height-110-CALENDAR_BOX_HEIGHT;
            
            if (flag==1) {
                oh=6*CALENDAR_BOX_HEIGHT;
                sy=outer.origin.y+6*CALENDAR_BOX_HEIGHT;
                ty = outer.origin.y+6*CALENDAR_BOX_HEIGHT;
                th = height-110-6*CALENDAR_BOX_HEIGHT;
            }
            
            outer.size.height = oh;
            table.origin.y = ty;
            table.size.height = th;
            
            
            
            NSMutableArray *vs = [[NSMutableArray alloc] init];
            NSMutableArray *vf = [[NSMutableArray alloc] init];
            
            int selectedWeek = 0;
            for (int i=0; i<6; i++) {
                NSDate *sDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:i*7];
                NSDate *eDate = [MobileUtils getOperationDate:sDate component:NSCalendarUnitDay value:6];
                if (([selectedDate compare:sDate]==NSOrderedDescending&&[selectedDate compare:eDate]==NSOrderedAscending)
                    ||[selectedDate compare:sDate]==NSOrderedSame||[selectedDate compare:eDate]==NSOrderedSame){
                    selectedWeek = i+1;
                    break;
                }
            }
            
            for (int i=1; i<7; i++) {
                CGRect week = [calendarView viewWithTag:100+i].frame;
                
                CGFloat wby = (i-1) * CALENDAR_BOX_HEIGHT;
                CGFloat wty = wby - (selectedWeek-1) * CALENDAR_BOX_HEIGHT;
                
                CGFloat wy = wty;
                if (flag==1) {
                    wy = wby;
                }
                
                week.origin.y = wy;
                
                [vs addObject:[calendarView viewWithTag:100+i]];
                [vf addObject:[NSValue valueWithCGRect:week]];
                [vs addObject:[calendarMirrorView viewWithTag:100+i]];
                [vf addObject:[NSValue valueWithCGRect:week]];
            }

            
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 calendarView.frame = outer;
                 calendarMirrorView.frame = outer;
                 theTable.frame = table;
                 
                 for (int i=0;i<[vs count];i++) {
                     UIView *v = [vs objectAtIndex:i];
                     CGRect f  = [((NSValue *)[vf objectAtIndex:i]) CGRectValue];
                     if (v) {
                         v.frame = f;
                     }
                 }
             }
             completion:^(BOOL finished) {
                 [self showCalendarView:calendarView date:selectedDate];
                 [self showCalendarColor];
                 [self showDateView];
                 [self setupCalendarMirror];
                 
                 if (flag==1) {
//                     [self loadData];
                 }

             }];
            
            if (flag==1) {
                calendarMode = EMScheduleCalendarModeMonth;
            } else {
                calendarMode = EMScheduleCalendarModeWeek;
            }

            isUpDownDraging = NO;
        }
    }
}


-(void) switchCalendar:(NSDate *) date {
    
    CGRect left = calendarView.frame;
    left.origin.x = -left.size.width;
    
    CGRect middle = calendarView.frame;
    
    CGRect right = calendarView.frame;
    right.origin.x = right.size.width;
    
    calendarMirrorLeft.frame = left;
    calendarMirrorLeft.hidden = NO;
    [self.view bringSubviewToFront:calendarMirrorLeft];
    
    calendarMirrorRight.frame = right;
    calendarMirrorRight.hidden = NO;
    [self.view bringSubviewToFront:calendarMirrorRight];
    
    calendarMirrorMiddle.frame = middle;
    calendarMirrorMiddle.hidden = NO;
    [self.view bringSubviewToFront:calendarMirrorMiddle];
    

    __block int flag = 0;
    
    if ([[MobileUtils getFormatterDate:@"yyyyMM" date:date] isEqualToString:[MobileUtils getFormatterDate:@"yyyyMM" date:selectedDate]]) {
        flag = 0;
    } else if ([[MobileUtils getFormatterDate:@"yyyyMM" date:date] compare:[MobileUtils getFormatterDate:@"yyyyMM" date:selectedDate]]==NSOrderedAscending) {
        flag = -1;
    } else {
        flag = 1;
    }
    
    if (calendarMode==EMScheduleCalendarModeWeek) {
        flag = 0;
    }
    
    if (flag!=0) {

        [UIView
         animateWithDuration:0.3
         delay:0.0
         options:UIViewAnimationOptionCurveEaseInOut
         animations:^{
             if (flag==-1) {
                 calendarMirrorLeft.frame = middle;
                 calendarMirrorRight.frame = right;
                 calendarMirrorMiddle.frame = right;
             } else if(flag==1) {
                 calendarMirrorRight.frame = middle;
                 calendarMirrorLeft.frame = left;
                 calendarMirrorMiddle.frame = left;
             } else {
                 calendarMirrorMiddle.frame = middle;
                 calendarMirrorLeft.frame = left;
                 calendarMirrorRight.frame = right;
             }
         }
         completion:^(BOOL finished) {
             calendarMirrorLeft.hidden = YES;
             calendarMirrorMiddle.hidden = YES;
             calendarMirrorRight.hidden = YES;
             
             previousDate = selectedDate;
             selectedDate = date;
             
             [self showDateView];
             
             [self showCalendarView:calendarView date:selectedDate];
             
             [self showCalendarColor];
             
//             [self loadData];
             
         }];
    } else {
        calendarMirrorLeft.hidden = YES;
        calendarMirrorMiddle.hidden = YES;
        calendarMirrorRight.hidden = YES;
        
        previousDate = selectedDate;
        selectedDate = date;
        
        [self showDateView];
        
        [self showCalendarColor];
        
//        [self loadData];
        
    }
    
}

-(void) calendarDayBtnPressed:(id) sender {
    currSender = sender;
    UIButton *btn = (UIButton *)sender;
    UIView *view = [btn superview];
    
    if (view) {
    
        int index = view.tag-10000;
        
        NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
        NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];
        
        NSDate *toDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:index];
        
        [self switchCalendar:toDate];
        
    }
}




#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;//[weekdatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    NSDate *sectionDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:section];

    NSMutableArray *ds = [self getSchedulesByDate:sectionDate];
    if (ds &&[ds count]>0) {
        return [ds count];
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CALENDAR_LIST_SECTION_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    NSDate *sectionDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:indexPath.section];

    NSMutableArray *ds = [self getSchedulesByDate:sectionDate];
    ScheduleData *sd = nil;
    if ([ds count]>0) {
        sd = [ds objectAtIndex:indexPath.row];
    }
    
    if (sd && [sd.alarmway length]>0 && [sd.alarmway intValue]!=1) {
        return CALENDAR_LIST_ROW_HEIGHT * 3.0;
    }
    
    return CALENDAR_LIST_ROW_HEIGHT;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    NSDate *sectionDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:section];
    NSString *key = [MobileUtils getFormatterDate:@"yyyy-MM-dd" date:sectionDate];
    
    NSDate *kd = nil;
    if ([key length]>0) {
        kd = [MobileUtils getDateFromString:key formatter:@"yyyy-MM-dd"];
    }
    NSString *show = @"";
    if (kd) {
        show = [MobileUtils getFormatterDate:@"MM月dd日" date:kd];
    }
    
    UIColor *color = UIColorFromRGB(0x666565,1.0);
    if ([MobileUtils isSameDay:kd date:[NSDate date]]) {
        show = [NSString stringWithFormat:@"今天 %@", [MobileUtils getFormatterWeekDay:kd]];
        color = UIColorFromRGB(0x017AFD,1.0);
    } else {
        if ([MobileUtils isSameDay:kd date:selectedDate]) {
            color = UIColorFromRGB(0x017AFD,1.0);
        }
        show = [NSString stringWithFormat:@"%@ %@",show,[MobileUtils getFormatterWeekDay:kd]];
    }

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CALENDAR_LIST_SECTION_HEIGHT)];
    view.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 2, 180, 23)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = color;
    label.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
    label.shadowColor = UIColorFromRGB(0x000000, 0.01);
    label.shadowOffset = CGSizeMake(1,1);
    label.text = show;
    
    [view addSubview:label];
    
    return view;
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"Cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.tag = 10001;
        line.backgroundColor = UIColorFromRGB(0xE1E0E0, 1.0);
        
        [cell.contentView addSubview:line];
        
        
        
        UIView *sign = [[UIView alloc] initWithFrame:CGRectZero];
        sign.tag = 10002;
        sign.backgroundColor = UIColorFromRGB(0xFFCD5C, 1.0);
        sign.layer.masksToBounds = YES;
        sign.layer.cornerRadius = 6;
        
        [cell.contentView addSubview:sign];
        
        
        UIView *box = [[UIView alloc] initWithFrame:CGRectZero];
        box.tag = 10003;
        box.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
        box.layer.borderColor = UIColorFromRGB(0xE3E3E3, 1.0).CGColor;
        box.layer.borderWidth = 1;
        
        [cell.contentView addSubview:box];
        
        
        UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectZero];
        triangle.tag = 10004;
        triangle.contentMode = UIViewContentModeScaleToFill;
        triangle.image = [UIImage imageNamed:@"icon_graywhite_left_triangle.png"];
        
        [cell.contentView addSubview:triangle];
        
        
        
        
        UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectZero];
        label0.tag = 10005;
        label0.backgroundColor = [UIColor clearColor];
        label0.textAlignment = NSTextAlignmentCenter;
        label0.textColor = UIColorFromRGB(0x6D6D6D,1.0);
        label0.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
        label0.shadowColor = UIColorFromRGB(0x000000, 0.01);
        label0.shadowOffset = CGSizeMake(1,1);
        
        [cell.contentView addSubview:label0];
        
        
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        label1.tag = 10006;
        label1.backgroundColor = [UIColor clearColor];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = UIColorFromRGB(0x222222,1.0);
        label1.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
        label1.shadowColor = UIColorFromRGB(0x000000, 0.01);
        label1.shadowOffset = CGSizeMake(1,1);
        
        [cell.contentView addSubview:label1];
        
        
        
        UIImageView *icon2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        icon2.tag = 10007;
        icon2.image = [UIImage imageNamed:@"icon_clock.png"];
        
        [cell.contentView addSubview:icon2];
        
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectZero];
        label2.tag = 10008;
        label2.backgroundColor = [UIColor clearColor];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.textColor = UIColorFromRGB(0x8B8989,1.0);
        label2.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
        label2.shadowColor = UIColorFromRGB(0x000000, 0.01);
        label2.shadowOffset = CGSizeMake(1,1);
        
        [cell.contentView addSubview:label2];
        
        
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectZero];
        label3.tag = 10009;
        label3.backgroundColor = [UIColor clearColor];
        label3.textAlignment = NSTextAlignmentLeft;
        label3.textColor = UIColorFromRGB(0x8B8989,1.0);
        label3.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
        label3.shadowColor = UIColorFromRGB(0x000000, 0.01);
        label3.shadowOffset = CGSizeMake(1,1);
        
        [cell.contentView addSubview:label3];
        
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    UIView *line = [cell viewWithTag:10001];
    UIView *sign = [cell viewWithTag:10002];
    UIView *box = [cell viewWithTag:10003];
    UIImageView *triangle = (UIImageView *)[cell viewWithTag:10004];
    UILabel *label0 = (UILabel *)[cell viewWithTag:10005];
    UILabel *label1 = (UILabel *)[cell viewWithTag:10006];
    UIImageView *icon2 = (UIImageView *)[cell viewWithTag:10007];
    UILabel *label2 = (UILabel *)[cell viewWithTag:10008];
    UILabel *label3 = (UILabel *)[cell viewWithTag:10009];
    
    
    CGFloat width = tableView.bounds.size.width;
    CGFloat height = CALENDAR_LIST_ROW_HEIGHT;

    NSDate *startDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    NSDate *sectionDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:indexPath.section];
    
    NSMutableArray *ds = [self getSchedulesByDate:sectionDate];

    ScheduleData *sd = nil;
    if (ds && [ds count]>0) {
        sd = [ds objectAtIndex:indexPath.row];
    }
    
    if (sd && [sd.alarmway length]>0 && [sd.alarmway intValue]!=1) {
        height = CALENDAR_LIST_ROW_HEIGHT * 3;
    }
    
    cell.frame = CGRectMake(0, 0, width, height);
    line.frame = CGRectMake(20, 0, 1, height);
    sign.frame = CGRectMake(20-12/2, CALENDAR_LIST_ROW_HEIGHT/2-12/2, 12, 12);
    box.frame = CGRectMake(38, 5, width-38-15, height-10);
    triangle.frame = CGRectMake(28+1, CALENDAR_LIST_ROW_HEIGHT/2-10/2, 10, 10);
    label0.frame = CGRectMake(45, 8, 40, CALENDAR_LIST_ROW_HEIGHT-16);
    label1.frame = CGRectMake(45+50, 8, width-45-50-20, CALENDAR_LIST_ROW_HEIGHT-16);
    icon2.frame = CGRectMake(45+50/2-17/2, CALENDAR_LIST_ROW_HEIGHT+CALENDAR_LIST_ROW_HEIGHT/2-17/2, 17, 17);
    label2.frame = CGRectMake(45+50, CALENDAR_LIST_ROW_HEIGHT+8, width-45-50-20, CALENDAR_LIST_ROW_HEIGHT-16);
    label3.frame = CGRectMake(45+50, CALENDAR_LIST_ROW_HEIGHT*2+8, width-45-50-20, CALENDAR_LIST_ROW_HEIGHT-16);
    
    if (sd==nil) {
        label1.frame = CGRectMake(45, 8, width-45-50-20, CALENDAR_LIST_ROW_HEIGHT-16);
        sign.backgroundColor = UIColorFromRGB(0xEEEEEE, 1.0);
        
//        NSString *stime = [MobileUtils getFormatterDate:@"HH:mm" date:[NSDate date]];
        NSString *stime = @"";
        label0.text = stime;
        
        NSString *title = @"当天无日程安排";
        label1.text = title;
        
        NSString *alarm = @"";
        label2.text = alarm;
        
        NSString *location = @"";
        label3.text = location;
        
        icon2.hidden = YES;
        label2.hidden = YES;
        label3.hidden = YES;
        
    } else {
        
        if ([sd.urgentlevel isEqualToString:@"3"]) {
            sign.backgroundColor = UIColorFromRGB(0xCB82FF, 1.0);
        } else if ([sd.urgentlevel isEqualToString:@"2"]) {
            sign.backgroundColor = UIColorFromRGB(0xFFCD5C, 1.0);
        } else {
            sign.backgroundColor = UIColorFromRGB(0xBFBEBF, 1.0);
        }
        
        NSDate *startTime = [MobileUtils getDateFromString:sd.startdate formatter:@"yyyy-MM-dd HH:mm:ss"];
        NSString *stime = [MobileUtils getFormatterDate:@"HH:mm" date:startTime];
        label0.text = stime;
        
        NSString *title = sd.title;
        label1.text = title;
        
        if ([sd.alarmway length]>0 && [sd.alarmway intValue]!=1) {
            NSString *alarmway = @"";
            for (int i=0;i<[SCHEDULE_ALARMWAY_VALUE count];i++) {
                if ([SCHEDULE_ALARMWAY_VALUE[i] isEqualToString:sd.alarmway]) {
                    alarmway = [SCHEDULE_ALARMWAY_NAME objectAtIndex:i];
                    break;
                }
            }
            label2.text = alarmway;
            
            
            NSString *alarm = @"";
            int alarmstart = [sd.alarmstart intValue];
            int alarmend = [sd.alarmend intValue];
            
            if (alarmstart>0) {
                alarm = @"开始前:";
                int d = alarmstart>60*24?alarmstart / (60 * 24):0;
                if (d>0) {
                    alarm = [NSString stringWithFormat:@"%@%d天",alarm,d];
                }
                int h = alarmstart>60?alarmstart / 60:0;
                if (h>0) {
                    alarm = [NSString stringWithFormat:@"%@%d小时",alarm,h];
                }
                int m = alarmstart>60?alarmstart-(alarmstart/60)*60:alarmstart;
                if (m>0) {
                    alarm = [NSString stringWithFormat:@"%@%d分钟",alarm,m];
                }
            }
            if (alarmend>0) {
                alarm = [NSString stringWithFormat:@"%@ | 结束前:",alarm];
                int d = alarmend>60*24?alarmend / (60 * 24):0;
                if (d>0) {
                    alarm = [NSString stringWithFormat:@"%@%d天",alarm,d];
                }
                int h = alarmend>60?alarmend / 60:0;
                if (h>0) {
                    alarm = [NSString stringWithFormat:@"%@%d小时",alarm,h];
                }
                int m = alarmend>60?alarmend-(alarmend/60)*60:alarmend;
                if (m>0) {
                    alarm = [NSString stringWithFormat:@"%@%d分钟",alarm,m];
                }
            }
            
            label3.text = alarm;
            
            icon2.hidden = NO;
            label2.hidden = NO;
            label3.hidden = NO;
        } else {
            icon2.hidden = YES;
            label2.hidden = YES;
            label3.hidden = YES;
        }
    }
    return cell;
}




#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *startDate = [MobileUtils getFirstDateOfWeek:selectedDate];
    NSDate *sectionDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:indexPath.section];
    
    NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
    NSDate *startDate1 = [MobileUtils getFirstDateOfWeek:firstDate];
    NSDate *endDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:41];
    
//    datas = [[MobileData sharedInstance] getSchedules:nil MID:nil EID:nil user:[MobileData sharedInstance].resultServerCurrentId startDate:startDate1 endDate:endDate includeDel:NO];
    
    NSMutableArray *ds = [self getSchedulesByDate:sectionDate];

    ScheduleData *scheduleData = nil;
    if ([ds count]>0) {
        scheduleData = [ds objectAtIndex:indexPath.row];
    }
    if (scheduleData) {
        ScheduleNewView *snv = [[ScheduleNewView alloc] init];
        snv.scheduleData = scheduleData;
        
//        snv.functionDelegate = self;
//        [mainDelegate gotoNewScheduleView:scheduleData :self.moduleInfo];
//        [mainDelegate showView:EMShowContentCustom withCustom:snv withGesture:EMGestureTypeNone withShowType:EMShowTypePopup withParams:nil withComplete:nil];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - push to refresh

//-(void) showRefreshView:(UITableView *)tableView {
//    CGFloat width = tableView.frame.size.width;
//    
//    if (refreshView==nil) {
//        refreshView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, width, REFRESH_HEADER_HEIGHT)];
//        refreshView.backgroundColor = [UIColor clearColor];
//        
//        UILabel *refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, REFRESH_HEADER_HEIGHT)];
//        refreshLabel.tag = 10001;
//        refreshLabel.backgroundColor = [UIColor clearColor];
//        refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
//        refreshLabel.textAlignment = UITextAlignmentCenter;
//        
//        UIImageView *refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
//        refreshArrow.tag = 10002;
//        refreshArrow.frame = CGRectMake(floorf((REFRESH_HEADER_HEIGHT - 27) / 2),
//                                        (floorf(REFRESH_HEADER_HEIGHT - 44) / 2),
//                                        27, 44);
//        
//        UIActivityIndicatorView *refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        refreshSpinner.tag = 10003;
//        refreshSpinner.frame = CGRectMake(floorf(floorf(REFRESH_HEADER_HEIGHT - 20) / 2), floorf((REFRESH_HEADER_HEIGHT - 20) / 2), 20, 20);
//        refreshSpinner.hidesWhenStopped = YES;
//        
//        [refreshView addSubview:refreshLabel];
//        [refreshView addSubview:refreshArrow];
//        [refreshView addSubview:refreshSpinner];
//        [tableView addSubview:refreshView];
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    UILabel *refreshLabel = (UILabel *)[refreshView viewWithTag:10001];
//    UIImageView *refreshArrow = (UIImageView *)[refreshView viewWithTag:10002];
//    
//    if (isLoading) {
//        // Update the content inset, good for section headers
//        if (scrollView.contentOffset.y > 0)
//            theTable.contentInset = UIEdgeInsetsZero;
//        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
//            theTable.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (isDragging && scrollView.contentOffset.y < 0) {
//        // Update the arrow direction and label
//        [UIView beginAnimations:nil context:NULL];
//        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
//            // User is scrolling above the header
//            refreshLabel.text = REFRESH_HEADER_TEXTRELEASE;
//            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
//        } else { // User is scrolling somewhere within the header
//            refreshLabel.text = REFRESH_HEADER_TEXTPULL;
//            [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
//        }
//        [UIView commitAnimations];
//    }
//    
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (isLoading) return;
//    isDragging = NO;
//    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
//        // Released above the header
//        [self startLoading];
//    }
//    
////    [self switchCalendarByDragging];
//    
//}

//- (void)startLoading {
//    UILabel *refreshLabel = (UILabel *)[refreshView viewWithTag:10001];
//    UIImageView *refreshArrow = (UIImageView *)[refreshView viewWithTag:10002];
//    UIActivityIndicatorView *refreshSpinner = (UIActivityIndicatorView *)[refreshView viewWithTag:10003];
//    
//    isLoading = YES;
//    
//    // Show the header
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    theTable.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
//    refreshLabel.text = REFRESH_HEADER_TEXTLOADING;
//    refreshArrow.hidden = YES;
//    [refreshSpinner startAnimating];
//    [UIView commitAnimations];
//    
//    // Refresh action!
//    [self refresh];
//}

- (void)stopLoading {
    UIImageView *refreshArrow = (UIImageView *)[refreshView viewWithTag:10002];
    
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    theTable.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = theTable.contentInset;
    tableContentInset.top = 0.0;
    theTable.contentInset = tableContentInset;
    [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    [UIView commitAnimations];
}

//- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
//    // Reset the header
//    UILabel *refreshLabel = (UILabel *)[refreshView viewWithTag:10001];
//    UIImageView *refreshArrow = (UIImageView *)[refreshView viewWithTag:10002];
//    UIActivityIndicatorView *refreshSpinner = (UIActivityIndicatorView *)[refreshView viewWithTag:10003];
//    
//    refreshLabel.text = REFRESH_HEADER_TEXTPULL;
//    refreshArrow.hidden = NO;
//    [refreshSpinner stopAnimating];
//}

//- (void)refresh {
//    // This is just a demo. Override this method with your custom reload action.
//    // Don't forget to call stopLoading at the end.
//    
////    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSDate *firstDate = [MobileUtils getFirstDateOfMonth:selectedDate];
//        NSDate *lastDate = [MobileUtils getLastDateOfMonth:selectedDate];
//        NSDate *startDate = [MobileUtils getFirstDateOfWeek:firstDate];
//        NSDate *endDate = [MobileUtils getOperationDate:startDate component:NSCalendarUnitDay value:41];
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
//        NSString *firstDateString = [dateFormatter stringFromDate:firstDate];
//        NSString *lastDateString = [dateFormatter stringFromDate:lastDate];
//        
//        //先删除这一个月的数据
//        [[MobileData sharedInstance] deleteScheduleDataWithStart:firstDateString end:lastDateString];
//        
//        //再获取最新数据
//        [[MobileData sharedInstance] loadScheduleData:[MobileUtils getFormatterDate:@"yyyy-MM-dd" date:startDate] end:[MobileUtils getFormatterDate:@"yyyy-MM-dd" date:endDate] complete:^{
//
//            NSLog(@"load schedule data ... end");
//            
//            [self loadData];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self stopLoading];
//            });
//        }];
//    
//    });
//    
//    
//}








@end
