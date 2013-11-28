//
//  YMTopicTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/10/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMTopicTableViewController.h"
#import "YMAPIInterfaceCenter.h"
#import "YMPostsTableViewController.h"

@interface YMTopicTableViewController ()

@end

@implementation YMTopicTableViewController

@synthesize forumID = _forumID;

- (void)refresh
{
    [YMAPIInterfaceCenter getTopicsWithForumID:self.forumID];
}

- (void)setForumID:(NSNumber *)forumID
{
    _forumID = forumID;
    [YMAPIInterfaceCenter getTopicsWithForumID:self.forumID];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YMAPIInterfaceCenter getTopicsWithForumID:self.forumID];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"topicCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *entry = [self.data objectAtIndex:indexPath.row];
    // Configure the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    cell.textLabel.text = [entry objectForKey:@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ posts", [entry objectForKey:@"num_posts"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *entry = [self.data objectAtIndex:indexPath.row];
    NSNumber *topicID = [entry objectForKey:@"id"];
    YMPostsTableViewController *postVC = [self.storyboard instantiateViewControllerWithIdentifier:@"postVC"];
    postVC.topicID = topicID;
    [self.navigationController pushViewController:postVC animated:YES];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
