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
#import "MMProgressHUD.h"
#import "YMDateView.h"
#import "YMMapTableViewCell.h"
#import <MapKit/MapKit.h>

@interface YMAfterLoginInitialViewController () <UITableViewDataSource, UITableViewDelegate, PaperFoldViewDelegate>

@property (nonatomic, strong) PaperFoldView *paperView;
@property (nonatomic, strong) UITableView *centerTableView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSArray *purchases;
@property (nonatomic, strong) NSArray *payments;

@end

@implementation YMAfterLoginInitialViewController

@synthesize paperView = _paperView;
@synthesize centerTableView = _centerTableView;
@synthesize leftTableView = _leftTableView;
@synthesize rightTableView = _rightTableView;
@synthesize topTableView = _topTableView;
@synthesize userInfo = _userInfo;
@synthesize purchases = _purchases;
@synthesize payments = _payments;
@synthesize topLabel = _topLabel;

- (void)setPayments:(NSArray *)payments
{
    if (_payments != payments) {
        _payments = payments;
        [self.rightTableView reloadData];
    }
}

- (void)setPurchases:(NSArray *)purchases
{
    if (_purchases != purchases) {
        _purchases = purchases;
        NSLog(@"%@", [[purchases objectAtIndex:0] objectForKey:AMOUNT]);
        [self.leftTableView reloadData];
    }
}

- (void)didGetUserInfo:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    self.userInfo = userInfo;
    NSLog(@"%@", userInfo);
    self.purchases = [self.userInfo objectForKey:PURCHASES];
    self.payments = [self.userInfo objectForKey:PAYMENTS];
    self.topLabel.text = [NSString stringWithFormat:@"Hi, %@", [self.userInfo objectForKey:USER_NAME]];
    [self.topTableView reloadData];
//    [MMProgressHUD dismissWithSuccess:@"Loaded!"];
}

- (void)updateMapView:(MKMapView *)mapView withPlaceMarks:(NSArray *)placemarks
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [MMProgressHUD showWithTitle:@"Loading" status:@"Please be patient" cancelBlock:^{
//        NSLog(@"User canceled ProgressHUD");
//    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:) name:YMUNDidGetUserInfoNotification object:nil];
	// Do any additional setup after loading the view.
    [YMAPIInterfaceCenter getUserInfo];
    [self setupPaperView];
    [self setupCenterView];
    [self setupLeftView];
    [self setupRightView];
    [self setupTopView];
    [self setupTopLabel];
}

- (void)setupTopLabel
{
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    self.topLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_pattern.png"]];
    self.topLabel.textColor = [UIColor darkGrayColor];
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = [self.topLabel.font fontWithSize:35.0];
    UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 1)];
    border.backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    [self.view addSubview:border];
    [self.view addSubview:self.topLabel];
}

- (void)setupTopView
{
    self.topTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    self.topTableView.delegate = self;
    self.topTableView.dataSource = self;
    self.topTableView.bounces = NO;
    [self.paperView setTopFoldContentView:self.topTableView topViewFoldCount:6 topViewPullFactor:0.9];
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDidHappen:)];
    [self.topTableView addGestureRecognizer:gesture];
    self.topTableView.tableFooterView = [[UIView alloc] init];
}

- (void)setupRightView
{
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80) style:UITableViewStyleGrouped];
    UIView *backView = [[UIView alloc] initWithFrame:self.leftTableView.frame];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_pattern.png"]];
    [self.rightTableView setBackgroundView:backView];
    [self.paperView setRightFoldContentView:self.rightTableView foldCount:3 pullFactor:0.9];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeDidHappen:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.rightTableView addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)setupLeftView
{
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80) style:UITableViewStyleGrouped];
    UIView *backView = [[UIView alloc] initWithFrame:self.leftTableView.frame];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_pattern.png"]];
    [self.leftTableView setBackgroundView:backView];
    [self.paperView setLeftFoldContentView:self.leftTableView foldCount:3 pullFactor:0.9];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    UISwipeGestureRecognizer *leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeDidHappen:)];
    leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.leftTableView addGestureRecognizer:leftSwipeGestureRecognizer];
}

- (void)rightSwipeDidHappen:(UISwipeGestureRecognizer *)gesture
{
    [self.paperView setPaperFoldState:PaperFoldStateDefault];
}

- (void)leftSwipeDidHappen:(UISwipeGestureRecognizer *)gesture
{
    [self.paperView setPaperFoldState:PaperFoldStateDefault];
}

- (void)pinchDidHappen:(UIPinchGestureRecognizer *)gesture
{
    [self.paperView setPaperFoldState:PaperFoldStateDefault];
}

- (void)setupPaperView
{
    self.paperView = [[PaperFoldView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.paperView.delegate = self;
    [self.paperView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:self.paperView];
}

- (void)setupCenterView
{
    self.centerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-80)];
    [self.paperView setCenterContentView:self.centerTableView];
    self.centerTableView.delegate = self;
    self.centerTableView.dataSource = self;
    self.centerTableView.bounces = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.centerTableView) {
        return 3;
    } else if (tableView == self.leftTableView) {
        return [self.purchases count];
    } else if (tableView == self.rightTableView) {
        return [self.payments count];
    } else if (tableView == self.topTableView) {
        return 6;
    }
    return 1;
}

