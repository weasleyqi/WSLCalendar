//
//  ScheduleNewView.m
//  E-Mobile
//
//  Created by donnie on 13-12-18.
//  Copyright (c) 2013年 Donnie. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ScheduleNewView.h"
#import "ScheduleView.h"
#import "ScheduleType.h"

#import "MobileUtils.h"
//#import "MobileData.h"
//#import "UserData.h"

//#import "PCFocusColorTextField.h"
//#import "MBProgressHUD.h"

//#import "ALAlertBanner.h"

//#import "CXAlertView.h"
//#import "UserData.h"
@interface ScheduleNewView ()

@end

@implementation ScheduleNewView

//@synthesize functionDelegate;
@synthesize scheduleData;
//@synthesize mainDelegate;
@synthesize moduleInfoDictionary;
@synthesize urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification
                                               object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification
                                               object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
//    [self loadData];
    
    [self showView];
    
}



- (void) initView {
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    bg.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    [self.view addSubview:bg];
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleView.backgroundColor = UIColorFromRGB(0x0076FF, 1.0);
    [self.view addSubview:titleView];
    
    
    formView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT-44)];
    [formView setCanCancelContentTouches:NO];
    formView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    formView.clipsToBounds = YES;
    formView.scrollEnabled = YES;
    formView.showsHorizontalScrollIndicator = NO;
    formView.showsVerticalScrollIndicator = NO;
    formView.userInteractionEnabled = YES;
    formView.contentSize = formView.bounds.size;
    [self.view addSubview:formView];
    
    
    pickerMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    pickerMask.backgroundColor = UIColorFromRGB(0x000000, 0.15);
    pickerMask.hidden = YES;
    [self.view addSubview:pickerMask];

    
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
    datePickerView.hidden = YES;
    [self.view addSubview:datePickerView];
    
    
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
    timePickerView.hidden = YES;
    [self.view addSubview:timePickerView];
    
    
    typeSelView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
    typeSelView.hidden = YES;
    [self.view addSubview:typeSelView];
    

    urgentlevelSelView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
    urgentlevelSelView.hidden = YES;
    [self.view addSubview:urgentlevelSelView];


    alarmwaySelView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, HEIGHT)];
    alarmwaySelView.hidden = YES;
    [self.view addSubview:alarmwaySelView];

}

/*
-(void) loadData {
    
    typeValueArray = [[NSMutableArray alloc] init];
    typeNameArray = [[NSMutableArray alloc] init];
    
    NSArray *types = [[MobileData sharedInstance] getScheduleTypeArray:nil withName:nil];
    for (ScheduleType *st in types) {
        if ([st.ID intValue]==0||[st.ID intValue]>=7) {
            [typeValueArray addObject:st.ID];
            [typeNameArray addObject:st.name];
        }
    }
    
    if ([scheduleData.scheduletype length]==0 && [typeValueArray count]>0) {
        scheduleData.scheduletype = [typeValueArray objectAtIndex:0];
    }
    
    if ([scheduleData.urgentlevel length]==0) {
        scheduleData.urgentlevel = [SCHEDULE_URGENTLEVEL_VALUE objectAtIndex:0];
    }
    
    if ([scheduleData.alarmway length]==0) {
        scheduleData.alarmway = [SCHEDULE_ALARMWAY_VALUE objectAtIndex:1];
    }
}
 */

-(void) showView {
    
    [self showTitleView];
    
//    [self showFormView];
    
    [self initDatePicker];
    
    [self initTimePicker];
    
    [self showTypeSelView];
    
    [self showUrgentLevelSelView];

    [self showAlarmWaySelView];
    
    [self setupPermission];
    
}

-(void) setupPermission {
/*
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:13];

    UIButton *formFinishBtn = (UIButton *)[formView viewWithTag:1012];
    
    UIButton *formDelBtn = (UIButton *)[formView viewWithTag:1011];

    UIView *formTitle = [formView viewWithTag:1001];
    PCFocusColorTextField * formTitleField = (PCFocusColorTextField *)[formTitle viewWithTag:100101];

    UIView *formTime = [formView viewWithTag:1002];
    UIButton *leftDateTimeBtn = (UIButton *)[formTime viewWithTag:100205];
    UIButton *rightDateTimeBtn = (UIButton *)[formTime viewWithTag:100206];

    UIView *formUser = [formView viewWithTag:1003];
    UIButton *formUserBtn = (UIButton *)[formUser viewWithTag:100305];

    UIView *formType = [formView viewWithTag:1004];
    UIButton *formTypeBtn = (UIButton *)[formType viewWithTag:100405];

    UIView *formUrgentLevel = [formView viewWithTag:1005];
    UIButton *formUrgentLevelBtn = (UIButton *)[formUrgentLevel viewWithTag:100505];

    UIView *formAlarm = [formView viewWithTag:1006];
    UIButton *formAlarmBtn = (UIButton *)[formAlarm viewWithTag:100605];

    UIView *formAlarmWay = [formView viewWithTag:1007];
    UIButton *formAlarmWayBtn = (UIButton *)[formAlarmWay viewWithTag:100703];
    
    UIView *formAlarmBegin = [formView viewWithTag:1008];
    UIButton *formAlarmBeginBtn = (UIButton *)[formAlarmBegin viewWithTag:100804];
    
    UIView *formAlarmEnd = [formView viewWithTag:1009];
    UIButton *formAlarmEndBtn = (UIButton *)[formAlarmEnd viewWithTag:100904];
    
    UIView *formNote = [formView viewWithTag:1010];
    PCFocusColorTextField * formNoteField = (PCFocusColorTextField *)[formNote viewWithTag:101001];
    
    if ([scheduleData.ID length]>0) {
        formDelBtn.hidden = NO;
        formFinishBtn.hidden = NO;
    } else {
        formDelBtn.hidden = YES;
        formFinishBtn.hidden = YES;
    }
    
    if ([scheduleData.canedit isEqualToString:@"1"]) {
        
        rightBtn.enabled = YES;
        formDelBtn.enabled = YES;
        formTitleField.enabled = YES;
        leftDateTimeBtn.enabled = YES;
        rightDateTimeBtn.enabled = YES;
        formUserBtn.enabled = YES;
        formTypeBtn.enabled = YES;
        formUrgentLevelBtn.enabled = YES;
        formAlarmWayBtn.enabled = YES;
        formAlarmBeginBtn.enabled = YES;
        formAlarmEndBtn.enabled = YES;
        formNoteField.enabled = YES;
        
    } else {
        
        rightBtn.enabled = NO;
        formDelBtn.enabled = NO;
        formTitleField.enabled = NO;
        leftDateTimeBtn.enabled = NO;
        rightDateTimeBtn.enabled = NO;
        formUserBtn.enabled = NO;
        formTypeBtn.enabled = NO;
        formUrgentLevelBtn.enabled = NO;
        formAlarmWayBtn.enabled = NO;
        formAlarmBeginBtn.enabled = NO;
        formAlarmEndBtn.enabled = NO;
        formNoteField.enabled = NO;
        
        rightBtn.hidden = YES;
        formDelBtn.hidden = YES;
    }
    
    if ([scheduleData.canfinish isEqualToString:@"1"]) {
        if (formFinishBtn==nil) {
            formFinishBtn.enabled = YES;
        }
    } else {
        if (formFinishBtn==nil) {
            formFinishBtn.enabled = NO;
        }
    }
    
    */
    
}

#pragma mark for Text Input

- (void)keyboardWillShow:(NSNotification *)n {
    
    NSDictionary* userInfo = [n userInfo];
    
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float keyboardHeight = 0;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
        keyboardHeight = keyboardSize.width;
    else
        keyboardHeight = keyboardSize.height;
    
    if (!keyboardVisible) {
        oldFrame = formView.frame;
        oldOffset = formView.contentOffset;
    }
    
    CGRect viewFrame = oldFrame;
    viewFrame.size.height = viewFrame.size.height - keyboardHeight - 35;
    
    [formView setFrame:viewFrame];
    
    CGRect sframe = [[activeField superview] convertRect:activeField.frame toView:formView];
    
    sframe.origin.y = sframe.origin.y + 15;
    
    [formView scrollRectToVisible:sframe animated:YES];
    
    keyboardVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)n
{
    if (!keyboardVisible) {
        return;
    }
    
    [formView setFrame:oldFrame];
    [formView setContentOffset:oldOffset];
    
    keyboardVisible = NO;
    
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    /*
	activeField = textField;
    UIView *formTitle = [formView viewWithTag:1001];
    PCFocusColorTextField * formTitleField = (PCFocusColorTextField *)[formTitle viewWithTag:100101];
    UIView *formNote = [formView viewWithTag:1010];
    PCFocusColorTextField * formNoteField = (PCFocusColorTextField *)[formNote viewWithTag:101001];
    if ([activeField isEqual:formTitleField]||[activeField isEqual:formNoteField]) {
        if(cancelGesture==nil) {
            cancelGesture = [UITapGestureRecognizer new];
            [cancelGesture addTarget:self action:@selector(cancelGestureTouched:)];
            [self.view addGestureRecognizer:cancelGesture];
            [cancelGesture setCancelsTouchesInView:NO];
        }
    }
     */

    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    /*
	activeField = textField;
    
    UIView *formTitle = [formView viewWithTag:1001];
    PCFocusColorTextField * formTitleField = (PCFocusColorTextField *)[formTitle viewWithTag:100101];
    
//    UIView *formNote = [formView viewWithTag:1010];
//    PCFocusColorTextField * formNoteField = (PCFocusColorTextField *)[formNote viewWithTag:101001];

    if ([textField isEqual:formTitleField]) {
        scheduleData.title = textField.text;

        [formNoteFieldView becomeFirstResponder];
    }
    if ([textField isEqual:formNoteField]) {
        scheduleData.notes = formNoteFieldView.text;
        
        [textField resignFirstResponder];
        [formNoteFieldView resignFirstResponder];
    }
    */
	return YES;
}

-(void) cancelGestureTouched:(id)sender {
    if (cancelGesture) {
        [self.view removeGestureRecognizer:cancelGesture];
        cancelGesture = nil;
    }
    
    if (activeField) {
        [activeField resignFirstResponder];
    }
}

#pragma mark for Title View

