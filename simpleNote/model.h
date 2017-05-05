//
//  model.h
//  simpleNote
//
//  Created by lyngame on 2017/4/27.
//  Copyright © 2017年 vic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface model : NSObject
@property(nonatomic, copy)NSString *name;
@property(nonatomic, retain)NSMutableArray *modelArray;

-(id)initWithDic:(NSDictionary *)dic;

@end
