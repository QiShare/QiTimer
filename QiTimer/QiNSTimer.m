//
//  QiNSTimer.m
//  QiTimer
//
//  Created by wangdacheng on 2019/7/2.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "QiNSTimer.h"

#define QiNSTimerInterval    0.0001

@interface QiNSTimer ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSTimeInterval lastTS;

@end

@implementation QiNSTimer


#pragma mark - NSTimer Methods

- (void)resumeTimer {
    
    if (_timer) {
        [self pauseTimer];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:QiNSTimerInterval target:self selector:@selector(onTimeout:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    [_timer fire];
}

- (void)pauseTimer {

    [_timer invalidate];
    _timer = nil;
}

- (void)onTimeout:(NSTimer *)sender {
    
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSLog(@"---QiNSTimer--->>%ld  %.5f", (long)_count++, ts - _lastTS);
    _lastTS = ts;
}

@end
