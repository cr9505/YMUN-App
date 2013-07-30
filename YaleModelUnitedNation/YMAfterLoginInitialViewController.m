//
//  YMAfterLoginInitialViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/30/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMAfterLoginInitialViewController.h"
#import "PaperFoldView.h"
#import "YMAPIInterfaceCenter.h"

@interface YMAfterLoginInitialViewController () <UITableViewDataSource, UITableViewDelegate, PaperFoldViewDelegate>

@property (nonatomic, strong) PaperFoldView *paperView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) UITableView *leftTableView;

@end

@implementation YMAfterLoginInitialViewController

@synthesize paperView = _paperView;
@synthesize centerTableView = _centerTableView;
@synthesize leftTableView = _leftTableView;
@synthesize userInfo = _userInfo;

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
    NSLog(@"%@", self.userInfo);
    [self setupPaperView];
    [self setupCenterView];
    [self setupLeftView];
}

- (void)setupLeftView
{
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];;
    [self.paperView setLeftFoldContentView:self.leftTableView foldCount:3 pullFactor:0.9];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeDidHappen:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.leftTableView addGestureRecognizer:leftSwipeGestureRecognizer];
}

- (void)leftSwipeDidHappen:(UISwipeGestureRecognizer *)gesture
{
    [self.paperView setPaperFoldState:PaperFoldStateDefault animated:YES];
}

- (void)setupPaperView
{
    self.paperView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.paperView.delegate = self;
    [self.paperView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.paperView];
}

- (void)setupCenterView
{
    self.centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.centerTableView setRowHeight:self.view.bounds.size.height/3.0];
    [self.paperView setCenterContentView:self.centerTableView];
    self.centerTableView.delegate = self;
    self.centerTableView.dataSource = self;
    self.centerTableView.scrollEnabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.centerTableView) {
        return 3;
    } else if (tableView == self.leftTableView) {
        return [[(NSDictionary *)self.userInfo objectForKey:PAYMENTS] count];
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == self.centerTableView) {
        if (indexPath.row == 0) [cell.textLabel setText:@"General Infomation"];
        if (indexPath.row == 1) [cell.textLabel setText:@"Purchase History"];
        if (indexPath.row == 2) [cell.textLabel setText:@"Payment History"];
    } else if (tableView == self.leftTableView) {
        cell.textLabel.text = @"Test";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.centerTableView) {
        if (indexPath.row == 1) {
            [self.paperView setPaperFoldState:PaperFoldStateLeftUnfolded animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