- (void) showTitleView {
    
    CGFloat width = self.view.frame.size.width;
    
    UILabel *titleLable = (UILabel *)[titleView viewWithTag:11];
    if (titleLable==nil) {
        titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, width-60-60, 30)];
        titleLable.tag = 11;
        titleLable.backgroundColor=[UIColor clearColor];
        titleLable.textAlignment=UITextAlignmentCenter;
        titleLable.textColor=[UIColor whiteColor];
        titleLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
        [titleView addSubview:titleLable];
    }
    if (scheduleData && [scheduleData.ID length]>0) {
        if ([scheduleData.canedit isEqualToString:@"1"]) {
            titleLable.text=@"修改";
        } else {
            titleLable.text=@"查看";
        }
    } else {
        titleLable.text=@"新建";
    }
    UIButton *backBtn = (UIButton *)[titleView viewWithTag:12];
    if (backBtn==nil) {
        backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame=CGRectMake(0, 0, 54, 44);
        backBtn.tag = 12;
        [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
        
        UIImageView *backLine = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 2, 44)];
        backLine.image=[UIImage imageNamed:@"top_line.png"];
        [backBtn addSubview:backLine];
        
        UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
        backIcon.image=[UIImage imageNamed:@"top_icon_back.png"];
        [backBtn addSubview:backIcon];
        
        [titleView addSubview:backBtn];
        
        [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:13];
    if (rightBtn==nil) {
        
        rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame=CGRectMake(width-54, 0, 54, 44);
        rightBtn.tag = 13;
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
        
        [rightBtn setTitleColor:UIColorFromRGB(0xB2B2B2, 1.0) forState:UIControlStateDisabled];
        [rightBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateNormal];
        [rightBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateHighlighted];
        
        rightBtn.titleLabel.backgroundColor=[UIColor clearColor];
        rightBtn.titleLabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
        rightBtn.titleLabel.textAlignment=UITextAlignmentCenter;
        
        [rightBtn setTitle:@"确定" forState:UIControlStateNormal];

        [titleView addSubview:rightBtn];
        

        UIImageView *rightLine=[[UIImageView alloc] initWithFrame:CGRectMake(width-54-2, 0, 2, 44)];
        rightLine.image=[UIImage imageNamed:@"top_line.png"];
        
        [titleView addSubview:rightLine];
        
        [rightBtn addTarget:self action:@selector(rightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void) backBtnPressed:(id) sender {
//    [self.navigationController dismissModalViewControllerAnimated:YES];
//    [[functionDelegate getMainViewDelegate] hideView:YES withComplete:nil];
//    [mainDelegate removeNewScheduleView];
    
}

-(void) rightBtnPressed:(id) sender {
    /*
    UIView *formTitle = [formView viewWithTag:1001];
    PCFocusColorTextField * formTitleField = (PCFocusColorTextField *)[formTitle viewWithTag:100101];
//    UIView *formNote = [formView viewWithTag:1010];
//    PCFocusColorTextField * formNoteField = (PCFocusColorTextField *)[formNote viewWithTag:101001];
    scheduleData.title = formTitleField.text;
    scheduleData.notes = formNoteFieldView.text;
    
    if ([scheduleData.title length]==0) {
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                            style:ALAlertBannerStyleWarning
                                                         position:ALAlertBannerPositionUnderNavBar
                                                            title:@"请填写标题!"
                                                         subtitle:@""];
        [banner show];
        
        [formTitleField resignFirstResponder];
        
        return;
    }

    scheduleData.title = formTitleField.text;
    scheduleData.notes = formNoteFieldView.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startDate = [dateFormatter dateFromString:scheduleData.startdate];
    NSDate *endDate = [dateFormatter dateFromString:scheduleData.enddate];
    NSDate *compareDate = [startDate earlierDate:endDate];
    if([startDate isEqualToDate:compareDate]){
        
    }else{
        ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                            style:ALAlertBannerStyleWarning
                                                         position:ALAlertBannerPositionUnderNavBar
                                                            title:@"开始日期要小于结束日期！"
                                                         subtitle:@""];
        [banner show];
        
        return;
    }
    NSString *module = [self.moduleInfoDictionary objectForKey:@"module"];
    NSString *scope = [self.moduleInfoDictionary objectForKey:@"scope"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *operation = @"";
    if ([scheduleData.ID length]>0) {
        operation = @"edit";
    } else {
        operation = @"create";
    }
    
    [[MobileData sharedInstance] operateSchedule:module scope:scope schedule:scheduleData operation:operation complete:^(BOOL result) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (result) {
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                                style:ALAlertBannerStyleSuccess
                                                             position:ALAlertBannerPositionUnderNavBar
                                                                title:@"保存成功!"
                                                             subtitle:@""];
            [banner show];
            
            [UIView
             animateWithDuration:0.0
             delay:2.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
             }
             completion:^(BOOL finished) {
                 [functionDelegate loadData];
                 
                 UIButton *backBtn = (UIButton *)[titleView viewWithTag:12];
                 if (backBtn) {
                     [backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                 }
             }];

            
        } else {
            
            ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
                                                                style:ALAlertBannerStyleFailure
                                                             position:ALAlertBannerPositionUnderNavBar
                                                                title:@"保存失败!"
                                                             subtitle:@""];
            [banner show];
        }
        
    }];
*/
}

#pragma mark for DatePicker

-(void) initDatePicker {
    
    UIButton *datePickerCancelBtn = (UIButton *)[datePickerView viewWithTag:100];
    if (datePickerCancelBtn==nil) {
        datePickerCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        datePickerCancelBtn.tag = 100;
        datePickerCancelBtn.frame = CGRectMake(0, 0, WIDTH, HEIGHT-216);
        [datePickerCancelBtn addTarget:self action:@selector(datePickerCancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [datePickerView addSubview:datePickerCancelBtn];
    }
    
    datePicker = (UIDatePicker *)[datePickerView viewWithTag:101];
    if (datePicker==nil) {
        datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, HEIGHT-216, WIDTH, 216)];
        datePicker.tag = 101;
        [datePickerView addSubview:datePicker];
    }
    
}

-(void) datePickerChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate * date = control.date;
    if (datePickerCallBack) {
        datePickerCallBack(date);
    }
}

-(void) showDatePicker:(UIDatePickerMode) mode date:(NSDate *)date complete:(void(^)(NSDate *)) callBack {
    
    NSTimeInterval secondPerDay = 24 * 60 * 60;
    NSTimeInterval secondPer2Year = secondPerDay * 356 * 2;
    
    NSDate *min = [date dateByAddingTimeInterval: -secondPer2Year];
    NSDate *max = [date dateByAddingTimeInterval: secondPer2Year];
    
    [datePicker setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"zh_CN"]];
    [datePicker setDatePickerMode:mode];
    [datePicker setMinimumDate: min];
    [datePicker setMaximumDate: max];
    
    datePickerView.backgroundColor = [UIColor clearColor];
    [datePicker setBackgroundColor:UIColorFromRGB(0xFFFFFF, 1.0)];
    
    [datePicker setDate:date animated: YES];
    
    datePickerView.hidden = NO;
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         datePickerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         
         pickerMask.hidden = NO;
         
     }
     completion:^(BOOL finished) {
         datePickerCallBack = callBack;
         [datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
     }];
}

-(void) hideDatePicker {
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         datePickerView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
         
         pickerMask.hidden = YES;
         
     }
     completion:^(BOOL finished) {
         datePickerView.hidden = YES;
         [datePicker removeTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
         datePickerCallBack = nil;
     }];
}

-(void) datePickerCancelBtnPressed:(id)sender {
    
    [self hideDatePicker];
    
}




#pragma mark for time picker




-(void) initTimePicker {
    
    UIButton *timePickerCancelBtn = (UIButton *)[timePickerView viewWithTag:100];
    if (timePickerCancelBtn==nil) {
        timePickerCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        timePickerCancelBtn.tag = 100;
        timePickerCancelBtn.frame = CGRectMake(0, 0, WIDTH, HEIGHT-216);
        [timePickerCancelBtn addTarget:self action:@selector(timePickerCancelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [timePickerView addSubview:timePickerCancelBtn];
    }
    
    timePicker = (UIPickerView *)[timePickerView viewWithTag:101];
    if (timePicker==nil) {
        timePicker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, HEIGHT-216, WIDTH, 216)];
        timePicker.delegate = self;
        timePicker.tag = 101;
        [timePickerView addSubview:timePicker];
    }
    
}

-(void) showTimePicker:(NSArray *)interval complete:(void(^)(NSArray *)) callBack {
    
    timePickerView.backgroundColor = [UIColor clearColor];
    [timePicker setBackgroundColor:UIColorFromRGB(0xFFFFFF, 1.0)];
    
    timePickerView.hidden = NO;
    
    int d = [[interval objectAtIndex:0] intValue];
    int h = [[interval objectAtIndex:1] intValue];
    int m = [[interval objectAtIndex:2] intValue];

    [timePicker selectRow:d inComponent:0 animated:YES];
    [timePicker selectRow:h inComponent:1 animated:YES];
    [timePicker selectRow:m inComponent:2 animated:YES];
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         timePickerView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         pickerMask.hidden = NO;
     }
     completion:^(BOOL finished) {
         timePickerCallBack = callBack;
     }];
    
}

-(void) hideTimePicker {
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         timePickerView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
         pickerMask.hidden = YES;
     }
     completion:^(BOOL finished) {
         timePickerView.hidden = YES;
         timePickerCallBack = nil;
     }];
    
}

