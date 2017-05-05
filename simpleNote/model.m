//
//  model.m
//  simpleNote
//
//  Created by lyngame on 2017/4/27.
//  Copyright © 2017年 vic. All rights reserved.
//

#import <Foundation/Foundation.h>
//KVC的应用  简化冗余代码
#import "model.h"

@implementation model

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSLog(@"undefine key ---%@",key);
}

@end
