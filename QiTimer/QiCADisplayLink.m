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

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSTimeInterval lastTS;

@end

@implementation QiCADisplayLink


#pragma mark - NSTimer Methods

- (void)resumeDisplayLink {

    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTimeout)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)pauseDisplayLink {

    [_displayLink invalidate];
    _displayLink = nil;
}


- (void)onTimeout {
    
    NSTimeInterval ts = [[NSDate date] timeIntervalSince1970];
    NSLog(@"---QiCADisplayLink--->>%ld  %.5f", (long)_count++, ts - _lastTS);
    _lastTS = ts;
}

@end
