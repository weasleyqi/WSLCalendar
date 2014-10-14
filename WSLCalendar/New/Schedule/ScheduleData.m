//
//  ScheduleData.m
//  E-Mobile
//
//  Created by donnie on 13-9-12.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import "ScheduleData.h"

@implementation ScheduleData

@synthesize ID = ID_;
@synthesize MID = MID_;
@synthesize EID = EID_;
@synthesize title = title_;
@synthesize startdate = startdate_;
@synthesize enddate = enddate_;
@synthesize touser = touser_;
@synthesize scheduletype = scheduletype_;
@synthesize urgentlevel = urgentlevel_;
@synthesize alarmway = alarmway_;
@synthesize alarmstart = alarmstart_;
@synthesize alarmend = alarmend_;
@synthesize notes = notes_;
@synthesize canedit = canedit_;
@synthesize canfinish = canfinish_;
@synthesize isdeleted = isdeleted_;

-(id) init {
    if (self = [super init]) {
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        
        self.ID = [decoder decodeObjectForKey:PKScheduleDataID];
        self.MID = [decoder decodeObjectForKey:PKScheduleDataMID];
        self.EID = [decoder decodeObjectForKey:PKScheduleDataEID];
        self.title = [decoder decodeObjectForKey:PKScheduleDataTitle];
        self.startdate = [decoder decodeObjectForKey:PKScheduleDataStartDate];
        self.enddate = [decoder decodeObjectForKey:PKScheduleDataEndDate];
        self.touser = [decoder decodeObjectForKey:PKScheduleDataToUser];
        self.scheduletype = [decoder decodeObjectForKey:PKScheduleDataType];
        self.urgentlevel = [decoder decodeObjectForKey:PKScheduleDataUrgentLevel];
        self.alarmway = [decoder decodeObjectForKey:PKScheduleDataAlarmWay];
        self.alarmstart = [decoder decodeObjectForKey:PKScheduleDataAlarmStart];
        self.alarmend = [decoder decodeObjectForKey:PKScheduleDataAlarmEnd];
        self.notes = [decoder decodeObjectForKey:PKScheduleDataNotes];
        self.canedit = [decoder decodeObjectForKey:PKScheduleDataCanEdit];
        self.canfinish = [decoder decodeObjectForKey:PKScheduleDataCanFinish];
        self.isdeleted = [[decoder decodeObjectForKey:PKScheduleDataIsDeleted] intValue];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.ID forKey:PKScheduleDataID];
    [coder encodeObject:self.MID forKey:PKScheduleDataMID];
    [coder encodeObject:self.EID forKey:PKScheduleDataEID];
    [coder encodeObject:self.title forKey:PKScheduleDataTitle];
    [coder encodeObject:self.startdate forKey:PKScheduleDataStartDate];
    [coder encodeObject:self.enddate forKey:PKScheduleDataEndDate];
    [coder encodeObject:self.touser forKey:PKScheduleDataToUser];
    [coder encodeObject:self.scheduletype forKey:PKScheduleDataType];
    [coder encodeObject:self.urgentlevel forKey:PKScheduleDataUrgentLevel];
    [coder encodeObject:self.alarmway forKey:PKScheduleDataAlarmWay];
    [coder encodeObject:self.alarmstart forKey:PKScheduleDataAlarmStart];
    [coder encodeObject:self.alarmend forKey:PKScheduleDataAlarmEnd];
    [coder encodeObject:self.notes forKey:PKScheduleDataNotes];
    [coder encodeObject:self.canedit forKey:PKScheduleDataCanEdit];
    [coder encodeObject:self.canfinish forKey:PKScheduleDataCanFinish];
    [coder encodeObject:@(self.isdeleted) forKey:PKScheduleDataIsDeleted];
}

@end
