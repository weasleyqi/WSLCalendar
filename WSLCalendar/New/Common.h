//
//  Common.h
//  E-Mobile
//
//  Created by Donnie on 13-8-10.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IOS_7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

#define CGRECT(x,y,w,h) CGRectMake((x), (y+(IS_IOS_7?20:0)), (w), (h))
#define WIDTH 320
#define HEIGHT (IS_IPHONE_5?548:460)

#define UIColorFromRGB(rgbValue,alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define WELCOME_LOGO_WIDTH 240
#define WELCOME_LOGO_HEIGHT 200

#define LOGIN_LOGO_WIDTH 192
#define LOGIN_LOGO_HEIGHT 160

#define MAIN_LEFT_WIDTH 240

#define MAIN_RIGHT_WIDTH 200

#define REFRESH_HEADER_HEIGHT 52.0f
//#define REFRESH_HEADER_TEXTPULL @"Pull down to refresh..."
//#define REFRESH_HEADER_TEXTRELEASE @"Release to refresh..."
//#define REFRESH_HEADER_TEXTLOADING @"Loading..."

#define REFRESH_HEADER_TEXTPULL @"向下拖拽刷新列表..."
#define REFRESH_HEADER_TEXTRELEASE @"释放即可更新列表..."
#define REFRESH_HEADER_TEXTLOADING @"正在更新数据..."

#define LOAD_COUNT 3

#define PRELOAD_LIST_COUNT 100

#define SERVER_CONFIG_KEYS [[NSArray alloc] initWithObjects:\
@"com.weaver.mobile.server.id",\
@"com.weaver.mobile.server.name",\
@"com.weaver.mobile.server.protocol",\
@"com.weaver.mobile.server.ip",\
@"com.weaver.mobile.server.port",\
@"com.weaver.mobile.server.context",\
@"com.weaver.mobile.loginid",\
@"com.weaver.mobile.loginpw",\
@"com.weaver.mobile.rememberme",\
@"com.weaver.mobile.autologin",\
@"com.weaver.mobile.server.last",\
@"com.weaver.mobile.server.used",\
nil]

#define CLIENT_CONFIG_KEYS [[NSArray alloc] initWithObjects:\
@"com.weaver.mobile.server.requesttimeout",\
@"com.weaver.mobile.bg",\
@"com.weaver.mobile.check.version.policy",\
nil]

#define CACHE_KEY_SYNCINFO_ARRAY @"SYNCINFO"
#define CACHE_TIMEOUT_SYNCINFO_ARRAY 360000

#define CACHE_KEY_HRMRESOURCE_ARRAY @"HRMRESOURCE"
#define CACHE_TIMEOUT_HRMRESOURCE_ARRAY 360000

#define CACHE_KEY_HRMDEPARTMENT_ARRAY @"HRMDEPARTMENT"
#define CACHE_TIMEOUT_HRMDEPARTMENT_ARRAY 360000

#define CACHE_KEY_HRMSUBCOMPANY_ARRAY @"HRMSUBCOMPANY"
#define CACHE_TIMEOUT_HRMSUBCOMPANY_ARRAY 360000

#define CACHE_KEY_HRMCOMPANY_ARRAY @"HRMCOMPANY"
#define CACHE_TIMEOUT_HRMCOMPANY_ARRAY 360000

#define CACHE_KEY_HRMGROUPMEMBER_ARRAY @"HRMGROUPMEMBER"
#define CACHE_TIMEOUT_HRMGROUPMEMBER_ARRAY 360000

#define CACHE_KEY_HRMGROUP_ARRAY @"HRMGROUP"
#define CACHE_TIMEOUT_HRMGROUP_ARRAY 360000

#define CACHE_KEY_WORKPLANTYPE_ARRAY @"WORKPLANTYPE"
#define CACHE_TIMEOUT_WORKPLANTYPE_ARRAY 360000