-(void) timePickerCancelBtnPressed:(id)sender {
    
    NSInteger d = [timePicker selectedRowInComponent:0];
    NSInteger h = [timePicker selectedRowInComponent:1];
    NSInteger m = [timePicker selectedRowInComponent:2];
    
    if (timePickerCallBack) {
        timePickerCallBack([[NSArray alloc] initWithObjects:@(d),@(h),@(m), nil]);
    }
    
    [self hideTimePicker];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component==0) {
        return 11;
    } else if (component==1) {
        return 24;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component==0) {
        return [NSString stringWithFormat:@"%d天",row];
    } else if(component==1) {
        return [NSString stringWithFormat:@"%d小时",row];
    } else {
        return [NSString stringWithFormat:@"%d分钟",row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
}

#pragma mark for Form View

//- (void) showFormView {
//    
//    CGFloat width = self.view.frame.size.width;
//    
//    UIColor *fieldBGColor = UIColorFromRGB(0xFFFFFF, 1.0);
//    if ([scheduleData.canedit isEqualToString:@"1"]) {
//        fieldBGColor = UIColorFromRGB(0xFFFFFF, 1.0);
//    }
//    
//    UIView *formTitle = [formView viewWithTag:1001];
//    if (formTitle==nil) {
//        formTitle = [[UIView alloc] init];
//        formTitle.tag = 1001;
//        formTitle.frame = CGRectMake(-1, 16, width+2, 38);
//        formTitle.backgroundColor = fieldBGColor;
//        
//        formTitle.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formTitle.layer.borderWidth = 0.5;
//        
//        UIView * formTitleLeftView = [[UIView alloc] init];
//        formTitleLeftView.frame = CGRectMake(0,0,100,38);
//        
//        UIImageView *formTitleLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 11, 14)];
//        formTitleLeftIcon.image = [UIImage imageNamed:@"icon_form_title.png"];
//        [formTitleLeftView addSubview:formTitleLeftIcon];
//        
//        UILabel *formTitleLeftLable=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 38)];
//        formTitleLeftLable.backgroundColor=[UIColor clearColor];
//        formTitleLeftLable.textAlignment=UITextAlignmentCenter;
//        formTitleLeftLable.text=@"标题";
//        formTitleLeftLable.textColor=UIColorFromRGB(0x222222, 1.0);
//        formTitleLeftLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formTitleLeftView addSubview:formTitleLeftLable];
//        
//        PCFocusColorTextField * formTitleField = [[PCFocusColorTextField alloc] init];
//        formTitleField.frame = CGRectMake(-1, 0, width+2, 38);
//        formTitleField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
//        formTitleField.delegate = self;
//        formTitleField.tag = 100101;
//        formTitleField.leftViewMode = UITextFieldViewModeAlways;
//        formTitleField.leftView = formTitleLeftView;
//        formTitleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        formTitleField.placeholder = @"";
//        formTitleField.focusedBackgroundColor = UIColorFromRGB(0x00BCF3, 0.5);
//        formTitleField.returnKeyType = UIReturnKeyNext;
//        
//        [formTitle addSubview:formTitleField];
//        
//        [formView addSubview:formTitle];
//    }
//    
//    PCFocusColorTextField *formTitleField = (PCFocusColorTextField *)[formTitle viewWithTag:100101];
//    if (formTitleField) {
//        formTitleField.text = scheduleData.title;
//    }
//    
//    UIView *formTime = [formView viewWithTag:1002];
//    if (formTime==nil) {
//        formTime = [[UIView alloc] init];
//        formTime.tag = 1002;
//        formTime.frame = CGRectMake(-1, 16+38-1, width+2, 52);
//        formTime.backgroundColor = fieldBGColor;
//        
//        formTime.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formTime.layer.borderWidth = 0.5;
//        
//        UIImageView *formTimeLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20-2, 19, 14, 14)];
//        formTimeLeftIcon.image = [UIImage imageNamed:@"icon_form_time.png"];
//        [formTime addSubview:formTimeLeftIcon];
//        
//        UILabel *formTimeLeftDate=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 2, 120, 30)];
//        formTimeLeftDate.tag = 100201;
//        formTimeLeftDate.backgroundColor=[UIColor clearColor];
//        formTimeLeftDate.textAlignment=UITextAlignmentLeft;
//        formTimeLeftDate.textColor=UIColorFromRGB(0xB2B2B2, 1.0);
//        formTimeLeftDate.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
//        [formTime addSubview:formTimeLeftDate];
//        
//        UILabel *formTimeLeftTime=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 30-3, 120, 20)];
//        formTimeLeftTime.tag = 100202;
//        formTimeLeftTime.backgroundColor=[UIColor clearColor];
//        formTimeLeftTime.textAlignment=UITextAlignmentLeft;
//        formTimeLeftTime.textColor=UIColorFromRGB(0x222222, 1.0);
//        formTimeLeftTime.font=[UIFont fontWithName:@"MicrosoftYaHei" size:12];
//        [formTime addSubview:formTimeLeftTime];
//        
//        UIImageView *formTimeBreakImage = [[UIImageView alloc] initWithFrame:CGRectMake((width-19)/2, 0, 19, 51)];
//        formTimeBreakImage.image = [UIImage imageNamed:@"icon_form_column_break.png"];
//        [formTime addSubview:formTimeBreakImage];
//        
//        UILabel *formTimeRightDate=[[UILabel alloc] initWithFrame:CGRectMake(width/2+30, 2, 120, 30)];
//        formTimeRightDate.tag = 100203;
//        formTimeRightDate.backgroundColor=[UIColor clearColor];
//        formTimeRightDate.textAlignment=UITextAlignmentLeft;
//        formTimeRightDate.textColor=UIColorFromRGB(0xB2B2B2, 1.0);
//        formTimeRightDate.font=[UIFont fontWithName:@"MicrosoftYaHei" size:14];
//        [formTime addSubview:formTimeRightDate];
//        
//        UILabel *formTimeRightTime=[[UILabel alloc] initWithFrame:CGRectMake(width/2+30, 30-3, 120, 20)];
//        formTimeRightTime.tag = 100204;
//        formTimeRightTime.backgroundColor=[UIColor clearColor];
//        formTimeRightTime.textAlignment=UITextAlignmentLeft;
//        formTimeRightTime.textColor=UIColorFromRGB(0x222222, 1.0);
//        formTimeRightTime.font=[UIFont fontWithName:@"MicrosoftYaHei" size:12];
//        [formTime addSubview:formTimeRightTime];
//        
//        UIButton *leftDateTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        leftDateTimeBtn.tag = 100205;
//        leftDateTimeBtn.frame = CGRectMake(0, 0, width/2, 52);
//        [leftDateTimeBtn addTarget:self action:@selector(formTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [formTime addSubview:leftDateTimeBtn];
//        
//        UIButton *rightDateTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightDateTimeBtn.tag = 100206;
//        rightDateTimeBtn.frame = CGRectMake(width/2, 0, width/2, 52);
//        [rightDateTimeBtn addTarget:self action:@selector(formTimeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [formTime addSubview:rightDateTimeBtn];
//        
//        [formView addSubview:formTime];
//        
//    }
//    
//    UILabel *formTimeLeftDate=(UILabel *)[formTime viewWithTag:100201];
//    UILabel *formTimeLeftTime=(UILabel *)[formTime viewWithTag:100202];
//    if (formTimeLeftDate && formTimeLeftTime) {
//        formTimeLeftDate.text = [NSString stringWithFormat:@"%@%@",[MobileUtils getFormatterDate:@"MM月dd日" date:[MobileUtils getDateFromString:scheduleData.startdate formatter:@"yyyy-MM-dd HH:mm:ss"]],[MobileUtils getFormatterWeekDay:[MobileUtils getDateFromString:scheduleData.startdate formatter:@"yyyy-MM-dd HH:mm:ss"]]];
//        formTimeLeftTime.text = [MobileUtils getFormatterDate:@"HH:mm" date:[MobileUtils getDateFromString:scheduleData.startdate formatter:@"yyyy-MM-dd HH:mm:ss"]];
//    }
//
//    UILabel *formTimeRightDate=(UILabel *)[formTime viewWithTag:100203];
//    UILabel *formTimeRightTime=(UILabel *)[formTime viewWithTag:100204];
//    if (formTimeRightDate && formTimeRightTime) {
//        formTimeRightDate.text = [NSString stringWithFormat:@"%@%@",[MobileUtils getFormatterDate:@"MM月dd日" date:[MobileUtils getDateFromString:scheduleData.enddate formatter:@"yyyy-MM-dd HH:mm:ss"]],[MobileUtils getFormatterWeekDay:[MobileUtils getDateFromString:scheduleData.enddate formatter:@"yyyy-MM-dd HH:mm:ss"]]];
//        formTimeRightTime.text = [MobileUtils getFormatterDate:@"HH:mm" date:[MobileUtils getDateFromString:scheduleData.enddate formatter:@"yyyy-MM-dd HH:mm:ss"]];
//    }
//
//    
//    UIView *formUser = [formView viewWithTag:1003];
//    if (formUser==nil) {
//        formUser = [[UIView alloc] init];
//        formUser.tag = 1003;
//        formUser.frame = CGRectMake(-1, 16+38+52-2, width+2, 38);
//        formUser.backgroundColor = fieldBGColor;
//        
//        formUser.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formUser.layer.borderWidth = 0.5;
//        
//        UIImageView *formUserLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20-2, 13, 13, 12)];
//        formUserLeftIcon.tag = 100301;
//        formUserLeftIcon.image = [UIImage imageNamed:@"icon_form_user.png"];
//        [formUser addSubview:formUserLeftIcon];
//        
//        UILabel *formUserLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formUserLabelName.tag = 100302;
//        formUserLabelName.backgroundColor=[UIColor clearColor];
//        formUserLabelName.textAlignment=UITextAlignmentLeft;
//        formUserLabelName.text=@"接收人";
//        formUserLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formUserLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formUser addSubview:formUserLabelName];
//        
//        UILabel *formUserLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formUserLabelValue.tag = 100303;
//        formUserLabelValue.backgroundColor=[UIColor clearColor];
//        formUserLabelValue.textAlignment=UITextAlignmentLeft;
//        formUserLabelValue.text=@"";
//        formUserLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formUserLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formUser addSubview:formUserLabelValue];
//        
//        UIImageView *formUserFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formUserFlag.tag = 100304;
//        formUserFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formUser addSubview:formUserFlag];
//        
//        
//        UIButton *formUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formUserBtn.tag = 100305;
//        formUserBtn.frame = CGRectMake(0, 0, width, 38);
//        [formUser addSubview:formUserBtn];
//        
//        [formUserBtn addTarget:self action:@selector(formUserBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [formView addSubview:formUser];
//    }
//
//    
//    UILabel *formUserLabelValue = (UILabel *)[formUser viewWithTag:100303];
//    if (formUserLabelValue) {
//        NSString *idstrs = scheduleData.touser;
//        NSString *names = @"";
////        names = idstrs;
//        NSArray *ids = [idstrs componentsSeparatedByString:@","];
//        for (NSString *idstr in ids) {
//            NSMutableArray *arr = [WVDBUtils queryData];
//            for (WVPersonMode *pMode in arr) {
//                if ([pMode.uId isEqualToString:idstr]) {
//                    names = [NSString stringWithFormat:@"%@,%@",names,pMode.name];
//                }
//            }
//        }
//        if ([names length]==0) {
//            names = [MobileData sharedInstance].resultServerCurrentName;
//            UserData *ud = [[MobileData sharedInstance] getUserID:names];
//            if (ud) {
//                scheduleData.touser = ud.userID;
//            }
//            if ([scheduleData.touser length] == 0) {
//                scheduleData.touser= [MobileData sharedInstance].resultServerCurrentId ;
//            }
//        }
//        if ([names hasPrefix:@","]) {
//            names = [names substringFromIndex:1];
//        }
//        formUserLabelValue.text = names;
//        self.urlString = [NSString stringWithFormat:@"emobile:Browser:HRMRESOURCE:1:%@",scheduleData.touser];
//    }
//    
//    UIView *formType = [formView viewWithTag:1004];
//    if (formType==nil) {
//        formType = [[UIView alloc] init];
//        formType.tag = 1004;
//        formType.frame = CGRectMake(-1, 16+38+52+38+16-2, width+2, 38);
//        formType.backgroundColor = fieldBGColor;
//        
//        formType.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formType.layer.borderWidth = 0.5;
//        
//        UIImageView *formTypeLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 8, 8)];
//        formTypeLeftIcon.tag = 100401;
//        formTypeLeftIcon.image = [UIImage imageNamed:@"icon_form_type.png"];
//        [formType addSubview:formTypeLeftIcon];
//        
//        UILabel *formTypeLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formTypeLabelName.tag = 100402;
//        formTypeLabelName.backgroundColor=[UIColor clearColor];
//        formTypeLabelName.textAlignment=UITextAlignmentLeft;
//        formTypeLabelName.text=@"类型";
//        formTypeLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formTypeLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formType addSubview:formTypeLabelName];
//        
//        UILabel *formTypeLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formTypeLabelValue.tag = 100403;
//        formTypeLabelValue.backgroundColor=[UIColor clearColor];
//        formTypeLabelValue.textAlignment=UITextAlignmentLeft;
//        formTypeLabelValue.text=@"";
//        formTypeLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formTypeLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formType addSubview:formTypeLabelValue];
//        
//        UIImageView *formTypeFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formTypeFlag.tag = 100404;
//        formTypeFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formType addSubview:formTypeFlag];
//        
//        UIButton *formTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formTypeBtn.tag = 100405;
//        formTypeBtn.frame = CGRectMake(0, 0, width, 38);
//        [formType addSubview:formTypeBtn];
//        
//        [formTypeBtn addTarget:self action:@selector(formTypeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//        [formView addSubview:formType];
//    }
//    
//    UILabel *formTypeLabelValue=(UILabel *)[formType viewWithTag:100403];
//    if (formTypeLabelValue) {
//        for (int i=0;i<[typeValueArray count];i++) {
//            NSString *t = [typeValueArray objectAtIndex:i];
//            if ([t isEqualToString:scheduleData.scheduletype]) {
//                formTypeLabelValue.text = [typeNameArray objectAtIndex:i];
//                break;
//            }
//        }
//    }
//    
//
//    UIView *formUrgentLevel = [formView viewWithTag:1005];
//    if (formUrgentLevel==nil) {
//        formUrgentLevel = [[UIView alloc] init];
//        formUrgentLevel.tag = 1005;
//        formUrgentLevel.frame = CGRectMake(-1, 16+38+52+38+16+38-2-1, width+2, 38);
//        formUrgentLevel.backgroundColor = fieldBGColor;
//        
//        formUrgentLevel.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formUrgentLevel.layer.borderWidth = 0.5;
//        
//        UIImageView *formUrgentLevelLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14, 10, 10)];
//        formUrgentLevelLeftIcon.tag = 100501;
//        formUrgentLevelLeftIcon.layer.cornerRadius = 5;
//        formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xFFCD5C,1.0);
//        [formUrgentLevel addSubview:formUrgentLevelLeftIcon];
//        
//        UILabel *formUrgentLevelLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formUrgentLevelLabelName.tag = 100502;
//        formUrgentLevelLabelName.backgroundColor=[UIColor clearColor];
//        formUrgentLevelLabelName.textAlignment=UITextAlignmentLeft;
//        formUrgentLevelLabelName.text=@"紧急程度";
//        formUrgentLevelLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formUrgentLevelLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formUrgentLevel addSubview:formUrgentLevelLabelName];
//        
//        UILabel *formUrgentLevelLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formUrgentLevelLabelValue.tag = 100503;
//        formUrgentLevelLabelValue.backgroundColor=[UIColor clearColor];
//        formUrgentLevelLabelValue.textAlignment=UITextAlignmentLeft;
//        formUrgentLevelLabelValue.text=@"";
//        formUrgentLevelLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formUrgentLevelLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formUrgentLevel addSubview:formUrgentLevelLabelValue];
//        
//        UIImageView *formUrgentLevelFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formUrgentLevelFlag.tag = 100504;
//        formUrgentLevelFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formUrgentLevel addSubview:formUrgentLevelFlag];
//        
//        UIButton *formUrgentLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formUrgentLevelBtn.tag = 100505;
//        formUrgentLevelBtn.frame = CGRectMake(0, 0, width, 38);
//        [formUrgentLevel addSubview:formUrgentLevelBtn];
//        
//        [formUrgentLevelBtn addTarget:self action:@selector(formUrgentLevelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//
//        [formView addSubview:formUrgentLevel];
//    }
//    
//    UILabel *formUrgentLevelLabelValue=(UILabel *)[formUrgentLevel viewWithTag:100503];
//    if (formUrgentLevelLabelValue) {
//        for (int i=0;i<[SCHEDULE_URGENTLEVEL_VALUE count];i++) {
//            NSString *t = [SCHEDULE_URGENTLEVEL_VALUE objectAtIndex:i];
//            if ([t isEqualToString:scheduleData.urgentlevel]) {
//                formUrgentLevelLabelValue.text = [SCHEDULE_URGENTLEVEL_NAME objectAtIndex:i];
//                break;
//            }
//        }
//    }
//
//    UIImageView *formUrgentLevelLeftIcon = (UIImageView *)[formUrgentLevel viewWithTag:100501];
//    if (formUrgentLevelLeftIcon) {
//        if ([scheduleData.urgentlevel isEqualToString:@"3"]) {
//            formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xCB82FF, 1.0);
//        } else if ([scheduleData.urgentlevel isEqualToString:@"2"]) {
//            formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xFFCD5C, 1.0);
//        } else {
//            formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xBFBEBF, 1.0);
//        }
//    }
//
//    UIView *formAlarm = [formView viewWithTag:1006];
//    if (formAlarm==nil) {
//        formAlarm = [[UIView alloc] init];
//        formAlarm.tag = 1006;
//        formAlarm.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2, width+2, 38);
//        formAlarm.backgroundColor = fieldBGColor;
//        
//        formAlarm.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formAlarm.layer.borderWidth = 0.5;
//        
//        UIImageView *formAlarmLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20-2, 12, 13, 13)];
//        formAlarmLeftIcon.tag = 100601;
//        formAlarmLeftIcon.image = [UIImage imageNamed:@"icon_form_alarm.png"];
//        [formAlarm addSubview:formAlarmLeftIcon];
//        
//        UILabel *formAlarmLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formAlarmLabelName.tag = 100602;
//        formAlarmLabelName.backgroundColor=[UIColor clearColor];
//        formAlarmLabelName.textAlignment=UITextAlignmentLeft;
//        formAlarmLabelName.text=@"提醒方式";
//        formAlarmLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarm addSubview:formAlarmLabelName];
//        
//        UILabel *formAlarmLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formAlarmLabelValue.tag = 100603;
//        formAlarmLabelValue.backgroundColor=[UIColor clearColor];
//        formAlarmLabelValue.textAlignment=UITextAlignmentLeft;
//        formAlarmLabelValue.text=@"";
//        formAlarmLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarm addSubview:formAlarmLabelValue];
//        
//        UIImageView *formAlarmFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formAlarmFlag.tag = 100604;
//        formAlarmFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formAlarm addSubview:formAlarmFlag];
//        
//        UIButton *formAlarmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formAlarmBtn.tag = 100605;
//        formAlarmBtn.frame = CGRectMake(0, 0, width, 38);
//        [formAlarm addSubview:formAlarmBtn];
//        
//        [formAlarmBtn addTarget:self action:@selector(formAlarmBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [formView addSubview:formAlarm];
//
//    }
//    
//    UILabel *formAlarmLabelValue=(UILabel*)[formAlarm viewWithTag:100603];
//    if (formAlarmLabelValue) {
//        for (int i=0;i<[SCHEDULE_ALARMWAY_VALUE count];i++) {
//            NSString *t = [SCHEDULE_ALARMWAY_VALUE objectAtIndex:i];
//            if ([t isEqualToString:scheduleData.alarmway]) {
//                formAlarmLabelValue.text = [SCHEDULE_ALARMWAY_NAME objectAtIndex:i];
//                currAlarmSelectedIndex = i;
//                NSLog(@"......show form view index %d ",currAlarmSelectedIndex);
//                break;
//            }
//        }
//    }
//
//    UIView *formAlarmWay = [formView viewWithTag:1007];
//    if (formAlarmWay==nil) {
//        formAlarmWay = [[UIView alloc] init];
//        formAlarmWay.tag = 1007;
//        formAlarmWay.frame = formAlarm.frame;
//        formAlarmWay.backgroundColor = fieldBGColor;
//        
//        formAlarmWay.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formAlarmWay.layer.borderWidth = 0.5;
//        formAlarmWay.layer.masksToBounds = YES;
//        
//        UILabel *formAlarmWayLabel=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 240, 30)];
//        formAlarmWayLabel.tag = 100701;
//        formAlarmWayLabel.backgroundColor=[UIColor clearColor];
//        formAlarmWayLabel.textAlignment=UITextAlignmentLeft;
//        formAlarmWayLabel.text=@"";
//        formAlarmWayLabel.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmWayLabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarmWay addSubview:formAlarmWayLabel];
//        
//        UIImageView *formAlarmWayFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formAlarmWayFlag.tag = 100702;
//        formAlarmWayFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formAlarmWay addSubview:formAlarmWayFlag];
//        
//        UIButton *formAlarmWayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formAlarmWayBtn.tag = 100703;
//        formAlarmWayBtn.frame = CGRectMake(0, 0, width, 38);
//        [formAlarmWay addSubview:formAlarmWayBtn];
//        
//        [formAlarmWayBtn addTarget:self action:@selector(formAlarmWayBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [formView addSubview:formAlarmWay];
//        
//    }
//    
//    UILabel *formAlarmWayLabel=(UILabel *)[formAlarmWay viewWithTag:100701];
//    if (formAlarmWayLabel) {
//        for (int i=0;i<[SCHEDULE_ALARMWAY_VALUE count];i++) {
//            NSString *t = [SCHEDULE_ALARMWAY_VALUE objectAtIndex:i];
//            if ([t isEqualToString:scheduleData.alarmway]) {
//                formAlarmWayLabel.text = [SCHEDULE_ALARMWAY_NAME objectAtIndex:i];
//                break;
//            }
//        }
//    }
//
//
//    UIView *formAlarmBegin = [formView viewWithTag:1008];
//    if (formAlarmBegin==nil) {
//        formAlarmBegin = [[UIView alloc] init];
//        formAlarmBegin.tag = 1008;
//        formAlarmBegin.frame = formAlarm.frame;
//        formAlarmBegin.backgroundColor = fieldBGColor;
//        
//        formAlarmBegin.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formAlarmBegin.layer.borderWidth = 0.5;
//        
//        UILabel *formAlarmBeginLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formAlarmBeginLabelName.tag = 100801;
//        formAlarmBeginLabelName.backgroundColor=[UIColor clearColor];
//        formAlarmBeginLabelName.textAlignment=UITextAlignmentLeft;
//        formAlarmBeginLabelName.text=@"开始前";
//        formAlarmBeginLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmBeginLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarmBegin addSubview:formAlarmBeginLabelName];
//        
//        UILabel *formAlarmBeginLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formAlarmBeginLabelValue.tag = 100802;
//        formAlarmBeginLabelValue.backgroundColor=[UIColor clearColor];
//        formAlarmBeginLabelValue.textAlignment=UITextAlignmentLeft;
//        formAlarmBeginLabelValue.text=@"";
//        formAlarmBeginLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmBeginLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarmBegin addSubview:formAlarmBeginLabelValue];
//        
//        UIImageView *formAlarmBeginFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formAlarmBeginFlag.tag = 100803;
//        formAlarmBeginFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formAlarmBegin addSubview:formAlarmBeginFlag];
//        
//        UIButton *formAlarmBeginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formAlarmBeginBtn.tag = 100804;
//        formAlarmBeginBtn.frame = CGRectMake(0, 0, width, 38);
//        [formAlarmBegin addSubview:formAlarmBeginBtn];
//        
//        [formAlarmBeginBtn addTarget:self action:@selector(formAlarmBeginBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [formView addSubview:formAlarmBegin];
//        
//    }
//
//    UILabel *formAlarmBeginLabelValue=(UILabel *)[formAlarmBegin viewWithTag:100802];
//    if (formAlarmBeginLabelValue) {
//        if ([scheduleData.alarmstart intValue]>0) {
//            NSString *alarmstr = @"";
//            int d = [scheduleData.alarmstart intValue]>60*24?[scheduleData.alarmstart intValue] / (60 * 24):0;
//            if (d>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d天",alarmstr,d];
//            }
//            int h = [scheduleData.alarmstart intValue]>60?[scheduleData.alarmstart intValue] / 60:0;
//            if (h>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d小时",alarmstr,h];
//            }
//            int m = [scheduleData.alarmstart intValue]>60?[scheduleData.alarmstart intValue]-([scheduleData.alarmstart intValue]/60)*60:[scheduleData.alarmstart intValue];
//            if (m>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d分钟",alarmstr,m];
//            }
//            formAlarmBeginLabelValue.text = alarmstr;
//        }
//    }
//
//    
//    UIView *formAlarmEnd = [formView viewWithTag:1009];
//    if (formAlarmEnd==nil) {
//        formAlarmEnd = [[UIView alloc] init];
//        formAlarmEnd.tag = 1009;
//        formAlarmEnd.frame = formAlarm.frame;
//        formAlarmEnd.backgroundColor = fieldBGColor;
//        
//        formAlarmEnd.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formAlarmEnd.layer.borderWidth = 0.5;
//        
//        UILabel *formAlarmEndLabelName=[[UILabel alloc] initWithFrame:CGRectMake(40+8, 4, 100, 30)];
//        formAlarmEndLabelName.tag = 100901;
//        formAlarmEndLabelName.backgroundColor=[UIColor clearColor];
//        formAlarmEndLabelName.textAlignment=UITextAlignmentLeft;
//        formAlarmEndLabelName.text=@"结束前";
//        formAlarmEndLabelName.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmEndLabelName.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarmEnd addSubview:formAlarmEndLabelName];
//        
//        UILabel *formAlarmEndLabelValue=[[UILabel alloc] initWithFrame:CGRectMake(40+8+100-10, 4, 160, 30)];
//        formAlarmEndLabelValue.tag = 100902;
//        formAlarmEndLabelValue.backgroundColor=[UIColor clearColor];
//        formAlarmEndLabelValue.textAlignment=UITextAlignmentLeft;
//        formAlarmEndLabelValue.text=@"";
//        formAlarmEndLabelValue.textColor=UIColorFromRGB(0x222222, 1.0);
//        formAlarmEndLabelValue.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formAlarmEnd addSubview:formAlarmEndLabelValue];
//        
//        UIImageView *formAlarmEndFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-15, 15, 7, 8)];
//        formAlarmEndFlag.tag = 100903;
//        formAlarmEndFlag.image = [UIImage imageNamed:@"icon_form_close.png"];
//        [formAlarmEnd addSubview:formAlarmEndFlag];
//        
//        UIButton *formAlarmEndBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formAlarmEndBtn.tag = 100904;
//        formAlarmEndBtn.frame = CGRectMake(0, 0, width, 38);
//        [formAlarmEnd addSubview:formAlarmEndBtn];
//        
//        [formAlarmEndBtn addTarget:self action:@selector(formAlarmEndBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [formView addSubview:formAlarmEnd];
//        
//    }
//    
//    UILabel *formAlarmEndLabelValue=(UILabel *)[formAlarmEnd viewWithTag:100902];
//    if (formAlarmEndLabelValue) {
//        if ([scheduleData.alarmend intValue]>0) {
//            NSString *alarmstr = @"";
//            int d = [scheduleData.alarmend intValue]>60*24?[scheduleData.alarmend intValue] / (60 * 24):0;
//            if (d>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d天",alarmstr,d];
//            }
//            int h = [scheduleData.alarmend intValue]>60?[scheduleData.alarmend intValue] / 60:0;
//            if (h>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d小时",alarmstr,h];
//            }
//            int m = [scheduleData.alarmend intValue]>60?[scheduleData.alarmend intValue]-([scheduleData.alarmend intValue]/60)*60:[scheduleData.alarmend intValue];
//            if (m>0) {
//                alarmstr = [NSString stringWithFormat:@"%@%d分钟",alarmstr,m];
//            }
//            formAlarmEndLabelValue.text = alarmstr;
//        }
//    }
//
//    if (!alarmShow) {
//        formAlarmWay.hidden = YES;
//        formAlarmBegin.hidden = YES;
//        formAlarmEnd.hidden = YES;
//    }
//    
//    [formView bringSubviewToFront:formAlarm];
//
//    
//    UIView *formNote = [formView viewWithTag:1010];
//    if (formNote==nil) {
//        formNote = [[UIView alloc] init];
//        formNote.tag = 1010;
//        formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1+16, width+2, 76);
//        formNote.backgroundColor = fieldBGColor;
//        
//        formNote.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
//        formNote.layer.borderWidth = 0.5;
//        
//        UIView * formNoteLeftView = [[UIView alloc] init];
//        formNoteLeftView.frame = CGRectMake(0,0,100,76);
//        
//        UIImageView *formNoteLeftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12+19, 13, 13)];
//        formNoteLeftIcon.image = [UIImage imageNamed:@"icon_form_notes.png"];
//        [formNoteLeftView addSubview:formNoteLeftIcon];
//        
//        UILabel *formNoteLeftLable=[[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 76)];
//        formNoteLeftLable.backgroundColor=[UIColor clearColor];
//        formNoteLeftLable.textAlignment=UITextAlignmentCenter;
//        formNoteLeftLable.text=@"描述";
//        formNoteLeftLable.textColor=UIColorFromRGB(0x222222, 1.0);
//        formNoteLeftLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
//        [formNoteLeftView addSubview:formNoteLeftLable];
//        
////        UITextView *formNoteField = [[UITextView alloc] initWithFrame:CGRectMake(90, 0, width+2, 38)];
////        formNoteField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
////        formNoteField.delegate = self;
////        formNoteField.tag = 101001;
////        formNoteField.scrollEnabled = YES;
////        formNoteField.returnKeyType = UIReturnKeyDefault;
////        
////        [formNote addSubview:formNoteField];
////        [formView addSubview:formNote];
////    }
////    UITextView *formNoteField = (UITextView *)[formNote viewWithTag:101001];
////    if (formNoteField) {
////        formNoteField.text = scheduleData.notes;
////    }
//        
//        formNoteField = [[PCFocusColorTextField alloc] init];
//        formNoteField.frame = CGRectMake(-1, 0, width+2, 76);
//        formNoteField.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
//        formNoteField.delegate = self;
//        formNoteField.tag = 101001;
//        formNoteField.leftViewMode = UITextFieldViewModeAlways;
//        formNoteField.leftView = formNoteLeftView;
//        formNoteField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        formNoteField.placeholder = @"";
//        formNoteField.focusedBackgroundColor = UIColorFromRGB(0x00BCF3, 0.5);
//        formNoteField.returnKeyType = UIReturnKeyDefault;
//        
//        formNoteFieldView = [[UITextView alloc] initWithFrame:CGRectMake(90, 0, width-90, 76)];
//        formNoteFieldView.delegate = self;
//        formNoteFieldView.font = [UIFont fontWithName:@"MicrosoftYaHei" size:14];
//        formNoteFieldView.scrollEnabled = YES;
//        
//        UIToolbar * customView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 38)];
//        [customView setBarStyle:UIBarStyleDefault];
//        UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(btnClicked)];
//        NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneButton,nil];
//        [customView setItems:buttonsArray];
//        [formNoteFieldView setInputAccessoryView:customView];
//        
//        [formNoteField addSubview:formNoteFieldView];
//        
//        [formNote addSubview:formNoteField];
//        
//        [formView addSubview:formNote];
//    }
//    
////    PCFocusColorTextField *formNoteField = (PCFocusColorTextField *)[formNote viewWithTag:101001];
////    if (formNoteField) {
//    if ([formNoteField subviews]) {
//        if([[[formNoteField subviews] objectAtIndex:0] isKindOfClass:[UITextView class]]){
//            UITextView *view = [[formNoteField subviews] objectAtIndex:0];
//            view.text = scheduleData.notes;
//        }
////        formNoteField.text = scheduleData.notes;
//    
//    }
//
//    UIButton *formFinishBtn = (UIButton *)[formView viewWithTag:1012];
//    if (formFinishBtn==nil) {
//
//        formFinishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formFinishBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38+38-2-2-1+16+76+16, width-10-10, 35);
//        formFinishBtn.backgroundColor = UIColorFromRGB(0x56C056, 1.0);
//        formFinishBtn.tag = 1012;
//        
//        [formFinishBtn setImage:[UIImage imageNamed:@"icon_btn_complete.png"] forState:UIControlStateNormal];
//        [formFinishBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 125, 10, 125+30)];
//        
//        [formFinishBtn setTitle:@"结束" forState:UIControlStateNormal];
//        [formFinishBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:14]];
//        [formFinishBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 105, 10, 100)];
//        
//        [formFinishBtn setTitleColor:UIColorFromRGB(0xB2B2B2, 1.0) forState:UIControlStateDisabled];
//        [formFinishBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateNormal];
//        [formFinishBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateHighlighted];
//        
//        [formView addSubview:formFinishBtn];
//        
//        [formFinishBtn addTarget:self action:@selector(formFinishBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    if ([scheduleData.ID length]>0) {
//        formFinishBtn.enabled = YES;
//    } else {
//        formFinishBtn.enabled = NO;
//    }
//    
//    UIButton *formDelBtn = (UIButton *)[formView viewWithTag:1011];
//    if (formDelBtn==nil) {
//        
//        formDelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38+38-2-2-1+16+38+16+76+10, width-10-10, 35);
//        formDelBtn.backgroundColor = UIColorFromRGB(0xFF5757, 1.0);
//        formDelBtn.tag = 1011;
//        
//        [formDelBtn setImage:[UIImage imageNamed:@"icon_btn_delete.png"] forState:UIControlStateNormal];
//        [formDelBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 125, 10, 125+35)];
//        
//        [formDelBtn setTitle:@"删除" forState:UIControlStateNormal];
//        [formDelBtn.titleLabel setFont:[UIFont fontWithName:@"MicrosoftYaHei" size:14]];
//        [formDelBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 105, 10, 100)];
//        
//        [formDelBtn setTitleColor:UIColorFromRGB(0xB2B2B2, 1.0) forState:UIControlStateDisabled];
//        [formDelBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateNormal];
//        [formDelBtn setTitleColor:UIColorFromRGB(0xFFFFFF, 1.0) forState:UIControlStateHighlighted];
//
//        [formView addSubview:formDelBtn];
//        
//        [formDelBtn addTarget:self action:@selector(formDeleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    if ([scheduleData.ID length]>0) {
//        formDelBtn.enabled = YES;
//    } else {
//        formDelBtn.enabled = NO;
//    }
//
//    
//    CGRect contentRect = CGRectZero;
//    for (UIView *view in formView.subviews) {
//        contentRect = CGRectUnion(contentRect, view.frame);
//    }
//    formView.contentSize = CGSizeMake(formView.frame.size.width, contentRect.size.height+10);
//}

//-(void)textViewDidBeginEditing:(UITextView *)textView{
//    activeField = formNoteField;
//    if (!keyboardVisible) {
//        oldFrame = formView.frame;
//        oldOffset = formView.contentOffset;
//    }
//    
//    CGRect viewFrame = oldFrame;
//    viewFrame.size.height = viewFrame.size.height - 246 - 35;
//    
//    [formView setFrame:viewFrame];
//    
//    CGRect sframe = [[activeField superview] convertRect:activeField.frame toView:formView];
//    
//    sframe.origin.y = sframe.origin.y + 15;
//    
//    [formView scrollRectToVisible:sframe animated:YES];
//}

//-(void)btnClicked{
//    [formNoteFieldView resignFirstResponder];
//    [formNoteField resignFirstResponder];
//}


-(void) formTimeBtnPressed:(id) sender {
    
    UIButton *button = (UIButton *) sender;
    NSDate *date = nil;
    if (button.tag==100205) {
        date = [MobileUtils getDateFromString:scheduleData.startdate formatter:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        date = [MobileUtils getDateFromString:scheduleData.enddate formatter:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    [self showDatePicker:UIDatePickerModeDateAndTime date:date complete:^(NSDate * date){
        UIView *formTime = [formView viewWithTag:1002];
        if (date && formTime) {
            
            NSString *dstr = [NSString stringWithFormat:@"%@%@",[MobileUtils getFormatterDate:@"MM月dd日" date:date],[MobileUtils getFormatterWeekDay:date]];
            NSString *tstr = [MobileUtils getFormatterDate:@"HH:mm" date:date];
            
            if (button.tag==100205) {
                UILabel *formTimeLeftDate=(UILabel *)[formTime viewWithTag:100201];
                UILabel *formTimeLeftTime=(UILabel *)[formTime viewWithTag:100202];
                if (formTimeLeftDate && formTimeLeftTime) {
                    formTimeLeftDate.text = dstr;
                    formTimeLeftTime.text = tstr;
                }
                scheduleData.startdate = [MobileUtils getFormatterDate:@"yyyy-MM-dd HH:mm:ss" date:date];
            }
            
            if (button.tag==100206) {
                UILabel *formTimeRightDate=(UILabel *)[formTime viewWithTag:100203];
                UILabel *formTimeRightTime=(UILabel *)[formTime viewWithTag:100204];
                if (formTimeRightDate && formTimeRightTime) {
                    formTimeRightDate.text = dstr;
                    formTimeRightTime.text = tstr;
                }
                scheduleData.enddate = [MobileUtils getFormatterDate:@"yyyy-MM-dd HH:mm:ss" date:date];
            }
        }
    }];
    
}

//-(void) formUserBtnPressed:(id) sender {
////    
////    [[functionDelegate getMainViewDelegate] showView:EMShowContentBrowserView withCustom:nil withGesture:EMGestureTypeTitle withShowType:EMShowTypePopup withParams:nil withComplete:^{
////        
////        
////        
////        
////        
////    }];
//    self.urlString = [NSString stringWithFormat:@"emobile:Browser:HRMRESOURCE:1:%@",scheduleData.touser];
//    if (browserView!=nil) {
//        [browserView.view removeFromSuperview];
//        [browserView removeFromParentViewController];
//        browserView = nil;
//    }
//    
//    browserView = [[BrowserView alloc] init];
//    //        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:browserView];
//    [self.view addSubview:browserView.view];
//    [self addChildViewController:browserView];
//    browserView.delegate = self;
//    browserView.urlString = self.urlString;
//    //        [delegate presentViewController:nav animated:YES completion:nil];
//    
//    browserView.view.frame = CGRectMake(0,- 20, WIDTH, HEIGHT);
//    
//    [UIView
//     animateWithDuration:0.3
//     delay:0.0
//     options:UIViewAnimationOptionCurveEaseInOut
//     animations:^{
//         browserView.view.frame = CGRectMake(0, -20, WIDTH, HEIGHT);
//     }
//     completion:^(BOOL finished) {
//         
//     }];
//    
//}

//-(void)selectedPerson:(NSArray*)arr type:(int)type{
//    
//    if (browserView!=nil) {
//        [UIView
//         animateWithDuration:0.3
//         delay:0.0
//         options:UIViewAnimationOptionCurveEaseInOut
//         animations:^{
//             browserView.view.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
//         }
//         completion:^(BOOL finished) {
//             [browserView.view removeFromSuperview];
//             [browserView removeFromParentViewController];
//             browserView = nil;
//         }];
//    }
//    
//    NSMutableArray *idArray = [NSMutableArray new];
//    NSMutableArray *nameArray  = [NSMutableArray new];
//    for (int i = 0; i < arr.count; i++) {
//        WVPersonMode *personMode = (WVPersonMode*)arr[i];
//        [idArray addObject:personMode.uId];
//        [nameArray addObject:personMode.name];
//        scheduleData.touser = [idArray objectAtIndex:0];
//    }
//    if ([idArray count] >1) {
//        for (int i = 1; i < [nameArray count]; i ++) {
//            scheduleData.touser = [scheduleData.touser stringByAppendingString:[NSString stringWithFormat:@",%@",[idArray objectAtIndex:i]]];
//        }
//    }
//    if ([nameArray count] > 0) {
//        NSString *showNameLabel = [nameArray objectAtIndex:0];
//        if ([nameArray count] > 1) {
//            for (int i = 1; i < [nameArray count]; i ++) {
//                showNameLabel = [showNameLabel stringByAppendingString:[NSString stringWithFormat:@",%@",[nameArray objectAtIndex:i]]];
//            }
//        }
//        
//        UIView *formUser = [formView viewWithTag:1003];
//        UILabel *formUserLabelValue = (UILabel *)[formUser viewWithTag:100303];
//        formUserLabelValue.text = showNameLabel;
//    }
//    
////    [self showView];
//}

-(void) formTypeBtnPressed:(id) sender {
    
    [self showTypeSelView:scheduleData.scheduletype complete:^{
        UIView *formType = [formView viewWithTag:1004];
        if (formType) {
            UILabel *formTypeLabelValue=(UILabel *)[formType viewWithTag:100403];
            if (formTypeLabelValue && [typeValueArray count]>typeSelectedIndex) {
                formTypeLabelValue.text = [typeNameArray objectAtIndex:typeSelectedIndex];
                scheduleData.scheduletype = [typeValueArray objectAtIndex:typeSelectedIndex];
            }
        }
    }];
    
}

-(void) formUrgentLevelBtnPressed:(id) sender {
    
    [self showUrgentLevelSelView:scheduleData.urgentlevel complete:^{
        scheduleData.urgentlevel = [SCHEDULE_URGENTLEVEL_VALUE objectAtIndex:urgentlevelSelectedIndex];
        UIView *formUrgentLevel = [formView viewWithTag:1005];
        if (formUrgentLevel) {
            UILabel *formUrgentLevelLabelValue=(UILabel *)[formUrgentLevel viewWithTag:100503];
            if (formUrgentLevelLabelValue) {
                formUrgentLevelLabelValue.text = [SCHEDULE_URGENTLEVEL_NAME objectAtIndex:urgentlevelSelectedIndex];
            }
            UIImageView *formUrgentLevelLeftIcon = (UIImageView *)[formUrgentLevel viewWithTag:100501];
            if (formUrgentLevelLeftIcon) {
                if ([scheduleData.urgentlevel isEqualToString:@"3"]) {
                    formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xCB82FF, 1.0);
                } else if ([scheduleData.urgentlevel isEqualToString:@"2"]) {
                    formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xFFCD5C, 1.0);
                } else {
                    formUrgentLevelLeftIcon.backgroundColor = UIColorFromRGB(0xBFBEBF, 1.0);
                }
            }
        }

    }];
    
}

-(void) formAlarmBtnPressed:(id) sender {
    NSLog(@"alarm way selected number %d  \n curr index %d ",alarmwaySelectedIndex, currAlarmSelectedIndex);
    CGFloat width = self.view.frame.size.width;
    
    UIView *formAlarm = [formView viewWithTag:1006];
    UIImageView *formAlarmFlag = nil;
    if (formAlarm) {
        formAlarmFlag = (UIImageView *)[formAlarm viewWithTag:100604];
    }
    
    UIView *formAlarmWay = [formView viewWithTag:1007];
    UIView *formAlarmBegin = [formView viewWithTag:1008];
    UIView *formAlarmEnd = [formView viewWithTag:1009];
    
    UIView *formNote = [formView viewWithTag:1010];
    UIButton *formDelBtn = (UIButton *)[formView viewWithTag:1011];
    UIButton *formFinishBtn = (UIButton *)[formView viewWithTag:1012];
    
    if (formAlarmFlag && formAlarmWay && formAlarmBegin && formAlarmEnd && formNote && formDelBtn && formFinishBtn) {
        if (!alarmShow) {
            
            alarmShow = YES;
            formAlarmWay.hidden = NO;
            switch (currAlarmSelectedIndex) {
                case 0:
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = YES;
                    break;
                case 1:
                    formAlarmBegin.hidden = YES;
                    formAlarmEnd.hidden = YES;
                    break;
                case 3:
                    formAlarmWay.hidden = NO;
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = NO;
                    break;
                case 4:
                    formAlarmWay.hidden = NO;
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = NO;
                    break;
                default:
                    formAlarmWay.hidden = NO;
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = NO;
                    break;
            }
//            formAlarmWay.hidden = NO;
//            formAlarmBegin.hidden = NO;
//            formAlarmEnd.hidden = NO;
            
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 
                 static CGFloat radian = 90 * (M_PI * 2 / 360);
                 CGAffineTransform transformTmp = formAlarmFlag.transform;
                 transformTmp = CGAffineTransformRotate(transformTmp, radian);
                 formAlarmFlag.transform = transformTmp;
                 switch (currAlarmSelectedIndex) {
                     case 0:
                         formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                         formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);
                         
                         formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+16, width+2, 38);
                         formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+10, width-10-10, 35);
                         formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+16, width-10-10, 35);
                         break;
                    case 1:
                         formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                         
                         formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+16, width+2, 38);
                         formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+16+38+10, width-10-10, 35);
                         formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+16, width-10-10, 35);
                         break;
                    case 2:
                         formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                         formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);
                         formAlarmEnd.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38+38-2-2-3, width+2, 38);
                         
                         formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+38+16, width+2, 38);
                         formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+38+10, width-10-10, 35);
                         formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16, width-10-10, 35);
                         break;
                    case 3:
                         formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                         formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);
                         formAlarmEnd.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38+38-2-2-3, width+2, 38);
                         
                         formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+38+16, width+2, 38);
                         formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+38+10, width-10-10, 35);
                         formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16, width-10-10, 35);
                         break;
                         
                     default:
                         
                         break;
                 }
