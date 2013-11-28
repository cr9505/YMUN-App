//
//  YMPostsTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/10/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMPostsTableViewController.h"
#import "YMPostContentViewController.h"
#import "YMAPIInterfaceCenter.h"

@interface YMPostsTableViewController ()

@end

@implementation YMPostsTableViewController

@synthesize topicID = _topicID;

- (void)refresh
{
    [YMAPIInterfaceCenter getPostsWithTopicID:self.topicID];
}

- (void)setTopicID:(NSNumber *)topicID
{
    _topicID = topicID;
    [YMAPIInterfaceCenter getPostsWithTopicID:self.topicID];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [YMAPIInterfaceCenter getPostsWithTopicID:self.topicID];
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

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"postCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *entry = [self.data objectAtIndex:indexPath.row];
    // Configure the cell...
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    cell.textLabel.text = [entry objectForKey:@"name"];
    NSString *content = [entry objectForKey:@"content"];
    if ([content length] > 30)
    {
        content = [content substringToIndex:30];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ...", content];
    }
    else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", content];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *entry = [self.data objectAtIndex:indexPath.row];
    NSString *content = [entry objectForKey:@"content"];
    YMPostContentViewController *contentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"contentVC"];
    contentVC.content = content;
    [self.navigationController pushViewController:contentVC animated:YES];
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
