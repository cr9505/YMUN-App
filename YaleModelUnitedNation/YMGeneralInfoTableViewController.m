//
//  YMGeneralInfoTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMGeneralInfoTableViewController.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import "RNFrostedSidebar.h"
#import "YMAppDelegate.h"
#import "YMTransactinTableViewController.h"
#import "YMFormTableViewController.h"
#import "YMMapTableViewCell.h"
#import <MapKit/MapKit.h>

@interface YMGeneralInfoTableViewController () <RNFrostedSidebarDelegate>

@property (nonatomic, strong) RNFrostedSidebar *sideBar;

@end

@implementation YMGeneralInfoTableViewController

@synthesize sideBar = _sideBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showMenu
{
    [self.sideBar show];
}

- (void)setupMenuBtn
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"menuBtn.png"] target:self action:@selector(showMenu)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.sideBar dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // get sidebar
    self.sideBar = [(YMAppDelegate *)[UIApplication sharedApplication].delegate sharedSideBar];
    self.sideBar.delegate = self;
    //set title
    self.navigationItem.title = @"Information";
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
    [self setupMenuBtn];
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
    return 5;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 4) {
        return 40.0;
    } else {
        return 268.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"generalInfoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    cell.textLabel.textColor = [UIColor blackColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Advisor Count";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:ADVISOR_COUNT]];
            break;
        case 1:
            cell.textLabel.text = @"Delegate Count";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:DELEGATE_COUNT]];
            break;
        case 2:
            cell.textLabel.text = @"Deposit";
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:PAID_DEPOSIT] boolValue]) {
                cell.detailTextLabel.textColor = [UIColor colorWithRed:237/255.0 green:29/255.0 blue:37/255.0 alpha:1.0];
            } else {
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            cell.detailTextLabel.text = ([[[NSUserDefaults standardUserDefaults] objectForKey:PAID_DEPOSIT] boolValue]) ? @"Received":@"Not received";
            break;
        case 3:
            cell.textLabel.text = @"School Name";
            cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:SCHOOL_NAME];
            break;
        case 4:
        {
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 3, 42, 15)];
            textLabel.backgroundColor = [UIColor clearColor];
            UILabel *detailedTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, self.tableView.bounds.size.width - 10 - 15, 18)];
            textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
            textLabel.text = @"Hotel";
            detailedTextLabel.backgroundColor = [UIColor clearColor];
            detailedTextLabel.textColor = [UIColor grayColor];
            detailedTextLabel.font = [UIFont systemFontOfSize:14.0];
            detailedTextLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:HOTEL];
            [cell.contentView addSubview:textLabel];
            [cell.contentView addSubview:detailedTextLabel];
            MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(10, 45, self.tableView.bounds.size.width - 10 - 15, 260 - 30 - 40 + 20)];
            // implement the geocoder
            [cell addSubview:mapView];
            break;
        }
        default:
            break;
    }
    
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

#pragma RNFrostedSideBar delegate
- (void)sidebar:(RNFrostedSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index
{
    if (index == 0) {
        [self.sideBar dismiss];
    } else if (index == 1) {
        // write code to push forms page
        NSArray *vcS = [self.navigationController viewControllers];
        if ([[vcS objectAtIndex:[vcS count]-2] isKindOfClass:[YMFormTableViewController class]]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        YMFormTableViewController *formTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"formTableVC"];
        [self.navigationController pushViewController:formTableVC animated:YES];
        
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
