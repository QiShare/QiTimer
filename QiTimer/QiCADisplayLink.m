//
//  QiCADisplayLink.m
//  QiTimer
//
//  Created by wangdacheng on 2019/7/2.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "QiCADisplayLink.h"
#import <QuartzCore/QuartzCore.h>

@interface QiCADisplayLink ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, strong) NSDate *lastStartTime;

@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation QiCADisplayLink


#pragma mark - NSTimer Methods

- (void)resumeDisplayLink {

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimeout:)];
    //_displayLink.preferredFramesPerSecond = 50;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)pauseDisplayLink {

    [_displayLink invalidate];
    _displayLink = nil;
}



#pragma mark - Test Methods

- (void)startCADisplayLinkTimer {
    
    _maxCount = 10;
    _currentCount = 0;
    _timeInterval = 0.1;// 100ms
    
    [self resumeDisplayLink];
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
        [self pauseDisplayLink];
    }
}

- (NSString *)getTimeStampStr:(NSDate *)date {
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *intervalStr = [NSString stringWithFormat:@"%.3fms", interval * 1000];
    
    return [NSString stringWithFormat:@"%@", intervalStr];
}

@end
