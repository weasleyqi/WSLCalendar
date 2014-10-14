//
//  ScheduleView.h
//  E-Mobile
//
//  Created by donnie on 13-11-11.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "MainView.h"
#import "Schedule.h"


@interface ScheduleView : UIViewController <ScheduleViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    UIView *titleView;
    
    UIView *dateView;
    
    UIView *weekView;
    
    UIView *calendarView;
    UIView *calendarMirrorView;
    
    UIImageView *calendarMirrorLeft;
    UIImageView *calendarMirrorMiddle;
    UIImageView *calendarMirrorRight;
    
    UITableView *theTable;
    
    UIView *refreshView;
    BOOL isDragging;
    BOOL isLoading;
    
    BOOL isLeftRightDraging;
    BOOL isUpDownDraging;
    
    BOOL isScheduleNew;
    
    EMScheduleCalendarMode calendarMode;
    
    NSDictionary *moduleInfo;
    
    NSMutableArray *datas;
    
    id currSender;
    
}


@property(nonatomic,strong) NSDate *selectedDate;
@property(nonatomic,strong) NSDate *previousDate;
@property(nonatomic,strong) NSArray *markedDates;
@property(nonatomic,strong) NSArray *markedColors;
//@property(nonatomic,strong) id <MainViewDelegate> mainDelegate;
@property(strong, nonatomic) id currSender;
@property(strong,nonatomic) NSDictionary *moduleInfo;
-(void) calendarDayBtnPressed:(id) sender;
@end
