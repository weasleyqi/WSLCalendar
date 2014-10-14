//
//  MobileUtils.m
//  E-Mobile
//
//  Created by donnie on 13-10-25.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//
#import <AudioToolbox/AudioServices.h>

#import <QuartzCore/QuartzCore.h>

#import "MobileUtils.h"

@implementation MobileUtils


#pragma mark Sound Utils



+ (void) playSound:(NSString *) filename withType:(NSString *) filetype {
    SystemSoundID soundID;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:filename ofType:filetype];
    NSURL *audioPath = [NSURL fileURLWithPath:filePath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioPath, &soundID);
    AudioServicesPlaySystemSound (soundID);
}


#pragma mark Image Utils


+(UIImage*)getGrayImage:(UIImage*)sourceImage {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(sourceImage.CGImage), CGImageGetHeight(sourceImage.CGImage));
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, CGImageGetWidth(sourceImage.CGImage), CGImageGetHeight(sourceImage.CGImage), 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, sourceImage.CGImage);
    // Create bitmap image info from pixel data in current context
    CGImageRef grayImage = CGBitmapContextCreateImage(context);
    // release the colorspace and graphics context
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    // make a new alpha-only graphics context
    context = CGBitmapContextCreate(nil, CGImageGetWidth(sourceImage.CGImage), CGImageGetHeight(sourceImage.CGImage), 8, 0, nil, (CGBitmapInfo)kCGImageAlphaOnly);
    // draw image into context with no colorspace
    CGContextDrawImage(context, imageRect, sourceImage.CGImage);
    // create alpha bitmap mask from current context
    CGImageRef mask = CGBitmapContextCreateImage(context);
    // release graphics context
    CGContextRelease(context);
    // make UIImage from grayscale image with alpha mask
    CGImageRef cgImage = CGImageCreateWithMask(grayImage, mask);
    UIImage *grayScaleImage = [UIImage imageWithCGImage:cgImage];
    // release the CG images
    CGImageRelease(cgImage);
    CGImageRelease(grayImage);
    CGImageRelease(mask);
    // return the new grayscale image
    return grayScaleImage;
}

+ (UIImage *) imageFromColor:(UIColor *)color withRect:(CGRect) rect {
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}













#pragma mark Date Utils

//取得某日期所在周的第一天//周日为第一天
+ (NSDate *) getFirstDateOfWeek:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSDate *firstDateOfWeek = nil;
    NSTimeInterval duration = 0;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&firstDateOfWeek interval:&duration forDate:date];
    
    return firstDateOfWeek;
}

//取得某日期所在周的最后一天//周六为最后一天
+ (NSDate *) getLastDateOfWeek:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSDate *firstDateOfWeek = nil;
    NSTimeInterval duration = 0;
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&firstDateOfWeek interval:&duration forDate:date];
    
    NSDate *endDateOfWeek = [firstDateOfWeek dateByAddingTimeInterval:duration-1];
    
    return endDateOfWeek;
}


//取得某日期所在月的第一天
+ (NSDate *) getFirstDateOfMonth:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSDateComponents* comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    [comps setMonth:[comps month]];
    [comps setDay:1];
    NSDate *firstDateOfMonth = [cal dateFromComponents:comps];
    
    return firstDateOfMonth;
}

//取得某日期所在月的最后一天
+ (NSDate *) getLastDateOfMonth:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSDateComponents* comps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:date];
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    NSDate *lastDateOfMonth = [cal dateFromComponents:comps];
    
    return lastDateOfMonth;
}
//取得运算后的某日期
+ (NSDate *) getOperationDate:(NSDate *)date component:(NSCalendarUnit)unit value:(int)value {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSDate *result = nil;
    switch (unit) {
        case NSCalendarUnitYear: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setYear:[comps year]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitQuarter: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setQuarter:[comps quarter]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitMonth: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setMonth:[comps month]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitDay: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setDay:[comps day]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitHour: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setHour:[comps hour]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitMinute: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setMinute:[comps minute]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitSecond: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setSecond:[comps second]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        case NSCalendarUnitWeekday: {
            NSDateComponents *comps = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
            [comps setWeekday:[comps weekday]+value];
            
            result = [cal dateFromComponents:comps];
            
            break;
        }
        default: {
            
            result = nil;
            
            break;
        }
    }
    
    return result;
}

//取得某日期所在月共有几周//周日为第一天
+ (int) getNumWeekOfMonth:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSUInteger num = [cal rangeOfUnit:NSWeekCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    
    return num;
}

//取得某日期所在月共有几天
+ (int) getNumDayOfMonth:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    
    NSUInteger num = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date].length;
    
    return num;
}


//取得某日期的年、月、日、星期等
+ (int) getDateComponent:(NSCalendarUnit)unit date:(NSDate *)date {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [cal setFirstWeekday:1];
    NSDateComponents *dateComponents = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekOfMonthCalendarUnit | NSWeekOfYearCalendarUnit fromDate:date];
    switch (unit) {
        case NSCalendarUnitYear:
            return dateComponents.year;
            break;
        case NSCalendarUnitQuarter:
            return dateComponents.quarter;
            break;
        case NSCalendarUnitMonth:
            return dateComponents.month;
            break;
        case NSCalendarUnitDay:
            return dateComponents.day;
            break;
        case NSCalendarUnitHour:
            return dateComponents.hour;
            break;
        case NSCalendarUnitMinute:
            return dateComponents.minute;
            break;
        case NSCalendarUnitSecond:
            return dateComponents.second;
            break;
        case NSCalendarUnitWeekday:
            return dateComponents.weekday;
            break;
        default:
            break;
    }
    return 0;
}

//取得日期格式化字符串
+ (NSString *) getFormatterDate:(NSString *)formatter date:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([formatter length]>0) {
        [dateFormatter setDateFormat:formatter];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    return [dateFormatter stringFromDate:date];
}

+ (NSString *) getFormatterWeekDay:(NSDate *)date {
    NSArray *weekdayAry = [NSArray arrayWithObjects:@"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"eee"];
    [formatter setShortWeekdaySymbols:weekdayAry];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    return [formatter stringFromDate:date];
}

+ (NSDate *) getDateFromString:(NSString *)str formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if ([formatter length]>0) {
        [dateFormatter setDateFormat:formatter];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }
    return [dateFormatter dateFromString:str];
}


+(BOOL) isSameDay:(NSDate *)dateA date:(NSDate *)dateB {
    return [self getDateComponent:NSCalendarUnitYear date:dateA]==[self getDateComponent:NSCalendarUnitYear date:dateB]
         &&[self getDateComponent:NSCalendarUnitMonth date:dateA]==[self getDateComponent:NSCalendarUnitMonth date:dateB]
         &&[self getDateComponent:NSCalendarUnitDay date:dateA]==[self getDateComponent:NSCalendarUnitDay date:dateB];
}

@end
