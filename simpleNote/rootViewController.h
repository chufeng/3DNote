//
//  rootViewController.h
//  simpleNote
//
//  Created by Vic on 13-11-20.
//  Copyright (c) 2013年 vic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "model.h"
@interface rootViewController : UIViewController
@property (nonatomic)  NSMutableArray *noteArray;
@property (nonatomic)  NSMutableArray *dateArray;
@property (nonatomic, strong)UITableView *tableView;
@property(nonatomic, retain)model *model;
-(void)addsucc;
@end
