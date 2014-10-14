//
//  ScheduleType.h
//  E-Mobile
//
//  Created by donnie on 13-9-12.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const PKScheduleTypeID = @"id";
static NSString * const PKScheduleTypeName = @"name";
static NSString * const PKScheduleTypeColor = @"color";

@interface ScheduleType : NSObject <NSCoding>

@property (nonatomic) NSString * ID;
@property (nonatomic) NSString * name;
@property (nonatomic) NSString * color;

@end