//                 formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
//                 formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);
//                 formAlarmEnd.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38+38-2-2-3, width+2, 38);
//                 
//                 formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+38+16, width+2, 38);
//                 formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+38+10, width-10-10, 35);
//                 formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16, width-10-10, 35);
                 
             }
             completion:^(BOOL finished) {
                 UIView *formAlarm = [formView viewWithTag:1006];
                 if (formAlarm) {
                     UILabel *formAlarmLabelValue=(UILabel*)[formAlarm viewWithTag:100603];
                     if (formAlarmLabelValue) {
                         formAlarmLabelValue.text = @"";
                     }
                 }
             }];
            
        } else {
            
            alarmShow = NO;
            
            [UIView
             animateWithDuration:0.3
             delay:0.0
             options:UIViewAnimationOptionCurveEaseInOut
             animations:^{
                 
                 static CGFloat radian = -90 * (M_PI * 2 / 360);
                 CGAffineTransform transformTmp = formAlarmFlag.transform;
                 transformTmp = CGAffineTransformRotate(transformTmp, radian);
                 formAlarmFlag.transform = transformTmp;
                 
                 formAlarmWay.frame = formAlarm.frame;
                 formAlarmBegin.frame = formAlarm.frame;
                 formAlarmEnd.frame = formAlarm.frame;
                 
                 formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1+16, width+2, 38);
                 formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38+38-2-2-1+16+38+16+38+10, width-10-10, 35);
                 formFinishBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38+38-2-2-1+16+38+16, width-10-10, 35);
                 
             }
             completion:^(BOOL finished) {
                 
                 UIView *formAlarm = [formView viewWithTag:1006];
                 if (formAlarm) {
                     UILabel *formAlarmLabelValue=(UILabel*)[formAlarm viewWithTag:100603];
                     if (formAlarmLabelValue) {
                         for (int i=0;i<[SCHEDULE_ALARMWAY_VALUE count];i++) {
                             NSString *t = [SCHEDULE_ALARMWAY_VALUE objectAtIndex:i];
                             if ([t isEqualToString:scheduleData.alarmway]) {
                                 formAlarmLabelValue.text = [SCHEDULE_ALARMWAY_NAME objectAtIndex:i];
                                 break;
                             }
                         }
                     }
                 }

                 formAlarmWay.hidden = YES;
                 formAlarmBegin.hidden = YES;
                 formAlarmEnd.hidden = YES;
                 
             }];
        }
    }
    
    CGRect contentRect = CGRectZero;
    for (UIView *view in formView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    formView.contentSize = CGSizeMake(formView.frame.size.width, contentRect.size.height+10);

}

