//
//  YMLoginViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/25/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMLoginViewController.h"
#import "YMAPIInterfaceCenter.h"
#import "MMProgressHUD.h"
#import "MMProgressHUDOverlayView.h"
#import "YMAfterLoginInitialViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface YMLoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *emailAndPassword;
@property (nonatomic, strong) YMAPIInterfaceCenter *interfaceCenter;

@end

@implementation YMLoginViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"didLoginSegue"]) {
        YMAfterLoginInitialViewController *destinationVC = (YMAfterLoginInitialViewController *)segue.destinationViewController;
        destinationVC.interfaceCenter = self.interfaceCenter;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.interfaceCenter = [[YMAPIInterfaceCenter alloc] initWithEmail:[self.emailAndPassword objectForKey:@"email"] Password:[self.emailAndPassword objectForKey:@"password"]];
    
    // top margin for table view    
    UIEdgeInsets inset = UIEdgeInsetsMake(self.tableView.bounds.size.height/2 - 46 * 2, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    self.emailAndPassword = [NSMutableDictionary dictionary];
    
    // set observer for login notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:YMUNLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNetworkError:) name:YMUNNetworkErrorNotificatoin object:nil];
    
    // check whether we already have user info or not
    if ([YMAPIInterfaceCenter hasUserAccessToken]) {
        NSLog(@"we already got your info, no need to login");
        // test if API data is valid
        // if yes, go to the next page directly
        [self performSegueWithIdentifier:@"didLoginSegue" sender:self];
        // else
        // clear the userDefaults first then
        // make the user login again
    } else {
        NSLog(@"we don't have your info");
    }
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    
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
    return 2;
}

- (void)login
{
    [MMProgressHUD showWithTitle:@"Hi there!" status:@"Logging you in!"];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *hostingCell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hostingCell];
    if (indexPath.row == 0) {
        if (textField.text) [self.emailAndPassword setObject:textField.text forKey:@"email"];
        [textField resignFirstResponder];
    } else {
        if (textField.text) [self.emailAndPassword setObject:textField.text forKey:@"password"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITableViewCell *hostingCell = (UITableViewCell *)textField.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:hostingCell];
    if (indexPath.row == 0) {
        [self.emailAndPassword setObject:textField.text forKey:@"email"];
        [textField resignFirstResponder];
        // make the password field first responder
        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        for (UIView *subview in nextCell.subviews)
        {
            if ([subview isKindOfClass:[UITextField class]]) {
                [(UITextField *)subview becomeFirstResponder];
            }
        }
    } else {
        [self.emailAndPassword setObject:textField.text forKey:@"password"];
        [self login];
    }
    return YES;
}

- (void)didReceiveNetworkError:(NSNotification *)notification
{
    [MMProgressHUD dismissWithError:@"Network Error. Please check your connection."];
}

- (void)didLogin:(NSNotification *)notification
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]);
    if (![[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]) {
        NSDictionary *userInfo = notification.userInfo;
        if ([[userInfo objectForKey:LOGIN_STATUS] isEqualToString:@"failure"])
        {
            dispatch_queue_t dismissQ = dispatch_queue_create("dismiss queue", NULL);
            dispatch_async(dismissQ, ^{
                sleep(1.0);
                [MMProgressHUD dismissWithError:@"Password/email error :(" title:@"Try again?"];
            });
        } else {
            dispatch_queue_t dismissQ = dispatch_queue_create("dismiss queue", NULL);
            dispatch_async(dismissQ, ^{
                sleep(1.0);
                [MMProgressHUD dismissWithSuccess:@"Awesome!"];
            });
            [self performSegueWithIdentifier:@"didLoginSegue" sender:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"loginCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    UITextField *cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    cellTextField.adjustsFontSizeToFitWidth = YES;
    cellTextField.textColor = [UIColor blackColor];

    if (indexPath.row == 0) {
        cellTextField.placeholder = @"Email";
        cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
        cellTextField.returnKeyType = UIReturnKeyNext;
    } else {
        cellTextField.placeholder = @"Required";
        cellTextField.keyboardType = UIKeyboardTypeDefault;
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.secureTextEntry = YES;
    }
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.textAlignment = NSTextAlignmentLeft;
    cellTextField.tag = 0;
    cellTextField.clearButtonMode = UITextFieldViewModeNever;
    cellTextField.enabled = YES;
    cellTextField.delegate = self;
    [cell addSubview:cellTextField];    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Email";
    } else {
        cell.textLabel.text = @"Password";
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

@end
