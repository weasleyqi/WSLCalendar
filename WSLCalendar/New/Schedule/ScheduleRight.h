//
//  ScheduleRight.h
//  E-Mobile
//
//  Created by donnie on 13-12-16.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScheduleView.h"
//#import "MainView.h"

@interface ScheduleRight : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *theTable;
    
    BOOL isSyncToMobile;
    
    BOOL isSyncToPC;
    
}

//@property(nonatomic,strong) id<FunctionViewDelegate> functionDelegate;
@property(nonatomic,strong) id<ScheduleViewDelegate> scheduleDelegate;

@end