-(void) formAlarmWayBtnPressed:(id) sender {
    
    [self showAlarmWaySelView:scheduleData.alarmway complete:^{
        UIView *formAlarmWay = [formView viewWithTag:1007];
        if (formAlarmWay) {
            UILabel *formAlarmWayLabel=(UILabel *)[formAlarmWay viewWithTag:100701];
            if (formAlarmWayLabel) {
                formAlarmWayLabel.text = [SCHEDULE_ALARMWAY_NAME objectAtIndex:alarmwaySelectedIndex];
                scheduleData.alarmway = [SCHEDULE_ALARMWAY_VALUE objectAtIndex:alarmwaySelectedIndex];
                currAlarmSelectedIndex = alarmwaySelectedIndex;
                NSLog(@"......alarm btn way selected index %d ",currAlarmSelectedIndex);
            }
            UIView *formAlarmWay = [formView viewWithTag:1007];
            UIView *formAlarmBegin = [formView viewWithTag:1008];
            UIView *formAlarmEnd = [formView viewWithTag:1009];
            
            UIView *formNote = [formView viewWithTag:1010];
            UIButton *formDelBtn = (UIButton *)[formView viewWithTag:1011];
            UIButton *formFinishBtn = (UIButton *)[formView viewWithTag:1012];
            CGFloat width = self.view.frame.size.width;
            switch (currAlarmSelectedIndex) {
                case 0:
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = YES;
                    formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                     formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);

                     formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+16, width+2, 38);
                     formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+10, width-10-10, 35);
                     formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+16, width-10-10, 35);
                    break;
                case 1:
                    formAlarmBegin.hidden = YES;
                    formAlarmEnd.hidden = YES;
                    formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                    
                    formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+16, width+2, 38);
                    formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+16+38+10, width-10-10, 35);
                    formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+16, width-10-10, 35);
                    break;
                    
                default:
                    formAlarmBegin.hidden = NO;
                    formAlarmEnd.hidden = NO;
                    formAlarmWay.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38-2-2-1, width+2, 38);
                    formAlarmBegin.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38-2-2-2, width+2, 38);
                    formAlarmEnd.frame = CGRectMake(-1, 16+38+52+38+16+38+38+38+38+38-2-2-3, width+2, 38);
                    
                    formNote.frame = CGRectMake(-1, 16+38+52+38+16+38+38-2-2+38+38+38+38+16, width+2, 38);
                    formDelBtn.frame=CGRectMake(10, 16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16+38+10, width-10-10, 35);
                    formFinishBtn.frame=CGRectMake(10,16+38+52+38+16+38+38-2-2+38+16+38+38+38+38+16, width-10-10, 35);
                    break;
            }
            
        }
    }];
    
}

