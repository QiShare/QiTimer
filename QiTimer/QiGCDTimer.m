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

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSTimeInterval lastTS;

@end

@implementation QiGCDTimer

+ (QiGCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    QiGCDTimer *timer = [[QiGCDTimer alloc] initWithInterval:interval repeats:repeats queue:queue block:block];
    return timer;
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block {
    
    self = [super init];
    if (self) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(self.timer, ^{
            if (!repeats) {
                dispatch_source_cancel(self.timer);
            }
            block();
            
            
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


- (void)onTimeout {
    
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSLog(@"---QiGCDTimer--->>%ld  %.5f", (long)_count++, ts - _lastTS);
    _lastTS = ts;
}

@end
