//
//  QiGCDTimer.h
//  QiTimer
//
//  Created by wangdacheng on 2019/7/8.
//  Copyright © 2019 qishare. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QiGCDTimer : NSObject

+ (QiGCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)(void))block;

- (void)invalidate;

@end

NS_ASSUME_NONNULL_END