- (NSString *)detailTextLabelForFinancialRecords:(NSArray *)records cellAtIndexPath:(NSIndexPath *)indexPath
{
    return  [NSString stringWithFormat:@"$%3.2f", [[[records objectAtIndex:indexPath.row] objectForKey:AMOUNT] doubleValue]];
}

- (NSDate *)getDateFromUserInfo:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:dateString];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }

    if (tableView == self.leftTableView || tableView == self.rightTableView) {
        cell.indentationLevel = 7;
        YMDateView *placeholder = nil;
        if (tableView == self.leftTableView) {
            placeholder =[[YMDateView alloc] initWithFrame:CGRectMake(20, 12, 60, 60) andDate: [self getDateFromUserInfo:[[self.purchases objectAtIndex:indexPath.row] objectForKey:DATE]]];
        }
        if (tableView == self.rightTableView) {
            placeholder =[[YMDateView alloc] initWithFrame:CGRectMake(20, 12, 60, 60) andDate: [self getDateFromUserInfo:[[self.payments objectAtIndex:indexPath.row] objectForKey:DATE]]];
        }
        [cell addSubview:placeholder];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == self.centerTableView) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.indentationLevel = 6;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMidY(cell.frame) + 32/2, 32, 32)];
        [cell addSubview:imageView];
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"General Infomation"];
            imageView.image = [UIImage imageNamed:@"info.png"];
        }
        if (indexPath.row == 1) {
            [cell.textLabel setText:@"Purchase History"];
            imageView.image = [UIImage imageNamed:@"purchases.png"];
        }
        if (indexPath.row == 2) {
            [cell.textLabel setText:@"Payment History"];
            imageView.image = [UIImage imageNamed:@"payments.png"];
        }
    } else if (tableView == self.leftTableView) {
        cell.textLabel.text = [[self.purchases objectAtIndex:indexPath.row] objectForKey:NAME];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0 green:166/255.0 blue:83/255.0 alpha:1.0]];
        cell.detailTextLabel.text = [self detailTextLabelForFinancialRecords:self.purchases cellAtIndexPath:indexPath];
    } else if (tableView == self.rightTableView) {
        cell.textLabel.text = [[self.payments objectAtIndex:indexPath.row] objectForKey:NAME];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:237/255.0 green:29/255.0 blue:37/255.0 alpha:1.0]];
        cell.detailTextLabel.text = [self detailTextLabelForFinancialRecords:self.payments cellAtIndexPath:indexPath];
    } else if (tableView == self.topTableView) {
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
        cell.textLabel.textColor = [UIColor blackColor];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"Advisor Count";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.userInfo objectForKey:ADVISOR_COUNT]];
                break;
            case 1:
                cell.textLabel.text = @"Delegate Count";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.userInfo objectForKey:DELEGATE_COUNT]];
                break;
            case 2:
                cell.textLabel.text = @"Deposit";
                cell.detailTextLabel.text = ([self.userInfo objectForKey:PAID_DEPOSIT]) ? @"Received":@"Not received";
                break;
            case 3:
                cell.textLabel.text = @"School Name";
                cell.detailTextLabel.text = [self.userInfo objectForKey:SCHOOL_NAME];
                break;
            case 4:
                cell.textLabel.text = @"Forms";
                cell.detailTextLabel.text = ([self.userInfo objectForKey:SUBMITTED_FORM]) ? @"Submitted":@"Not submitted";
                break;
            case 5:
            {
                cell = [[YMMapTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
                cell.textLabel.text = @"Hotel";
                cell.detailTextLabel.text = [self.userInfo objectForKey:HOTEL];
                MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 55, self.view.bounds.size.width - 10 - 15, 260 - 30 - 40)];
                // implement the geocoder
                [cell addSubview:mapView];
                break;
            }
            default:
                break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.centerTableView) {
        return (self.view.bounds.size.height-80)/3.0;
    } else if (tableView == self.leftTableView || tableView == self.rightTableView) {
        return 80.0;
    } else { // topTableView
        if (indexPath.row != 5) {
            return 40.0;
        } else {
            return 260.0;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.centerTableView) {
        [tableView cellForRowAtIndexPath:indexPath].selected = NO;
        if (indexPath.row == 1) {
            [self.paperView setPaperFoldState:PaperFoldStateLeftUnfolded];
        } else if (indexPath.row == 2) {
            [self.paperView setPaperFoldState:PaperFoldStateRightUnfolded];
        } else if (indexPath.row == 0) {
            [self.paperView setPaperFoldState:PaperFoldStateTopUnfolded];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
}

- (void)paperFoldView:(id)paperFoldView didFoldAutomatically:(BOOL)automated toState:(PaperFoldState)paperFoldState
{
    if (paperFoldState == PaperFoldStateLeftUnfolded) {
        self.topLabel.text = @"Purchases";
    } else if (paperFoldState == PaperFoldStateRightUnfolded) {
        self.topLabel.text = @"Payments";
    } else if (paperFoldState == PaperFoldStateDefault) {
        self.topLabel.text = [NSString stringWithFormat:@"Hi, %@", [self.userInfo objectForKey:USER_NAME]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