-(void) formAlarmBeginBtnPressed:(id) sender {
    
    UIButton *button = (UIButton *) sender;
    
    if (!keyboardVisible) {
        oldFrame = formView.frame;
        oldOffset = formView.contentOffset;
    }
    CGRect viewFrame = oldFrame;
    viewFrame.size.height = viewFrame.size.height - 216;
    [formView setFrame:viewFrame];
    
    CGRect sframe = [[sender superview] convertRect:button.frame toView:formView];
    [formView scrollRectToVisible:sframe animated:YES];
    keyboardVisible = YES;
    
    int l = [scheduleData.alarmstart intValue];
    int d = 0;
    int h = 0;
    int m = 0;
    if (l>60*24) {
        d = l/(60*24);
        l = l-d*60*24;
    }
    if (l>60) {
        h = l/60;
        l = l-h*60;
    }
    if (l>0) {
        m = l;
    }
    
    [self showTimePicker:[[NSArray alloc] initWithObjects:@(d),@(h),@(m), nil] complete:^(NSArray *interval){
        [formView setFrame:oldFrame];
        [formView setContentOffset:oldOffset];
        keyboardVisible = NO;
        
        if ([interval count]>0) {
            int d = [[interval objectAtIndex:0] intValue];
            int h = [[interval objectAtIndex:1] intValue];
            int m = [[interval objectAtIndex:2] intValue];
            scheduleData.alarmstart = [NSString stringWithFormat:@"%d",d*24*60+h*60+m];
            UIView *formAlarmBegin = [formView viewWithTag:1008];
            if (formAlarmBegin) {
                UILabel *formAlarmBeginLabelValue=(UILabel *)[formAlarmBegin viewWithTag:100802];
                if (formAlarmBeginLabelValue) {
                    NSString *alarmstr = @"";
                    if (d>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d天",alarmstr,d];
                    }
                    if (h>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d小时",alarmstr,h];
                    }
                    if (m>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d分钟",alarmstr,m];
                    }
                    formAlarmBeginLabelValue.text = alarmstr;
                }
            }
        }
    }];

}

-(void) formAlarmEndBtnPressed:(id) sender {
    
    UIButton *button = (UIButton *) sender;
    
    if (!keyboardVisible) {
        oldFrame = formView.frame;
        oldOffset = formView.contentOffset;
    }
    CGRect viewFrame = oldFrame;
    viewFrame.size.height = viewFrame.size.height - 216;
    [formView setFrame:viewFrame];
    
    CGRect sframe = [[sender superview] convertRect:button.frame toView:formView];
    [formView scrollRectToVisible:sframe animated:YES];
    keyboardVisible = YES;
    
    int l = [scheduleData.alarmend intValue];
    int d = 0;
    int h = 0;
    int m = 0;
    if (l>60*24) {
        d = l/(60*24);
        l = l-d*60*24;
    }
    if (l>60) {
        h = l/60;
        l = l-h*60;
    }
    if (l>0) {
        m = l;
    }

    [self showTimePicker:[[NSArray alloc] initWithObjects:@(d),@(h),@(m), nil] complete:^(NSArray *interval){
        [formView setFrame:oldFrame];
        [formView setContentOffset:oldOffset];
        keyboardVisible = NO;
        
        if ([interval count]>0) {
            int d = [[interval objectAtIndex:0] intValue];
            int h = [[interval objectAtIndex:1] intValue];
            int m = [[interval objectAtIndex:2] intValue];
            scheduleData.alarmend = [NSString stringWithFormat:@"%d",d*24*60+h*60+m];
            UIView *formAlarmEnd = [formView viewWithTag:1009];
            if (formAlarmEnd) {
                UILabel *formAlarmEndLabelValue=(UILabel *)[formAlarmEnd viewWithTag:100902];
                if (formAlarmEndLabelValue) {
                    NSString *alarmstr = @"";
                    if (d>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d天",alarmstr,d];
                    }
                    if (h>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d小时",alarmstr,h];
                    }
                    if (m>0) {
                        alarmstr = [NSString stringWithFormat:@"%@%d分钟",alarmstr,m];
                    }
                    formAlarmEndLabelValue.text = alarmstr;
                }
            }
        }
    }];
    
}

//-(void) formDeleteBtnPressed:(id) sender {
//    
//    NSString *alerttitle = @"\n确定要删除该日程吗?\n\n";
//    
//    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:alerttitle contentView:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil)];
//    
//    [alertView addButtonWithTitle:NSLocalizedString(@"OK", nil)
//                             type:CXAlertViewButtonTypeCustom
//                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
//                              
//                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                  
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                      
//                                      [alertView dismiss];
//                                      
//                                      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                                      
//                                  });
//                              
////                              NSDictionary *moduleInfo = [functionDelegate getModuleInfo];
////                              NSString *module = [moduleInfo objectForKey:@"module"];
////                              NSString *scope = [moduleInfo objectForKey:@"scope"];
//                              NSString *module = [self.moduleInfoDictionary objectForKey:@"module"];
//                              NSString *scope = [self.moduleInfoDictionary objectForKey:@"scope"];
//                              
//                              [[MobileData sharedInstance] operateSchedule:module scope:scope schedule:scheduleData operation:@"del" complete:^(BOOL result) {
//                                  
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                  
//                                  if (result) {
//                                      
//                                      ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
//                                                                                          style:ALAlertBannerStyleSuccess
//                                                                                       position:ALAlertBannerPositionUnderNavBar
//                                                                                          title:@"操作成功!"
//                                                                                       subtitle:@""];
//                                      [banner show];
//                                      
//                                      [functionDelegate loadData];
//                                      
//                                      UIButton *backBtn = (UIButton *)[titleView viewWithTag:12];
//                                      if (backBtn) {
//                                          [backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//                                      }
//                                      
//                                  } else {
//                                      
//                                      ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
//                                                                                          style:ALAlertBannerStyleFailure
//                                                                                       position:ALAlertBannerPositionUnderNavBar
//                                                                                          title:@"操作失败!"
//                                                                                       subtitle:@""];
//                                      [banner show];
//
//                                  }
//                                      
//                                  });
//
//
//                              }];
//                              
//                              });
//
//                          }];
//    
//    [alertView show];
//    
//}

