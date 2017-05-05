//
//  NSTimer+DelegateSelf.m
//  simpleNote
//
//  Created by lyngame on 2017/4/27.
//  Copyright © 2017年 vic. All rights reserved.
//

#import "NSTimer+DelegateSelf.h"


@implementation NSTimer (DelegateSelf)

+(NSTimer *)scheduledTimerWithTimeInterval:(int)timeInterval block:(void(^)())block repeats:(BOOL)yesOrNo
{
    return [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(callBlock:) userInfo:[block copy] repeats:yesOrNo];
}


+(void)callBlock:(NSTimer *)timer
{
    void(^block)() = timer.userInfo;
    if (block != nil) {
        block();
    }
}
@end
