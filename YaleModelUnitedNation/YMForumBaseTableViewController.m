//
//  YMForumBaseTableViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/10/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMForumBaseTableViewController.h"
#import "YMAPIInterfaceCenter.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import "WRGlobalHelper.h"
#import "YMTopicTableViewController.h"
#import "YMPostsTableViewController.h"
#import "YMPostToForumViewController.h"

@interface YMForumBaseTableViewController ()
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation YMForumBaseTableViewController

@synthesize data = _data;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setData:(id)data
{
    if (data != _data)
    {
        _data = data;
        [self.tableView reloadData];
    }
}

- (void)logout
{
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                          message:@"Would you like to log out?"
                                                         delegate:self
                                                cancelButtonTitle:@"cancel"
                                                otherButtonTitles:@"Yes", nil];
    [logoutAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [YMAPIInterfaceCenter destroySession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
   
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
    if ([self class] == [YMTopicTableViewController class] || [self class] == [YMPostsTableViewController class])
    {
        [self setupMenuBtn];
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],UITextAttributeTextColor,
                                nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attributes
                                                forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetForumInfo:) name:YMUNDidGetForumInfoNotification object:nil];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

- (void)didGetForumInfo:(NSNotification *)notification
{
    id userInfo = notification.userInfo;
    self.data = userInfo;
    [self.refreshControl endRefreshing];
}

- (void)setupMenuBtn
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"speech.png"] target:self action:@selector(postContentToForum)];
}

- (void)postContentToForum
{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"postToForum"];
    if ([self class] == [YMTopicTableViewController class])
    {
        [(YMPostToForumViewController *)vc setNewTopic:YES];
        [(YMPostToForumViewController *)vc setFTid:[(YMTopicTableViewController *)self forumID]];
    } else if ([self class] == [YMPostsTableViewController class])
    {
                [(YMPostToForumViewController *)vc setFTid:[(YMPostsTableViewController *)self topicID]];
    }
    [self presentFormSheetWithViewController:vc animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        //
    }];
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
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
