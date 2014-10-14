//
//  ScheduleNewView.h
//  E-Mobile
//
//  Created by donnie on 13-12-18.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "MainView.h"
#import "ScheduleData.h"
//#import "BrowserView.h"
//#import "PCFocusColorTextField.h"

@interface ScheduleNewView : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate> {

    UIView *titleView;
    
    UIScrollView *formView;
    
    UIView *datePickerView;
    UIDatePicker *datePicker;
    void (^datePickerCallBack)(NSDate *);
    
    UIView *timePickerView;
    UIPickerView *timePicker;
    void (^timePickerCallBack)(NSArray *);
    
    UIView *pickerMask;

    UIView *typeSelView;
    void (^typeSelectedCallBack)(void);
    int typeSelectedIndex;
    NSMutableArray *typeValueArray;
    NSMutableArray *typeNameArray;
    
    UIView *urgentlevelSelView;
    void (^urgentlevelSelectedCallBack)(void);
    int urgentlevelSelectedIndex;

    BOOL alarmShow;
    
    UIView *alarmwaySelView;
    void (^alarmwaySelectedCallBack)(void);
    int alarmwaySelectedIndex;
    
    int currAlarmSelectedIndex;
    
    UITextField * activeField;
    UIGestureRecognizer* cancelGesture;
    BOOL keyboardVisible;
    CGPoint oldOffset;
    CGRect oldFrame;
    
//    BrowserView *browserView ;
    NSString *urlString ;
    
    UITextView *formNoteFieldView;
//    PCFocusColorTextField * formNoteField ;
}

@property(nonatomic,strong) ScheduleData *scheduleData;

//@property(nonatomic,strong) id <FunctionViewDelegate> functionDelegate;
//@property(nonatomic,strong) id <MainViewDelegate> mainDelegate;
@property(strong,nonatomic) NSDictionary *moduleInfoDictionary;
@property(strong, nonatomic) NSString *urlString;

-(void) showView;

@end
