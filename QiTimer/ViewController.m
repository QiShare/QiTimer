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

@property (nonatomic, strong) QiNSTimer *timer;
@property (nonatomic, strong) QiGCDTimer *gcdTimer;
@property (nonatomic, strong) QiCADisplayLink *caDisplayLink;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) UIView *rotateView;
@property (nonatomic, assign) CFTimeInterval last;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self setTitle:@"QiTimer"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _rotateView = [[UIView alloc] initWithFrame:CGRectMake(100, 80, 40, 40)];
    [_rotateView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_rotateView];
    
    CGFloat margin = 15;
    CGFloat offset = 150;
    CGSize size = self.view.frame.size;
    NSArray *titleArr = @[@"NSTimer", @"CADisplayLink", @"GCDTimer", @"RealTimeSchedulingClass&TimingAPI"];
    for (int i=0; i<titleArr.count; i++) {
        NSString *title = [titleArr objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(margin, offset, size.width - margin * 2, 45);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        [self.view addSubview:button];
        button.tag = 100 + i;
        
        offset += 45 + margin;
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, offset, size.width - 30, 150)];
    scrollView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(size.width, 1000);
}


#pragma mark - Actions

- (void)buttonClicked:(UIButton *)button {
    
    switch (button.tag) {
        case 100:
            _timer = [[QiNSTimer alloc] init];
            [_timer startNSTimer];
            break;
        case 101:
            _caDisplayLink = [[QiCADisplayLink alloc] init];
            [_caDisplayLink startCADisplayLinkTimer];
            break;
        case 102:
            _gcdTimer = [QiGCDTimer scheduledTimerWithTimeInterval:0.00001 repeats:YES queue:dispatch_get_main_queue() block:^{
                
            }];
            break;
        case 103:
            [self testTPPreciseTimer];
            break;
        default:
            break;
    }
    
}

- (void)testTPPreciseTimer {
    
    struct mach_timebase_info timebase;
    mach_timebase_info(&timebase);
    double timebase_ratio = ((double)timebase.numer / (double)timebase.denom) * 1.0e-9;
    
    TestObject *testObject = [[TestObject alloc] init];
    
    for ( int i=0; i<10; i++ ) {
        NSTimeInterval duration = ((double)rand()/RAND_MAX) * 2.0;
        printf("\nDuration: %lf s\n", duration);
        
        NSTimeInterval start = mach_absolute_time() * timebase_ratio;
        
        [TPPreciseTimer scheduleBlock:^{
            NSTimeInterval end = mach_absolute_time() * timebase_ratio;
            printf("TPPreciseTimer deviation:\t%lf s\n", (end-start) - duration);
        } inTimeInterval:duration];
        
        [NSTimer scheduledTimerWithTimeInterval:duration
                                         target:testObject
                                       selector:@selector(timerFired:)
                                       userInfo:^{
                                           NSTimeInterval end = mach_absolute_time() * timebase_ratio;
                                           printf("NSTimer deviation:\t\t\t%lf s\n", (end-start) - duration);
                                       }repeats:NO];
        
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:duration + 0.1]];
    }
    
    NSTimeInterval start = mach_absolute_time() * timebase_ratio;
    [TPPreciseTimer scheduleBlock:^{
        NSTimeInterval end = mach_absolute_time() * timebase_ratio;
        printf("TPPreciseTimer test pre-empt: Event 2 deviation:\t%lf s\n", (end-start) - 0.4);
    } inTimeInterval:0.4];
    
    [NSThread sleepForTimeInterval:0.1];
    
    start = mach_absolute_time() * timebase_ratio;
    [TPPreciseTimer scheduleBlock:^{
        NSTimeInterval end = mach_absolute_time() * timebase_ratio;
        printf("TPPreciseTimer test pre-empt: Event 1 deviation:\t%lf s\n", (end-start) - 0.2);
    } inTimeInterval:0.2];
    
    [TPPreciseTimer scheduleAction:@selector(shouldNotFire) target:testObject inTimeInterval:0.2];
    [NSThread sleepForTimeInterval:0.1];
    [TPPreciseTimer cancelAction:@selector(shouldNotFire) target:testObject];
    
    [NSThread sleepForTimeInterval:0.5];
}



@end


