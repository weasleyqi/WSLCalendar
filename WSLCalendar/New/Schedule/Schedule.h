//
//  Schedule.h
//  E-Mobile
//
//  Created by donnie on 13-12-12.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#define CALENDAR_BOX_WIDTH 45
#define CALENDAR_BOX_HEIGHT 32

typedef enum {
    EMScheduleCalendarModeMonth = 0,
    EMScheduleCalendarModeWeek = 1
} EMScheduleCalendarMode;

#define SCHEDULE_URGENTLEVEL_VALUE [[NSArray alloc] initWithObjects:\
@"1",\
@"2",\
@"3",\
nil]

#define SCHEDULE_URGENTLEVEL_NAME [[NSArray alloc] initWithObjects:\
@"一般",\
@"重要",\
@"紧急",\
nil]

#define SCHEDULE_ALARMWAY_VALUE [[NSArray alloc] initWithObjects:\
@"0",\
@"1",\
@"2",\
@"3",\
nil]

#define SCHEDULE_ALARMWAY_NAME [[NSArray alloc] initWithObjects:\
@"手机",\
@"不提醒",\
@"短信",\
@"邮件",\
nil]


@protocol ScheduleViewDelegate <NSObject>
@optional

-(void) addSchedule;

@end