//
//  QiGCDTimer.m
//  QiTimer
//
//  Created by wangdacheng on 2019/7/8.
//  Copyright © 2019 qishare. All rights reserved.
//

#import "QiGCDTimer.h"

@interface QiGCDTimer ()

@property (strong, nonatomic) dispatch_source_t timer;


//// 测试
@property (nonatomic, strong) NSDate *lastStartTime;
@property (nonatomic, assign) NSInteger currentCount;
@property (nonatomic, assign) NSInteger maxCount;

@end

@implementation QiGCDTimer

+ (QiGCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    QiGCDTimer *timer = [[QiGCDTimer alloc] initWithInterval:interval repeats:repeats queue:queue block:block];
    return timer;
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    self = [super init];
    if (self) {
        
        
        //// 测试
        _maxCount = 10;
        _currentCount = 0;
        
        
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (!repeats) {
                dispatch_source_cancel(self.timer);
            }
            //block();
            
            
            //// 测试
            [self onTimeout];
        });
        dispatch_resume(self.timer);
    }
    return self;
}

- (void)dealloc {
    
    [self invalidate];
}

- (void)invalidate {
    
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}



//// 测试
- (void)onTimeout {
    
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
        [self invalidate];
    }
}

- (NSString *)getTimeStampStr:(NSDate *)date {
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    NSString *intervalStr = [NSString stringWithFormat:@"%.3fms", interval * 1000];
    
    return [NSString stringWithFormat:@"%@", intervalStr];
}

@end
