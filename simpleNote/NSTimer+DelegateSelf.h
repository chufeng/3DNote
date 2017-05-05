//
//  NSTimer+DelegateSelf.h
//  simpleNote
//
//  Created by lyngame on 2017/4/27.
//  Copyright © 2017年 vic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSTimer (DelegateSelf)
+(NSTimer *)scheduledTimerWithTimeInterval:(int)timeInterval block:(void(^)())block repeats:(BOOL)yesOrNo;
@end
