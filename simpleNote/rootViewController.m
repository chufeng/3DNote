//
//  rootViewController.m
//  simpleNote
//
//  Created by Vic on 13-11-20.
//  Copyright (c) 2013年 vic. All rights reserved.
//

#import "rootViewController.h"
#import "addNoteViewController.h"
#import "noteDetailViewController.h"
#import "MyCell.h"
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
@interface rootViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
@property NSMutableArray *filteredNoteArray;
@property UISearchBar *bar;
@property (nonatomic, strong)UITableView *tableView;
@property UISearchDisplayController *searchDispCtrl;
@end

@implementation rootViewController
@synthesize noteArray,dateArray,filteredNoteArray,bar,searchDispCtrl;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden =NO;
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.noteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    self.dateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    [self reloadTableViewByType:2]; // to reload selected cell

}
typedef NS_ENUM(NSUInteger,eReloadType){
    eReloadRow, // by row
    eReloadSection, // by section
    eReloadAll // by tableView
};

- (void)reloadTableViewByType:(eReloadType) type
{
    switch (type) {
        case eReloadRow:
            [self reloadDataByRow];
            break;
        case eReloadSection:
            [self reloadDataBySection];
            break;
        case eReloadAll:
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}

- (void)reloadDataBySection
{
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationTop];
}

- (void)reloadDataByRow
{
    NSMutableArray* indexPaths = [NSMutableArray array];
    for (NSInteger row = self.dateArray.count - 1; row >= 0; row --) {
        NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
        [indexPaths addObject:path];
        path = nil;
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
}
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height) style:UITableViewStyleGrouped];
        self.bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        searchDispCtrl = [[UISearchDisplayController alloc]initWithSearchBar:bar contentsController:self];
        searchDispCtrl.delegate = self;
        searchDispCtrl.searchResultsDataSource = self;
        searchDispCtrl.searchResultsDelegate = self;
        [searchDispCtrl.searchResultsTableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
        searchDispCtrl.searchResultsTitle=@"什么都没有了";
        _tableView.tableHeaderView = self.bar;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //注册复用的cell
    [_tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
        //使用纯代码编写的cell注册方式
        //        [_tableView registerClass:[RecipeCell class] forCellReuseIdentifier:@"RecipeCell"];
        
        [self.view addSubview:_tableView];
        UIButton *addbtn=[[UIButton alloc] init];
        [addbtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        addbtn.frame=CGRectMake(kScreen_Width/2-12,kScreen_Height-70,24,24);
        [addbtn addTarget:self action:@selector(addnote) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addbtn];
    }
    return _tableView;
}
-(void)addsucc{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(80, 80, 100, 40)]; label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"提示信息";
    [self.view addSubview:label];
    
    //设置动画
    CATransition * transion = [CATransition animation];
    
    transion.type = @"push";//设置动画方式
    transion.subtype = @"fromRight";//设置动画从那个方向开始
    [label.layer addAnimation:transion forKey:nil];//给Label.layer 添加动画 //设置延时效果
    
    //不占用主线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        [label removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    });

}
- (void)viewDidLoad
{

    
    [super viewDidLoad];
//    self.tableView=[[UITableView alloc] init];
//    self.tableView.frame=CGRectMake(kScreen_Width, kScreen_Height, 0, 0);

    
//    UIBarButtonItem *addbtn1 = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addnote)];
//    self.navigationItem.rightBarButtonItem = addbtn1;
//    self.navigationItem.title = @"Simple Notes";
//    self.bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
//    searchDispCtrl = [[UISearchDisplayController alloc]initWithSearchBar:bar contentsController:self];
//    searchDispCtrl.delegate = self;
//    searchDispCtrl.searchResultsDataSource = self;
//    searchDispCtrl.searchResultsDelegate = self;
//    self.tableView.tableHeaderView = self.bar;
//    [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
//    [self.view addSubview:self.tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredNoteArray count];
    }
    else return [noteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (!cell) {
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Mycell"];
    }
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *note  = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        note = [filteredNoteArray objectAtIndex:indexPath.row];
    }
    else if(tableView == self.tableView){
        note = [noteArray objectAtIndex:indexPath.row];
    };
    NSString *date = [dateArray objectAtIndex:indexPath.row];
    NSUInteger charnum = [note length];
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        NSLog(@"3D Touch  可用!");
        //给cell注册3DTouch的peek（预览）和pop功能
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    } else {
        NSLog(@"3D Touch 无效");
    }
    if (charnum < 22) {
        cell.contentLB.text = note;
    }
    else{
        cell.contentLB.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
    }
//     NSString *subStr2 = [str1 substringToIndex:7];
    if ([date length]>13){
        NSString *subStr = [note substringToIndex:13];
        NSArray *note1=[subStr componentsSeparatedByString:@"\n"];
        cell.titleLB.text=note1[0];
    }else{
        NSArray *note1=[note componentsSeparatedByString:@"\n"];
        cell.titleLB.text=note1[0];
        
    }
    cell.datalb.text = date;
    cell.datalb.font = [UIFont systemFontOfSize:10];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    noteDetailViewController *modifyCtrl = [[noteDetailViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:modifyCtrl animated:NO];
    NSInteger row = [indexPath row];
    modifyCtrl.index = row;
}

- (void)addnote{
    addNoteViewController *detailViewCtrl = [[addNoteViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:detailViewCtrl animated:YES];

}

#pragma mark - UIViewControllerPreviewingDelegate

//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
        NSIndexPath *indexPath = [_tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    //设定预览的界面
  noteDetailViewController *modifyCtrl = [[noteDetailViewController alloc]initWithNibName:nil bundle:nil];
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,148);
    previewingContext.sourceRect = rect;
    NSInteger row = [indexPath row];
    modifyCtrl.index = row;
    //返回预览界面
    return modifyCtrl;
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

#pragma mark uisearchdisplaydelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [filteredNoteArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchString];
    NSArray *tempArray = [noteArray filteredArrayUsingPredicate:predicate];
    filteredNoteArray = [NSMutableArray arrayWithArray:tempArray];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    return YES;
}

@end
