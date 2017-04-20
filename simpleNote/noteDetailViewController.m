//
//  modifyViewController.m
//  simpleNote
//
//  Created by Vic on 13-11-21.
//  Copyright (c) 2013年 vic. All rights reserved.
//

#import "noteDetailViewController.h"
#import "rootViewController.h"
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@interface noteDetailViewController ()<UIAlertViewDelegate>
@property UITextView *mytextView;
@property (nonatomic, strong)UIButton *savebtn;
@end

@implementation noteDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mytextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 15, kScreen_Width, kScreen_Height)];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSString *oldtext = [array objectAtIndex:self.index];
    self.mytextView.text = oldtext;
//    UIBarButtonItem *savebtn = [[UIBarButtonItem alloc]initWithTitle:@"save" style:UIBarButtonItemStylePlain target:self action:@selector(saveclicked)];

    UIBarButtonItem *delbtn = [[UIBarButtonItem alloc]initWithTitle:@"delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteclicked)];
    NSArray *bararray = [NSArray arrayWithObjects:delbtn, nil];
    self.navigationItem.rightBarButtonItems = bararray;
    [self.view addSubview:self.mytextView];
    _savebtn=[[UIButton alloc] init];
    [_savebtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    _savebtn.frame=CGRectMake(kScreen_Width/2-12,kScreen_Height-70,32,32);
    [_savebtn addTarget:self action:@selector(saveclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_savebtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveclicked{
    NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    NSMutableArray *mutableArray = [tempArray mutableCopy];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *now = [NSDate date];
    NSString *datestring = [dateFormatter stringFromDate:now];
    NSString *textstring = [self.mytextView text];
    [mutableArray removeObjectAtIndex:self.index];
    [mutableArray insertObject:textstring atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
    rootViewController *rootctrl = [[rootViewController alloc]init];
    rootctrl.noteArray = mutableArray;
    
    NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
    [mutableDateArray removeObjectAtIndex:self.index];
    [mutableDateArray insertObject:datestring atIndex:0 ];
    rootctrl.dateArray = mutableDateArray;
    [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
    
    [self.mytextView resignFirstResponder];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"save success!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alertView show];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteclicked{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Are you sure to delete this note?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
        NSMutableArray *mutableArray = [tempArray mutableCopy];
        [mutableArray removeObjectAtIndex:self.index];
        [[NSUserDefaults standardUserDefaults] setObject:mutableArray forKey:@"note"];
        rootViewController *rootctrl = [[rootViewController alloc]init];
        rootctrl.noteArray = mutableArray;
        
        NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
        NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
        [mutableDateArray removeObjectAtIndex:self.index];
        [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];
        rootctrl.dateArray = mutableDateArray;

        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (buttonIndex == 1) return;
}

@end
