//
//  MyCell.h
//  simpleNote
//
//  Created by 易达威 on 2017/4/5.
//  Copyright © 2017年 vic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *datalb;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;
@end
