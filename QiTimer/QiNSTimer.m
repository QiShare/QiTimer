//
//  QiNSTimer.m
//  QiTimer
//
//  Created by wangdacheng on 2019/7/2.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "QiNSTimer.h"

@interface QiNSTimer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) NSDate *lastStartTime;

@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) NSInteger maxCount;


@property (nonatomic, strong) NSThread *thread1;

@end

@implementation QiNSTimer


#pragma mark - NSTimer Methods

- (void)resumeTimer {
    
    if (_timer) {
        [self pauseTimer];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(onTimeout:) userInfo:nil repeats:YES];
    _timer.tolerance = 1.0;// 误差范围1s内
    [_timer fire];
    
    
//    if (self.timer && self.thread1) {
//        [self performSelector:@selector(pauseTimer) onThread:self.thread1 withObject:nil waitUntilDone:YES];
//    }
//
//    __weak __typeof(self) weakSelf = self;
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        if (strongSelf) {
//            strongSelf.thread1 = [NSThread currentThread];
//            [strongSelf.thread1 setName:@"线程A"];
//            strongSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:strongSelf selector:@selector(onTimeout:) userInfo:nil repeats:YES];
//            [[NSRunLoop currentRunLoop] run];
//        }
//    });
    
}

- (void)pauseTimer {

    [_timer invalidate];
    _timer = nil;
}


#pragma mark - Test Methods

- (void)startNSTimer {
    
    _maxCount = 10;
    _currentCount = 0;
    _timeInterval = 0.00001;//0.1;// 100ms
    
    [self resumeTimer];
}

- (void)onTimeout:(NSTimer *)sender {
    
    if (_currentCount < _maxCount) {
        
        // selector任务开始
        NSDate *startTime = [NSDate date];
        NSLog(@"---selector start--->> selectorNo.%ld, startTime:%@, start-start diff:%.3fms", (long)_currentCount, [self getTimeStampStr:startTime], [startTime timeIntervalSinceDate:_lastStartTime]*1000);
        _lastStartTime = startTime;
        
        // 耗时任务
        if (_currentCount == 8) {
            NSInteger count = 0;
            for (int i = 0; i < 1000000000; i++) {
                count++;
            }
        }

        // selector结束
        NSDate *endTime = [NSDate date];
        NSLog(@"---selector ended--->> selectorNo.%ld, endTime:%@, end-start diff:%.3fms", (long)_currentCount, [self getTimeStampStr:endTime], [endTime timeIntervalSinceDate:startTime]*1000);
        
        _currentCount++;
    } else {
        [self pauseTimer];
    }
}

- (NSString *)getTimeStampStr:(NSDate *)date {
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *intervalStr = [NSString stringWithFormat:@"%.3fms", interval * 1000];
    
    return [NSString stringWithFormat:@"%@", intervalStr];
}


@end
