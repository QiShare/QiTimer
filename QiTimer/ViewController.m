//
//  ViewController.m
//  QiTimer
//
//  Created by wangdacheng on 2019/7/2.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "ViewController.h"
#import "QiNSTimer.h"
#import "QiCADisplayLink.h"
#import "QiGCDTimer.h"
#import "TPPreciseTimer.h"
#import <mach/mach_time.h>

@interface TestObject : NSObject
- (void)timerFired:(NSTimer*)timer;
@end
@implementation TestObject
- (void)timerFired:(NSTimer*)timer {
    void (^block)(void) = [timer userInfo];
    block();
}
- (void)shouldNotFire {
    printf("This should never happen. Badness 10000/n");
}
@end

@interface ViewController ()

@property(nonatomic, strong) UILabel *countdownLabel;

@property (nonatomic, assign) CGFloat passTime;;
@property (nonatomic, assign) CFTimeInterval timeInterval;

@property (nonatomic, strong) QiNSTimer *timer;
@property (nonatomic, strong) QiGCDTimer *gcdTimer;
@property (nonatomic, strong) QiCADisplayLink *caDisplayLink;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"QiTimer"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat margin = 15;
    CGFloat rowHeight = 30;
    CGSize size = self.view.frame.size;
    
    _countdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, size.width - 100, rowHeight)];
    [self.view addSubview:_countdownLabel];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(margin, 200, size.width - margin * 2, 45);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"开始倒计时" forState:UIControlStateNormal];
    [self.view addSubview:button];
}


#pragma mark - Actions

- (void)buttonClicked:(UIButton *)button {
    
    _passTime = 0.0;
    NSTimeInterval deadlineTS = [[NSDate date] timeIntervalSince1970] + 3600 * 2;
    NSDate *deadlineDate = [NSDate dateWithTimeIntervalSince1970:deadlineTS];
    _timeInterval = [deadlineDate timeIntervalSinceDate:[NSDate date]] * 1000;
   
    
//    // QiNSTimer
//    _timer = [[QiNSTimer alloc] init];
//    [_timer resumeTimer];

//    // QiGCDTimer
//    _gcdTimer = [QiGCDTimer scheduledTimerWithTimeInterval:0.0001 repeats:YES queue:dispatch_get_main_queue() block:^{
//
//    }];

    
    // QiCADisplayLink
    _caDisplayLink = [[QiCADisplayLink alloc] init];
    [_caDisplayLink resumeDisplayLink];


//    // TPPreciseTimer
//    [self testTPPreciseTimer];
}




//#pragma mark - QiNSTimerCall
//
//- (void)qiNSTimerCall {
//    
//    [self getTimeFromTimeInterval:_timeInterval] ;
//    
//    if (_timeInterval-_passTime <= 0) {
//        [_timer pauseTimer] ;
//    }
//}
//
//// 通过时间间隔计算具体时间(小时,分,秒,毫秒)
//- (void)getTimeFromTimeInterval : (double)timeInterval {
//    
//    //1s=1000毫秒
//    //毫秒数从0-9，所以每次过去10毫秒
//    _passTime += QiNSTimerInterval * 1000;
//    
//    NSString *hours = [NSString stringWithFormat:@"%ld", (NSInteger)((timeInterval - _passTime) / 1000 / 60 / 60)];
//    NSString *minute = [NSString stringWithFormat:@"%ld", (NSInteger)((timeInterval - _passTime) / 1000 / 60 ) % 60];
//    NSString *second = [NSString stringWithFormat:@"%ld", ((NSInteger)(timeInterval - _passTime)) / 1000 % 60];
//    CGFloat sss = ((NSInteger)((timeInterval - _passTime)))%1000/(QiNSTimerInterval * 1000);
//    NSString *ss = [NSString stringWithFormat:@"%.lf", sss];
//    
//    _countdownLabel.text = [NSString stringWithFormat:@"剩余：%@:%@:%@.%@", hours, minute, second, ss];
//}

@end













//- (void)testTPPreciseTimer {
//
//    struct mach_timebase_info timebase;
//    mach_timebase_info(&timebase);
//    double timebase_ratio = ((double)timebase.numer / (double)timebase.denom) * 1.0e-9;
//
//    TestObject *testObject = [[TestObject alloc] init];
//
//    for ( int i=0; i<10; i++ ) {
//        NSTimeInterval duration = ((double)rand()/RAND_MAX) * 2.0;
//        printf("\nDuration: %lf s\n", duration);
//
//        // 开始时间
//        NSTimeInterval start = mach_absolute_time() * timebase_ratio;
//
//        // TPPreciseTimer定时
//        [TPPreciseTimer scheduleBlock:^{
//            NSTimeInterval end = mach_absolute_time() * timebase_ratio;
//            printf("TPPreciseTimer deviation:\t%lf s\n", (end-start) - duration);
//        } inTimeInterval:duration];
//
//        // TPPreciseTimer定时
//        [NSTimer scheduledTimerWithTimeInterval:duration
//                                         target:testObject
//                                       selector:@selector(timerFired:)
//                                       userInfo:^{
//                                           NSTimeInterval end = mach_absolute_time() * timebase_ratio;
//                                           printf("NSTimer deviation:\t\t\t%lf s\n", (end-start) - duration);
//                                       }repeats:NO];
//
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:duration + 0.1]];
//    }
//
//    //    NSTimeInterval start = mach_absolute_time() * timebase_ratio;
//    //    [TPPreciseTimer scheduleBlock:^{
//    //        NSTimeInterval end = mach_absolute_time() * timebase_ratio;
//    //        printf("TPPreciseTimer test pre-empt: Event 2 deviation:\t%lf s\n", (end-start) - 0.4);
//    //    } inTimeInterval:0.4];
//    //
//    //    [NSThread sleepForTimeInterval:0.1];
//    //
//    //    start = mach_absolute_time() * timebase_ratio;
//    //    [TPPreciseTimer scheduleBlock:^{
//    //        NSTimeInterval end = mach_absolute_time() * timebase_ratio;
//    //        printf("TPPreciseTimer test pre-empt: Event 1 deviation:\t%lf s\n", (end-start) - 0.2);
//    //    } inTimeInterval:0.2];
//    //
//    //    [TPPreciseTimer scheduleAction:@selector(shouldNotFire) target:testObject inTimeInterval:0.2];
//    //    [NSThread sleepForTimeInterval:0.1];
//    //    [TPPreciseTimer cancelAction:@selector(shouldNotFire) target:testObject];
//    //
//    //    [NSThread sleepForTimeInterval:0.5];
//}



