//-(void) formFinishBtnPressed:(id) sender {
//    
//    NSString *alerttitle = @"\n确定要结束该日程吗?\n\n";
//    
//    CXAlertView *alertView = [[CXAlertView alloc] initWithTitle:alerttitle contentView:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil)];
//    
//    [alertView addButtonWithTitle:NSLocalizedString(@"OK", nil)
//                             type:CXAlertViewButtonTypeCustom
//                          handler:^(CXAlertView *alertView, CXAlertButtonItem *button) {
//                              
//                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                  
//                                  dispatch_async(dispatch_get_main_queue(), ^{
//                                  
//                                      [alertView dismiss];
//                                      
//                                      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                                  
//                                  });
//                                  
//                                  //                              NSDictionary *moduleInfo = [functionDelegate getModuleInfo];
//                                  //                              NSString *module = [moduleInfo objectForKey:@"module"];
//                                  //                              NSString *scope = [moduleInfo objectForKey:@"scope"];
//                                  NSString *module = [self.moduleInfoDictionary objectForKey:@"module"];
//                                  NSString *scope = [self.moduleInfoDictionary objectForKey:@"scope"];
//                                  
//                                  [[MobileData sharedInstance] operateSchedule:module scope:scope schedule:scheduleData operation:@"over" complete:^(BOOL result) {
//                                      
//                                      dispatch_async(dispatch_get_main_queue(), ^{
//                                      
//                                      [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                      
//                                      if (result) {
//                                          
//                                          ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
//                                                                                              style:ALAlertBannerStyleSuccess
//                                                                                           position:ALAlertBannerPositionUnderNavBar
//                                                                                              title:@"操作成功!"
//                                                                                           subtitle:@""];
//                                          
//                                          [banner show];
//                                          
//                                          [functionDelegate loadData];
//
//                                          UIButton *backBtn = (UIButton *)[titleView viewWithTag:12];
//                                          if (backBtn) {
//                                              [backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
//                                          }
//                                          
//                                      } else {
//                                          
//                                          ALAlertBanner *banner = [ALAlertBanner alertBannerForView:[self.view window]
//                                                                                              style:ALAlertBannerStyleFailure
//                                                                                           position:ALAlertBannerPositionUnderNavBar
//                                                                                              title:@"操作失败!"
//                                                                                           subtitle:@""];
//                                          [banner show];
//                                          
//                                      }
//                                          
//                                      });
//                                      
//                                  }];
//                                  
//                              });
//                              
//                          }];
//    
//    [alertView show];
//    
//}

#pragma mark for type select view

- (void) showTypeSelView {
    
    CGFloat width = self.view.bounds.size.width;
    
    typeSelView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    
    UIView *typeSelTitle = [typeSelView viewWithTag:100001];
    if (typeSelTitle==nil) {
        typeSelTitle.tag = 100001;
        typeSelTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        typeSelTitle.backgroundColor = UIColorFromRGB(0x0076FF, 1.0);

        [typeSelView addSubview:typeSelTitle];
        
        UILabel *titleLable = (UILabel *)[typeSelTitle viewWithTag:10000101];
        if (titleLable==nil) {
            titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, width-60-60, 30)];
            titleLable.tag = 10000101;
            titleLable.backgroundColor=[UIColor clearColor];
            titleLable.textAlignment=UITextAlignmentCenter;
            titleLable.text=@"选择类型";
            titleLable.textColor=[UIColor whiteColor];
            titleLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
            
            [typeSelTitle addSubview:titleLable];
        }
        
        UIButton *backBtn = (UIButton *)[typeSelTitle viewWithTag:10000102];
        if (backBtn==nil) {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame=CGRectMake(0, 0, 54, 44);
            backBtn.tag = 10000102;
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UIImageView *backLine = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 2, 44)];
            backLine.image=[UIImage imageNamed:@"top_line.png"];
            [backBtn addSubview:backLine];
            
            UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            backIcon.image=[UIImage imageNamed:@"top_icon_back.png"];
            [backBtn addSubview:backIcon];
            
            [typeSelTitle addSubview:backBtn];
            
            [backBtn addTarget:self action:@selector(typeSelBackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *rightBtn = (UIButton *)[typeSelTitle viewWithTag:10000103];
        if (rightBtn==nil) {
            
            rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame=CGRectMake(width-54, 0, 54, 44);
            rightBtn.tag = 10000103;
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UILabel *rightLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
            rightLable.backgroundColor=[UIColor clearColor];
            rightLable.textAlignment=UITextAlignmentCenter;
            rightLable.text=@"确定";
            rightLable.textColor=[UIColor whiteColor];
            rightLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
            [rightBtn addSubview:rightLable];
            
            //        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            //        rightIcon.image=[UIImage imageNamed:@"top_icon_menu.png"];
            //        [rightBtn addSubview:rightIcon];
            
            UIImageView *rightLine=[[UIImageView alloc] initWithFrame:CGRectMake(width-54-2, 0, 2, 44)];
            rightLine.image=[UIImage imageNamed:@"top_line.png"];
            
            [typeSelTitle addSubview:rightLine];
            
            [typeSelTitle addSubview:rightBtn];
            
            [rightBtn addTarget:self action:@selector(typeSelRightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIScrollView *typeSelScroll = (UIScrollView *)[typeSelView viewWithTag:100002];
    if (typeSelScroll==nil) {
        typeSelScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, width, HEIGHT-44)];
        typeSelScroll.tag = 100002;
        typeSelScroll.showsVerticalScrollIndicator = YES;
        [typeSelView addSubview:typeSelScroll];
    
        int index = 0;
        for (NSString *type in typeValueArray) {
            
            UIView *typeSel = [typeSelView viewWithTag:100002*100+index];
            if (typeSel==nil) {
                typeSel = [[UIView alloc] init];
                typeSel.tag = 100002*100+index;
                typeSel.frame = CGRectMake(-1, 16+38*index-index, width+2, 38);
                typeSel.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
                
                typeSel.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
                typeSel.layer.borderWidth = 0.5;
                
                UILabel *typeSelLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 150, 30)];
                typeSelLabel.tag = (100002*100+index)*10+1;
                typeSelLabel.backgroundColor=[UIColor clearColor];
                typeSelLabel.textAlignment=UITextAlignmentLeft;
                typeSelLabel.text=[typeNameArray objectAtIndex:index];
                typeSelLabel.textColor=UIColorFromRGB(0x222222, 1.0);
                typeSelLabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
                [typeSel addSubview:typeSelLabel];
                
                UIImageView *typeSelFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-23, 11, 18, 15)];
                typeSelFlag.tag = (100002*100+index)*10+2;
                typeSelFlag.image = [UIImage imageNamed:@"icon_form_selected.png"];
                typeSelFlag.hidden = YES;
                [typeSel addSubview:typeSelFlag];
                
                UIButton *typeSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                typeSelBtn.tag = (100002*100+index)*10+3;
                typeSelBtn.frame = CGRectMake(0, 0, width, 38);
                [typeSel addSubview:typeSelBtn];
                
                [typeSelBtn addTarget:self action:@selector(typeSelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [typeSelScroll addSubview:typeSel];
            }
            index++;
        }
        
        CGRect contentRect = CGRectZero;
        for (UIView *view in typeSelScroll.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        typeSelScroll.contentSize = CGSizeMake(typeSelScroll.frame.size.width, contentRect.size.height+10);
        
    }
}

-(void) showTypeSelView:(NSString *)value complete:(void(^)(void)) callBack {
    
    int index = 0;
    for (NSString *type in typeValueArray) {
        UIView *typeSel = [typeSelView viewWithTag:100002*100+index];
        UIImageView *typeSelFlag = (UIImageView *)[typeSel viewWithTag:(100002*100+index)*10+2];
        
        if ([value isEqualToString:type]) {
            typeSelectedIndex = index;
            
            typeSelFlag.hidden = NO;
        } else {
            typeSelFlag.hidden = YES;
        }
        index++;
    }
    
    typeSelView.hidden = NO;
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         typeSelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         typeSelectedCallBack = callBack;
         
     }];
}

-(void) hideTypeSelView {
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         typeSelView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         typeSelectedCallBack = nil;
         
     }];
}

-(void) typeSelBackBtnPressed:(id) sender {
    
    [self hideTypeSelView];
    
    if (typeSelectedCallBack) {
        typeSelectedCallBack();
    }
    
}

-(void) typeSelRightBtnPressed:(id) sender {
    
    int index = 0;
    for (NSString *type in typeValueArray) {
        UIView *typeSel = [typeSelView viewWithTag:100002*100+index];
        UIImageView *typeSelFlag = (UIImageView *)[typeSel viewWithTag:(100002*100+index)*10+2];
        if (!typeSelFlag.hidden) {
            typeSelectedIndex = index;
            break;
        }
        index++;
    }

    [self hideTypeSelView];
    
    if (typeSelectedCallBack) {
        typeSelectedCallBack();
    }
    
}

-(void) typeSelBtnPressed:(id) sender {
    UIButton *typeSelBtn = (UIButton *) sender;
    if (typeSelBtn) {
        int index = 0;
        UIView *typeSel = [typeSelBtn superview];
        if (typeSel) {
            index = typeSel.tag - 100002*100;
            int i=0;
            for (NSString *type in typeValueArray) {
                UIView *typeSel = [typeSelView viewWithTag:100002*100+i];
                UIImageView *typeSelFlag = (UIImageView *)[typeSel viewWithTag:(100002*100+i)*10+2];
                if (i==index) {
                    typeSelFlag.hidden = NO;
                } else {
                    typeSelFlag.hidden = YES;
                }
                i++;
            }
        }
    }
}

#pragma mark for urgentlevel select view

- (void) showUrgentLevelSelView {
    
    CGFloat width = self.view.bounds.size.width;
    
    urgentlevelSelView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    
    UIView *urgentlevelSelTitle = [urgentlevelSelView viewWithTag:100001];
    if (urgentlevelSelTitle==nil) {
        urgentlevelSelTitle.tag = 100001;
        urgentlevelSelTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        urgentlevelSelTitle.backgroundColor = UIColorFromRGB(0x0076FF, 1.0);
        
        [urgentlevelSelView addSubview:urgentlevelSelTitle];
        
        UILabel *titleLable = (UILabel *)[urgentlevelSelTitle viewWithTag:10000101];
        if (titleLable==nil) {
            titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, width-60-60, 30)];
            titleLable.tag = 10000101;
            titleLable.backgroundColor=[UIColor clearColor];
            titleLable.textAlignment=UITextAlignmentCenter;
            titleLable.text=@"选择紧急程度";
            titleLable.textColor=[UIColor whiteColor];
            titleLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
            
            [urgentlevelSelTitle addSubview:titleLable];
        }
        
        UIButton *backBtn = (UIButton *)[urgentlevelSelTitle viewWithTag:10000102];
        if (backBtn==nil) {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame=CGRectMake(0, 0, 54, 44);
            backBtn.tag = 10000102;
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UIImageView *backLine = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 2, 44)];
            backLine.image=[UIImage imageNamed:@"top_line.png"];
            [backBtn addSubview:backLine];
            
            UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            backIcon.image=[UIImage imageNamed:@"top_icon_back.png"];
            [backBtn addSubview:backIcon];
            
            [urgentlevelSelTitle addSubview:backBtn];
            
            [backBtn addTarget:self action:@selector(urgentlevelSelBackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *rightBtn = (UIButton *)[urgentlevelSelTitle viewWithTag:10000103];
        if (rightBtn==nil) {
            
            rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame=CGRectMake(width-54, 0, 54, 44);
            rightBtn.tag = 10000103;
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UILabel *rightLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
            rightLable.backgroundColor=[UIColor clearColor];
            rightLable.textAlignment=UITextAlignmentCenter;
            rightLable.text=@"确定";
            rightLable.textColor=[UIColor whiteColor];
            rightLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
            [rightBtn addSubview:rightLable];
            
            //        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            //        rightIcon.image=[UIImage imageNamed:@"top_icon_menu.png"];
            //        [rightBtn addSubview:rightIcon];
            
            UIImageView *rightLine=[[UIImageView alloc] initWithFrame:CGRectMake(width-54-2, 0, 2, 44)];
            rightLine.image=[UIImage imageNamed:@"top_line.png"];
            
            [urgentlevelSelTitle addSubview:rightLine];
            
            [urgentlevelSelTitle addSubview:rightBtn];
            
            [rightBtn addTarget:self action:@selector(urgentlevelSelRightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIScrollView *urgentlevelSelScroll = (UIScrollView *)[urgentlevelSelView viewWithTag:100002];
    if (urgentlevelSelScroll==nil) {
        urgentlevelSelScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, width, HEIGHT-44)];
        urgentlevelSelScroll.tag = 100002;
        urgentlevelSelScroll.showsVerticalScrollIndicator = YES;
        [urgentlevelSelView addSubview:urgentlevelSelScroll];

        int index = 0;
        for (NSString *urgentlevel in SCHEDULE_URGENTLEVEL_VALUE) {
            
            UIView *urgentlevelSel = [urgentlevelSelView viewWithTag:100002*100+index];
            if (urgentlevelSel==nil) {
                urgentlevelSel = [[UIView alloc] init];
                urgentlevelSel.tag = 100002*100+index;
                urgentlevelSel.frame = CGRectMake(-1, 16+38*index-index, width+2, 38);
                urgentlevelSel.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
                
                urgentlevelSel.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
                urgentlevelSel.layer.borderWidth = 0.5;
                
                UILabel *urgentlevelSelLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 150, 30)];
                urgentlevelSelLabel.tag = (100002*100+index)*10+1;
                urgentlevelSelLabel.backgroundColor=[UIColor clearColor];
                urgentlevelSelLabel.textAlignment=UITextAlignmentLeft;
                urgentlevelSelLabel.text=[SCHEDULE_URGENTLEVEL_NAME objectAtIndex:index];
                urgentlevelSelLabel.textColor=UIColorFromRGB(0x222222, 1.0);
                urgentlevelSelLabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
                [urgentlevelSel addSubview:urgentlevelSelLabel];
                
                UIImageView *urgentlevelSelFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-23, 11, 18, 15)];
                urgentlevelSelFlag.tag = (100002*100+index)*10+2;
                urgentlevelSelFlag.image = [UIImage imageNamed:@"icon_form_selected.png"];
                urgentlevelSelFlag.hidden = YES;
                [urgentlevelSel addSubview:urgentlevelSelFlag];
                
                UIButton *urgentlevelSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                urgentlevelSelBtn.tag = (100002*100+index)*10+3;
                urgentlevelSelBtn.frame = CGRectMake(0, 0, width, 38);
                [urgentlevelSel addSubview:urgentlevelSelBtn];
                
                [urgentlevelSelBtn addTarget:self action:@selector(urgentlevelSelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [urgentlevelSelScroll addSubview:urgentlevelSel];
            }
            index++;
        }
        
        CGRect contentRect = CGRectZero;
        for (UIView *view in urgentlevelSelScroll.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        urgentlevelSelScroll.contentSize = CGSizeMake(urgentlevelSelScroll.frame.size.width, contentRect.size.height+10);
        
    }
}


-(void) showUrgentLevelSelView:(NSString *)value complete:(void(^)(void)) callBack {
    
    int index = 0;
    for (NSString *urgentlevel in SCHEDULE_URGENTLEVEL_VALUE) {
        UIView *urgentlevelSel = [urgentlevelSelView viewWithTag:100002*100+index];
        UIImageView *urgentlevelSelFlag = (UIImageView *)[urgentlevelSel viewWithTag:(100002*100+index)*10+2];
        
        if ([value isEqualToString:urgentlevel]) {
            urgentlevelSelectedIndex = index;
            
            urgentlevelSelFlag.hidden = NO;
        } else {
            urgentlevelSelFlag.hidden = YES;
        }
        index++;
    }
    
    urgentlevelSelView.hidden = NO;
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         urgentlevelSelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         urgentlevelSelectedCallBack = callBack;
         
     }];
}

