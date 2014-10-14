//
//  ScheduleData.h
//  E-Mobile
//
//  Created by donnie on 13-9-12.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const PKScheduleDataID = @"id";
static NSString * const PKScheduleDataMID = @"mid";
static NSString * const PKScheduleDataEID = @"eid";
static NSString * const PKScheduleDataTitle = @"title";
static NSString * const PKScheduleDataStartDate = @"startdate";
static NSString * const PKScheduleDataEndDate = @"enddate";
static NSString * const PKScheduleDataToUser = @"touser";
static NSString * const PKScheduleDataType = @"scheduletype";
static NSString * const PKScheduleDataUrgentLevel = @"urgentlevel";
static NSString * const PKScheduleDataAlarmWay = @"alarmway";
static NSString * const PKScheduleDataAlarmStart = @"alarmstart";
static NSString * const PKScheduleDataAlarmEnd = @"alarmend";
static NSString * const PKScheduleDataNotes = @"notes";
static NSString * const PKScheduleDataCanEdit = @"canedit";
static NSString * const PKScheduleDataCanFinish = @"canfinish";
static NSString * const PKScheduleDataIsDeleted = @"isdeleted";

@interface ScheduleData : NSObject <NSCoding>

@property (nonatomic) NSString * ID;
@property (nonatomic) NSString * MID;
@property (nonatomic) NSString * EID;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * startdate;
@property (nonatomic) NSString * enddate;
@property (nonatomic) NSString * touser;
@property (nonatomic) NSString * scheduletype;
@property (nonatomic) NSString * urgentlevel;
@property (nonatomic) NSString * alarmway;
@property (nonatomic) NSString * alarmstart;
@property (nonatomic) NSString * alarmend;
@property (nonatomic) NSString * notes;
@property (nonatomic) NSString * canedit;
@property (nonatomic) NSString * canfinish;
@property (nonatomic) int isdeleted;

@end
