//
//  detailViewController.m
//  simpleNote
//
//  Created by Vic on 13-11-20.
//  Copyright (c) 2013年 vic. All rights reserved.
//

#import "addNoteViewController.h"
#import "rootViewController.h"
#import "UIViewController+DismissKeyboard.h"
#import "ZYTextView.h"
#import "ZYToolBarView.h"
#import "ZYVoiceRecognizerView.h"

#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@interface addNoteViewController ()<UITextViewDelegate>
@property ZYTextView *mytextView;
//键盘上 文字|语音按钮
@property (nonatomic, strong) ZYToolBarView *toolBarView;
@property (nonatomic, strong)UIButton *savebtn;
//语音识别的view
@property (nonatomic, strong) ZYVoiceRecognizerView *voiceRecognizerView;

@end

@implementation addNoteViewController

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
    [self setupForDismissKeyboard];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupTextView];
    [self setupToolBarView];
    _savebtn=[[UIButton alloc] init];
    [_savebtn setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
    _savebtn.frame=CGRectMake(kScreen_Width/2-12,kScreen_Height-70,32,32);
    [_savebtn addTarget:self action:@selector(saveclicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_savebtn];

//    UIBarButtonItem *savebtn = [[UIBarButtonItem alloc]initWithTitle:@"save" style:UIBarButtonItemStyleBordered target:self action:@selector(saveclicked)];
//    self.navigationItem.rightBarButtonItem = savebtn;
}
#pragma mark - 懒加载
- (ZYToolBarView *)toolBarView
{
    if (_toolBarView == nil) {
        _toolBarView = [[ZYToolBarView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        _toolBarView.wordActionBlock = ^(){
            //展示文字键盘
            [weakSelf.mytextView resignFirstResponder];
            weakSelf.mytextView.inputView = nil;
            [weakSelf.mytextView becomeFirstResponder];
        };
        _toolBarView.voiceActionBlock = ^(){
            //展示语音键盘
            [weakSelf.mytextView resignFirstResponder];
            if (weakSelf.mytextView.inputView == nil) {
                weakSelf.mytextView.inputView = weakSelf.voiceRecognizerView;
            }
            [weakSelf.mytextView becomeFirstResponder];
        };
    }
    return _toolBarView;
}

- (ZYVoiceRecognizerView *)voiceRecognizerView
{
    if (_voiceRecognizerView == nil) {
        _voiceRecognizerView = [[ZYVoiceRecognizerView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        _voiceRecognizerView.voiceRecResultBlock = ^(NSString *resultFromJson)
        {
            ///处理光标
            //1.获取光标位置
            NSRange selectedRange = weakSelf.mytextView.selectedRange;
            //2.将光标所在位置的的字符串进行替换
            weakSelf.mytextView.text = [weakSelf.mytextView.text stringByReplacingCharactersInRange:selectedRange withString:resultFromJson];
            //3.修改光标位置,光标放到新增加的文字的后面
            weakSelf.mytextView.selectedRange = NSMakeRange((selectedRange.location + resultFromJson.length), 0);
            ///
            
            [weakSelf textChange];
        };
        _voiceRecognizerView.voiceDeleteBackwardBlock = ^(){
            
            [weakSelf.mytextView deleteBackward];
        };
    }
    return _voiceRecognizerView;
}
#pragma mark - setup
- (void)setupToolBarView
{
    [self.view addSubview:self.toolBarView];
}
#pragma mark - textView
- (void)setupTextView
{
    self.mytextView = [[ZYTextView alloc]initWithFrame:CGRectMake(10, 15, kScreen_Width-20, kScreen_Height-120)];
    [self.view addSubview:self.mytextView];
    
    self.mytextView.placeHolder = @"输入文字...(您输入的第一排将会作为标题)";
    self.mytextView.font = [UIFont systemFontOfSize:16];
    self.mytextView.delegate = self;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange) name:UITextViewTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveclicked{
    NSString *textstring = [self.mytextView text];
    NSString *temp = [textstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([temp length]!=0){
        NSMutableArray *initNoteArray = [[NSMutableArray alloc]init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"note"]==nil) {
            [[NSUserDefaults standardUserDefaults] setObject:initNoteArray forKey:@"note"];
        }
        NSArray *tempNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
        NSMutableArray *mutableNoteArray = [tempNoteArray mutableCopy];
        
        [mutableNoteArray insertObject:textstring atIndex:0 ];
        rootViewController *rootctrl = [[rootViewController alloc]init];
        rootctrl.noteArray = mutableNoteArray;
        [[NSUserDefaults standardUserDefaults] setObject:mutableNoteArray forKey:@"note"];
        
        NSMutableArray *initDateArray = [[NSMutableArray alloc]init];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"date"]==nil) {
            [[NSUserDefaults standardUserDefaults] setObject:initDateArray forKey:@"date"];
        }
        NSArray *tempDateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
        NSMutableArray *mutableDateArray = [tempDateArray mutableCopy];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSDate *now = [NSDate date];
        NSString *datestring = [dateFormatter stringFromDate:now];
        [mutableDateArray insertObject:datestring atIndex:0 ];
        rootctrl.dateArray = mutableDateArray;
        [[NSUserDefaults standardUserDefaults] setObject:mutableDateArray forKey:@"date"];

    }
    
    
    [self.mytextView resignFirstResponder];
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"add success!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alertView show];

    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissViewControllerAnimated:true completion:^{
        rootViewController *vc=[[rootViewController alloc]init];
        [vc addsucc];
    }];
}
- (void)keyboardFrameChange:(NSNotification *)note
{
    //获取键盘的frame
    //UIKeyboardFrameEndUserInfoKey是对象
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //键盘改变frame经历的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    if (frame.origin.y == kScreen_Height) {//没有弹出键盘
        //包装动画
        [UIView animateWithDuration:duration animations:^{
            
            //切换键盘的时候,使它浮动不那么大
            //            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            self.toolBarView.transform = CGAffineTransformIdentity;
            self.toolBarView.hidden = YES;
            self.savebtn.transform = CGAffineTransformIdentity;
            
        }];
    }
    else//弹出键盘
    {
        //工具条向上移动
        [UIView animateWithDuration:duration animations:^{
            
            //            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            CGFloat ty = - frame.size.height;
            if(self.navigationController)
            {
                ty = - frame.size.height;
            }
            else
            {
                ty = - frame.size.height;
            }
            self.toolBarView.transform = CGAffineTransformMakeTranslation(0, ty);
            self.savebtn.transform = CGAffineTransformMakeTranslation(0, ty+10);
            self.toolBarView.hidden = NO;
            
            //语音转文字frame
            if (_voiceRecognizerView == nil) {
                CGRect rect = self.voiceRecognizerView.frame;
                rect.size.height = frame.size.height;
                self.voiceRecognizerView.frame = rect;
            }
        }];
    }
}

- (void)textChange
{
    if (self.mytextView.text.length) {//有内容
        self.mytextView.hidePlaceholder = YES;
    }
    else
    {
        self.mytextView.hidePlaceholder = NO;
    }
}


@end
