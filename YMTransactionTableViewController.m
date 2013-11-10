//
//  YMTransactinTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/14/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMTransactionTableViewController.h"
#import "YMFormTableViewController.h"
#import "YMAppDelegate.h"
#import "RNFrostedSidebar.h"
#import "YMDateView.h"
#import "Transaction+Create.h"
#import "NSString+Date.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import "YMGeneralInfoTableViewController.h"
#import "YMForumTableViewController.h"
#import "MBProgressHUD.h"

@interface YMTransactionTableViewController () <UITableViewDataSource, UITableViewDelegate, RNFrostedSidebarDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) RNFrostedSidebar *sideBar;
@property (nonatomic, strong) NSArray *transactions;
@end

@implementation YMTransactionTableViewController

@synthesize sideBar = _sideBar;
@synthesize transactions = _transactions;
@synthesize interfaceCenter = _interfaceCenter;
@synthesize tableView = _tableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTransactions:(NSArray *)transactions
{
    if (_transactions != transactions) {
        _transactions = transactions;
        [self.tableView reloadData];
    }
}

- (void)setupSideBar
{
    // get the side bar
    self.sideBar = [(YMAppDelegate *)[UIApplication sharedApplication].delegate sharedSideBar];
    self.sideBar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupSideBar];
}

- (void)didGetUserInfo:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (![YMAPIInterfaceCenter validateUserInfo:userInfo]) {
//        [MMProgressHUD dismissWithError:@"Incorrect information loaded!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    } else {
//        [MMProgressHUD dismissWithSuccess:@"Loaded!"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    NSArray *transac = [[userInfo objectForKey:PAYMENTS] arrayByAddingObjectsFromArray:[userInfo objectForKey:PURCHASES]];
    transac = [transac sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [NSString getDateFromUserInfo:[obj1 objectForKey:DATE]];
        NSDate *date2 = [NSString getDateFromUserInfo:[obj2 objectForKey:DATE]];
        if ([date1 compare:date2]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    [self setTransactions:transac];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup sideBar
    [self setupSideBar];
    // sign up for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:) name:YMUNDidGetUserInfoNotification object:nil];
    // get all transactions
    NSArray *transactions = [Transaction MR_findAll];
    self.transactions = [transactions sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = ((Transaction *)obj1).transactionDate;
        NSDate *date2 = ((Transaction *)obj2).transactionDate;
        if ([date1 compare:date2] == NSOrderedAscending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.transactions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"transactionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.indentationWidth = 90.0;
    Transaction *transaction = [self.transactions objectAtIndex:indexPath.row];
    YMDateView *dateView = [[YMDateView alloc] initWithFrame:CGRectMake(20, 12, 60, 60) andDate:transaction.transactionDate];
    [cell addSubview:dateView];
    cell.textLabel.text = transaction.name;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    if ([transaction.type isEqualToString:PAYMENTS]) {
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0 green:166/255.0 blue:83/255.0 alpha:1.0]];
    } else {
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:237/255.0 green:29/255.0 blue:37/255.0 alpha:1.0]];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"$%3.2f", [transaction.amount doubleValue]];
    return cell;
}

- (NSString *)detailTextLabelForFinancialRecords:(NSArray *)records cellAtIndexPath:(NSIndexPath *)indexPath
{
    return  [NSString stringWithFormat:@"$%3.2f", [[[records objectAtIndex:indexPath.row] objectForKey:AMOUNT] doubleValue]];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma RNFrostedSideBarDelegateMethods
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        // write code to push general info page
        YMGeneralInfoTableViewController *generalInfoTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"generalInfoTableVC"];
        [self.navigationController pushViewController:generalInfoTableVC animated:YES];
    } else if (index == 1) {
        // write code to push forms page
        YMFormTableViewController *formTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"formTableVC"];
        [self.navigationController pushViewController:formTableVC animated:YES];
        
    } else if (index == 2) {
        [self.sideBar dismiss];
    } else if (index == 3) {
        YMForumTableViewController *forumVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forumVC"];
        [self.navigationController pushViewController:forumVC animated:YES];
        [self.sideBar dismiss];
    }
}
@end