-(void) hideUrgentLevelSelView {
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         urgentlevelSelView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         urgentlevelSelectedCallBack = nil;
         
     }];
}

-(void) urgentlevelSelBackBtnPressed:(id) sender {
    
    [self hideUrgentLevelSelView];
    
    if (urgentlevelSelectedCallBack) {
        urgentlevelSelectedCallBack();
    }
    
}

-(void) urgentlevelSelRightBtnPressed:(id) sender {
    
    int index = 0;
    for (NSString *urgentlevel in SCHEDULE_URGENTLEVEL_VALUE) {
        UIView *urgentlevelSel = [urgentlevelSelView viewWithTag:100002*100+index];
        UIImageView *urgentlevelSelFlag = (UIImageView *)[urgentlevelSel viewWithTag:(100002*100+index)*10+2];
        if (!urgentlevelSelFlag.hidden) {
            urgentlevelSelectedIndex = index;
            break;
        }
        index++;
    }
    
    [self hideUrgentLevelSelView];
    
    if (urgentlevelSelectedCallBack) {
        urgentlevelSelectedCallBack();
    }
    
}

-(void) urgentlevelSelBtnPressed:(id) sender {
    UIButton *urgentlevelSelBtn = (UIButton *) sender;
    if (urgentlevelSelBtn) {
        int index = 0;
        UIView *urgentlevelSel = [urgentlevelSelBtn superview];
        if (urgentlevelSel) {
            index = urgentlevelSel.tag - 100002*100;
            int i=0;
            for (NSString *urgentlevel in SCHEDULE_URGENTLEVEL_VALUE) {
                UIView *urgentlevelSel = [urgentlevelSelView viewWithTag:100002*100+i];
                UIImageView *urgentlevelSelFlag = (UIImageView *)[urgentlevelSel viewWithTag:(100002*100+i)*10+2];
                if (i==index) {
                    urgentlevelSelFlag.hidden = NO;
                } else {
                    urgentlevelSelFlag.hidden = YES;
                }
                i++;
            }
        }
    }
}


#pragma mark for alarm way select view

- (void) showAlarmWaySelView {
    
    CGFloat width = self.view.bounds.size.width;
    
    alarmwaySelView.backgroundColor = UIColorFromRGB(0xF0F0F0, 1.0);
    
    UIView *alarmwaySelTitle = [alarmwaySelView viewWithTag:100001];
    if (alarmwaySelTitle==nil) {
        alarmwaySelTitle.tag = 100001;
        alarmwaySelTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        alarmwaySelTitle.backgroundColor = UIColorFromRGB(0x0076FF, 1.0);
        
        [alarmwaySelView addSubview:alarmwaySelTitle];
        
        UILabel *titleLable = (UILabel *)[alarmwaySelTitle viewWithTag:10000101];
        if (titleLable==nil) {
            titleLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 7, width-60-60, 30)];
            titleLable.tag = 10000101;
            titleLable.backgroundColor=[UIColor clearColor];
            titleLable.textAlignment=UITextAlignmentCenter;
            titleLable.text=@"选择提醒方式";
            titleLable.textColor=[UIColor whiteColor];
            titleLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:20];
            
            [alarmwaySelTitle addSubview:titleLable];
        }
        
        UIButton *backBtn = (UIButton *)[alarmwaySelTitle viewWithTag:10000102];
        if (backBtn==nil) {
            backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame=CGRectMake(0, 0, 54, 44);
            backBtn.tag = 10000102;
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [backBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UIImageView *backLine = [[UIImageView alloc] initWithFrame:CGRectMake(54, 0, 2, 44)];
            backLine.image=[UIImage imageNamed:@"top_line.png"];
            [backBtn addSubview:backLine];
            
            UIImageView *backIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            backIcon.image=[UIImage imageNamed:@"top_icon_back.png"];
            [backBtn addSubview:backIcon];
            
            [alarmwaySelTitle addSubview:backBtn];
            
            [backBtn addTarget:self action:@selector(alarmwaySelBackBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        UIButton *rightBtn = (UIButton *)[alarmwaySelTitle viewWithTag:10000103];
        if (rightBtn==nil) {
            
            rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            rightBtn.frame=CGRectMake(width-54, 0, 54, 44);
            rightBtn.tag = 10000103;
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_n.png"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"top_btn_bg_h.png"] forState:UIControlStateHighlighted];
            
            UILabel *rightLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
            rightLable.backgroundColor=[UIColor clearColor];
            rightLable.textAlignment=UITextAlignmentCenter;
            rightLable.text=@"确定";
            rightLable.textColor=[UIColor whiteColor];
            rightLable.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
            [rightBtn addSubview:rightLable];
            
            //        UIImageView *rightIcon = [[UIImageView alloc] initWithFrame:CGRectMake(17, 14, 20, 16)];
            //        rightIcon.image=[UIImage imageNamed:@"top_icon_menu.png"];
            //        [rightBtn addSubview:rightIcon];
            
            UIImageView *rightLine=[[UIImageView alloc] initWithFrame:CGRectMake(width-54-2, 0, 2, 44)];
            rightLine.image=[UIImage imageNamed:@"top_line.png"];
            
            [alarmwaySelTitle addSubview:rightLine];
            
            [alarmwaySelTitle addSubview:rightBtn];
            
            [rightBtn addTarget:self action:@selector(alarmwaySelRightBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    UIScrollView *alarmwaySelScroll = (UIScrollView *)[alarmwaySelView viewWithTag:100002];
    if (alarmwaySelScroll==nil) {
        alarmwaySelScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, width, HEIGHT-44)];
        alarmwaySelScroll.tag = 100002;
        alarmwaySelScroll.showsVerticalScrollIndicator = YES;
        [alarmwaySelView addSubview:alarmwaySelScroll];

        int index = 0;
        for (NSString *alarmway in SCHEDULE_ALARMWAY_VALUE) {
            
            UIView *alarmwaySel = [alarmwaySelView viewWithTag:100002*100+index];
            if (alarmwaySel==nil) {
                alarmwaySel = [[UIView alloc] init];
                alarmwaySel.tag = 100002*100+index;
                alarmwaySel.frame = CGRectMake(-1, 16+38*index-index, width+2, 38);
                alarmwaySel.backgroundColor = UIColorFromRGB(0xFFFFFF, 1.0);
                
                alarmwaySel.layer.borderColor = UIColorFromRGB(0xE2E2E2, 1.0).CGColor;
                alarmwaySel.layer.borderWidth = 0.5;
                
                UILabel *alarmwaySelLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 4, 150, 30)];
                alarmwaySelLabel.tag = (100002*100+index)*10+1;
                alarmwaySelLabel.backgroundColor=[UIColor clearColor];
                alarmwaySelLabel.textAlignment=UITextAlignmentLeft;
                alarmwaySelLabel.text=[SCHEDULE_ALARMWAY_NAME objectAtIndex:index];
                alarmwaySelLabel.textColor=UIColorFromRGB(0x222222, 1.0);
                alarmwaySelLabel.font=[UIFont fontWithName:@"MicrosoftYaHei" size:16];
                [alarmwaySel addSubview:alarmwaySelLabel];
                
                UIImageView *alarmwaySelFlag = [[UIImageView alloc] initWithFrame:CGRectMake(width-23, 11, 18, 15)];
                alarmwaySelFlag.tag = (100002*100+index)*10+2;
                alarmwaySelFlag.image = [UIImage imageNamed:@"icon_form_selected.png"];
                alarmwaySelFlag.hidden = YES;
                [alarmwaySel addSubview:alarmwaySelFlag];
                
                UIButton *alarmwaySelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                alarmwaySelBtn.tag = (100002*100+index)*10+3;
                alarmwaySelBtn.frame = CGRectMake(0, 0, width, 38);
                [alarmwaySel addSubview:alarmwaySelBtn];
                
                [alarmwaySelBtn addTarget:self action:@selector(alarmwaySelBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [alarmwaySelScroll addSubview:alarmwaySel];
            }
            index++;
        }
        
        CGRect contentRect = CGRectZero;
        for (UIView *view in alarmwaySelScroll.subviews) {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        alarmwaySelScroll.contentSize = CGSizeMake(alarmwaySelScroll.frame.size.width, contentRect.size.height+10);
    
    }
    
}

-(void) showAlarmWaySelView:(NSString *)value complete:(void(^)(void)) callBack {
    
    int index = 0;
    for (NSString *alarmway in SCHEDULE_ALARMWAY_VALUE) {
        UIView *alarmwaySel = [alarmwaySelView viewWithTag:100002*100+index];
        UIImageView *alarmwaySelFlag = (UIImageView *)[alarmwaySel viewWithTag:(100002*100+index)*10+2];
        
        if ([value isEqualToString:alarmway]) {
            alarmwaySelectedIndex = index;
            
            alarmwaySelFlag.hidden = NO;
        } else {
            alarmwaySelFlag.hidden = YES;
        }
        index++;
    }
    
    alarmwaySelView.hidden = NO;
    
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         alarmwaySelView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         alarmwaySelectedCallBack = callBack;
         
     }];
}

-(void) hideAlarmWaySelView {
    [UIView
     animateWithDuration:0.3
     delay:0.0
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         alarmwaySelView.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT);
         
     }
     completion:^(BOOL finished) {
         
         alarmwaySelectedCallBack = nil;
         
     }];
}

-(void) alarmwaySelBackBtnPressed:(id) sender {
    
    [self hideAlarmWaySelView];
    
    if (alarmwaySelectedCallBack) {
        alarmwaySelectedCallBack();
    }
    
}

-(void) alarmwaySelRightBtnPressed:(id) sender {
    
    int index = 0;
    for (NSString *alarmway in SCHEDULE_ALARMWAY_VALUE) {
        UIView *alarmwaySel = [alarmwaySelView viewWithTag:100002*100+index];
        UIImageView *alarmwaySelFlag = (UIImageView *)[alarmwaySel viewWithTag:(100002*100+index)*10+2];
        if (!alarmwaySelFlag.hidden) {
            alarmwaySelectedIndex = index;
            break;
        }
        index++;
    }
    
    [self hideAlarmWaySelView];
    
    if (alarmwaySelectedCallBack) {
        alarmwaySelectedCallBack();
    }
    
}

-(void) alarmwaySelBtnPressed:(id) sender {
    UIButton *alarmwaySelBtn = (UIButton *) sender;
    if (alarmwaySelBtn) {
        int index = 0;
        UIView *alarmwaySel = [alarmwaySelBtn superview];
        if (alarmwaySel) {
            index = alarmwaySel.tag - 100002*100;
            int i=0;
            for (NSString *alarmway in SCHEDULE_ALARMWAY_VALUE) {
                UIView *alarmwaySel = [alarmwaySelView viewWithTag:100002*100+i];
                UIImageView *alarmwaySelFlag = (UIImageView *)[alarmwaySel viewWithTag:(100002*100+i)*10+2];
                if (i==index) {
                    alarmwaySelFlag.hidden = NO;
                } else {
                    alarmwaySelFlag.hidden = YES;
                }
                i++;
            }
        }
    }
}

@end