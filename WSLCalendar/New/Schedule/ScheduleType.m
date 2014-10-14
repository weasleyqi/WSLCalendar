//
//  ScheduleType.m
//  E-Mobile
//
//  Created by donnie on 13-9-12.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import "ScheduleType.h"

@implementation ScheduleType

@synthesize ID = ID_;
@synthesize name = name_;
@synthesize color = color_;

-(id) init {
    if (self = [super init]) {
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)decoder {
    if (self = [self init]) {
        
        self.ID = [decoder decodeObjectForKey:PKScheduleTypeID];
        self.name = [decoder decodeObjectForKey:PKScheduleTypeName];
        self.color = [decoder decodeObjectForKey:PKScheduleTypeColor];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.ID forKey:PKScheduleTypeID];
    [coder encodeObject:self.name forKey:PKScheduleTypeName];
    [coder encodeObject:self.color forKey:PKScheduleTypeColor];
}

@end
