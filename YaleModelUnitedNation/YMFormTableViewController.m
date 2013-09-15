//
//  YMFormTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMFormTableViewController.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import "Form+CreateAndModify.h"
#import "RNFrostedSidebar.h"
#import "YMAppDelegate.h"
#import "YMDateView.h"
#import "YMTransactinTableViewController.h"
#import "YMGeneralInfoTableViewController.h"

@interface YMFormTableViewController () <RNFrostedSidebarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *forms;
@property (nonatomic, weak) RNFrostedSidebar *sideBar;

@end

@implementation YMFormTableViewController

@synthesize forms = _forms;
@synthesize sideBar = _sideBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setForms:(NSArray *)forms
{
    if (_forms != forms) {
        _forms = forms;
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sideBar dismiss];
}

- (void)showMenu
{
    [self.sideBar show];
}

- (void)setupMenuBtn
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"menuBtn.png"] target:self action:@selector(showMenu)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *forms = [Form MR_findAll];
    forms = [forms sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate *date1 = [(Form *)obj1 dueDate];
        NSDate *date2 = [(Form *)obj2 dueDate];
        if ([date1 compare:date2] == NSOrderedAscending) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    forms = [forms sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *sub1 = [(Form *)obj1 submitted];
        NSNumber *sub2 = [(Form *)obj2 submitted];
        if ([sub1 compare:sub2] == NSOrderedAscending) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    self.forms = forms;
    // get sideBar
    self.sideBar = ((YMAppDelegate *)[UIApplication sharedApplication].delegate).sharedSideBar;
    self.sideBar.delegate = self;
    // setup dataSource and delegate for tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
    // setup the menuBtn
    [self setupMenuBtn];
    // setup title
    self.navigationItem.title = @"Forms";
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
    return [self.forms count];
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
    static NSString *CellIdentifier = @"formCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.indentationWidth = 90.0;
    
    Form *f = [self.forms objectAtIndex:indexPath.row];
    YMDateView *dateView = [[YMDateView alloc]initWithFrame:CGRectMake(20, 12, 60, 60) andDate:f.dueDate];
    [cell addSubview:dateView];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0];
    cell.textLabel.text = f.name;
    if ([f.submitted boolValue]) {
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0 green:166/255.0 blue:83/255.0 alpha:1.0]];
    } else {
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:237/255.0 green:29/255.0 blue:37/255.0 alpha:1.0]];
    }
    cell.detailTextLabel.text = ([f.submitted boolValue]) ? @"Submitted" : @"Not Submitted";
    return cell;
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

#pragma RNFrostedSideBar
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        // write code to push general info page
        NSArray *vcS = [self.navigationController viewControllers];
        if ([[vcS objectAtIndex:[vcS count]-2] isKindOfClass:[YMGeneralInfoTableViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        YMGeneralInfoTableViewController *generalInfoTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"generalInfoTableVC"];
        [self.navigationController pushViewController:generalInfoTableVC animated:YES];
    } else if (index == 1) {
        // write code to push forms page
        [self.sideBar dismiss];
    } else if (index == 2) {
        NSArray *vcS = [self.navigationController viewControllers];
        if ([[vcS objectAtIndex:[vcS count]-2] isKindOfClass:[YMTransactinTableViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        YMTransactinTableViewController *transacVC = [self.storyboard instantiateViewControllerWithIdentifier:@"transacVC"];
        [self.navigationController pushViewController:transacVC animated:YES];
    }
}

@end
