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
@property (assign, nonatomic)UITableView *tableView;
@property UISearchDisplayController *searchDispCtrl;
@end

@implementation rootViewController
@synthesize noteArray,dateArray,filteredNoteArray,bar,searchDispCtrl;


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.noteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"note"];
    self.dateArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    [self.tableView reloadData]; // to reload selected cell
}

- (void)viewDidLoad
{
    _tableView=[[UITableView alloc]init];
    _tableView.frame=CGRectMake(kScreen_Width, kScreen_Height, 0, 0);
    
    [super viewDidLoad];
    UIButton *addbtn=[[UIButton alloc] init];
    [addbtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    addbtn.frame=CGRectMake(24, 24, self.tableView.bounds.size.width-30, 1200);
    [addbtn addTarget:self action:@selector(addnote) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addbtn];
    
//    UIBarButtonItem *addbtn1 = [[UIBarButtonItem alloc]initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addnote)];
//    self.navigationItem.rightBarButtonItem = addbtn1;
    self.navigationItem.title = @"Simple Notes";
    bar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    searchDispCtrl = [[UISearchDisplayController alloc]initWithSearchBar:bar contentsController:self];
    searchDispCtrl.delegate = self;
    searchDispCtrl.searchResultsDataSource = self;
    searchDispCtrl.searchResultsDelegate = self;
    self.tableView.tableHeaderView = bar;
        [self.tableView registerNib:[UINib nibWithNibName:@"MyCell" bundle:nil] forCellReuseIdentifier:@"MyCell"];
    [self.view addSubview:_tableView];
    
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
    if (charnum < 22) {
        cell.contentLB.text = note;
    }
    else{
        cell.contentLB.text = [[note substringToIndex:18] stringByAppendingString:@"..."];
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

#pragma mark uisearchdisplaydelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [filteredNoteArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchString];
    NSArray *tempArray = [noteArray filteredArrayUsingPredicate:predicate];
    filteredNoteArray = [NSMutableArray arrayWithArray:tempArray];

    return YES;
}

@end