#define CACHE_KEY_SCHEDULEDATA_DATE_ARRAY @"SCHEDULEDATA_DATE"
#define CACHE_TIMEOUT_SCHEDULEDATA_ARRAY 360000
#define CACHE_KEY_SCHEDULEDATA_ALL_ARRAY @"SCHEDULEDATA_ALL"

#define CACHE_TIMEOUT_COMMON 600

typedef enum {
    EMNetworkModeOffLine = 0,
    EMNetworkModeOnLine = 1
} EMNetworkMode;

typedef enum {
    EMGestureTypeNone = 0,//关闭手势
    EMGestureTypeAll = 1,//开启手势
    EMGestureTypeTitle = 2
} EMGestureType;

typedef enum {
    EMShowTypeRight = 0,//从左边移到右边
    EMShowTypeLeft = 1,//从右边移到左边
    EMShowTypePopup = 2//弹出
} EMShowType;

typedef enum {
    EMShowContentUnknow=0,
    EMShowContentGridHome=1,
    EMShowContentWorkflowList=2,
    EMShowContentWorkflowNewWeb=3,
    EMShowContentWorkflowWeb=4,
    EMShowContentWorkflowView=5,
    EMShowContentDocumentList=6,
    EMShowContentDocumentWeb=7,
    EMShowContentScheduleWeb=8,
    EMShowContentScheduleView=9,
    EMShowContentMettingWeb=10,
    EMShowContentHrmResourceList=11,
    EMShowContentHrmResourceTree=12,
    EMShowContentHrmResourceView=13,
    EMShowContentBlogWeb=14,
    EMShowContentMessagerList=15,
    EMShowContentMessagerView=16,
    EMShowContentMailWeb=17,
    EMShowContentCoworkWeb=18,
    EMShowContentCommonList=19,
    EMShowContentCommonWeb=20,
    EMShowContentBrowserView=21,
    EMShowContentAttachmentView=22,
    EMShowContentCustom=23
} EMShowContent;

#define EMShowContentArray [NSArray arrayWithObjects:\
[NSNumber numberWithInteger:EMShowContentUnknow],\
[NSNumber numberWithInteger:EMShowContentGridHome],\
[NSNumber numberWithInteger:EMShowContentWorkflowList],\
[NSNumber numberWithInteger:EMShowContentWorkflowNewWeb],\
[NSNumber numberWithInteger:EMShowContentWorkflowWeb],\
[NSNumber numberWithInteger:EMShowContentWorkflowView],\
[NSNumber numberWithInteger:EMShowContentDocumentList],\
[NSNumber numberWithInteger:EMShowContentDocumentWeb],\
[NSNumber numberWithInteger:EMShowContentScheduleWeb],\
[NSNumber numberWithInteger:EMShowContentScheduleView],\
[NSNumber numberWithInteger:EMShowContentMettingWeb],\
[NSNumber numberWithInteger:EMShowContentHrmResourceList],\
[NSNumber numberWithInteger:EMShowContentHrmResourceTree],\
[NSNumber numberWithInteger:EMShowContentHrmResourceView],\
[NSNumber numberWithInteger:EMShowContentBlogWeb],\
[NSNumber numberWithInteger:EMShowContentMessagerList],\
[NSNumber numberWithInteger:EMShowContentMessagerView],\
[NSNumber numberWithInteger:EMShowContentMailWeb],\
[NSNumber numberWithInteger:EMShowContentCoworkWeb],\
[NSNumber numberWithInteger:EMShowContentCommonList],\
[NSNumber numberWithInteger:EMShowContentCommonWeb],\
[NSNumber numberWithInteger:EMShowContentBrowserView],\
[NSNumber numberWithInteger:EMShowContentAttachmentView],\
[NSNumber numberWithInteger:EMShowContentCustom],\
nil]

typedef NS_ENUM(NSInteger, EMListUpdatePolicy){
    EMListUpdateRefresh = 1, //刷新整个列表
    EMListUpdateNextPage = 2,//加载下一页
    EMListUpdateSingle = 3   //刷新单条记录
};

//MicrosoftYaHei
//MElleHKS-Light
//CTZhongYuanSJ