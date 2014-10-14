//
//  MobileUtils.h
//  E-Mobile
//
//  Created by donnie on 13-10-25.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileUtils : NSObject

//播放短声效
+ (void) playSound:(NSString *) filename withType:(NSString *) filetype;

//取得灰度图像
+ (UIImage*)getGrayImage:(UIImage*)sourceImage;

//由颜色生成图片
+ (UIImage *) imageFromColor:(UIColor *)color withRect:(CGRect) rect;


//取得日期从字符串
+ (NSDate *) getDateFromString:(NSString *)str formatter:(NSString *)formatter;




//取得某日期所在周的第一天//周日为第一天
+ (NSDate *) getFirstDateOfWeek:(NSDate *)date;
//取得某日期所在周的最后一天//周六为最后一天
+ (NSDate *) getLastDateOfWeek:(NSDate *)date;

//取得某日期所在月的第一天
+ (NSDate *) getFirstDateOfMonth:(NSDate *)date;
//取得某日期所在月的最后一天
+ (NSDate *) getLastDateOfMonth:(NSDate *)date;
//取得运算后的某日期
+ (NSDate *) getOperationDate:(NSDate *)date component:(NSCalendarUnit)unit value:(int)value;

//取得某日期所在月共有几周//周日为第一天
+ (int) getNumWeekOfMonth:(NSDate *)date;
//取得某日期所在月共有几天
+ (int) getNumDayOfMonth:(NSDate *)date;

//取得某日期的年、月、日等
+ (int) getDateComponent:(NSCalendarUnit)unit date:(NSDate *)date;

//取得日期格式化字符串
+ (NSString *) getFormatterDate:(NSString *)formatter date:(NSDate *)date;

//取得日期格式化字符串
+ (NSString *) getFormatterWeekDay:(NSDate *)date;

//比较2个日期是否同一天
+(BOOL) isSameDay:(NSDate *)dateA date:(NSDate *)dateB;




@end
