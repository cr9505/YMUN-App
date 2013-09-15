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
#import "RNFrostedSidebar.h"
#import "YMAppDelegate.h"
#import "YMTransactinTableViewController.h"
#import "Transaction+Create.h"
#import "Form+CreateAndModify.h"
#import "NSString+Date.h"
#import <QuartzCore/QuartzCore.h>

@interface YMLoginViewController () <UITextFieldDelegate, RNFrostedSidebarDelegate>

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
    if ([segue.identifier isEqualToString:@"transactionSegue"]) {
        YMTransactinTableViewController *destinationVC = (YMTransactinTableViewController *)segue.destinationViewController;
        destinationVC.interfaceCenter = self.interfaceCenter;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // check whether we already have user info or not
    if ([YMAPIInterfaceCenter hasUserAccessToken]) {
        NSLog(@"we already got your info, no need to login");
        // test if API data is valid
        // if yes, go to the next page directly
        [YMAPIInterfaceCenter getUserInfo];
        [MMProgressHUD showWithTitle:@"Loading Data" status:@"Please wait..."];
        // else
        // clear the userDefaults first then
        // make the user login again
    } else {
        NSLog(@"we don't have your info");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // top margin for table view    
    UIEdgeInsets inset = UIEdgeInsetsMake(self.tableView.bounds.size.height/2 - 46*3, 0, 0, 0);
    self.tableView.contentInset = inset;
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbg.png"]];
    [bgImageV setFrame:self.tableView.frame];
    [bgImageV setAlpha:0.9];
    self.tableView.backgroundView = bgImageV;
    
    self.emailAndPassword = [NSMutableDictionary dictionary];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    
    // set observer for login notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:YMUNLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:) name:YMUNDidGetUserInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNetworkError:) name:YMUNNetworkErrorNotificatoin object:nil];
    
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
    self.interfaceCenter = [[YMAPIInterfaceCenter alloc] initWithEmail:[self.emailAndPassword objectForKey:@"email"] Password:[self.emailAndPassword objectForKey:@"password"]];
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
    [self performSegueWithIdentifier:@"generalInfoSegue" sender:self];
}

- (NSDate *)getDateFromUserInfo:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *result = [dateFormatter dateFromString:dateString];
    return result;
}

- (void)saveGeneralInfoToUserDefault:(NSDictionary *)info
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[info objectForKey:ADVISOR_COUNT] forKey:ADVISOR_COUNT];
    [defaults setObject:[info objectForKey:DELEGATE_COUNT] forKey:DELEGATE_COUNT];
    [defaults setObject:[info objectForKey:USER_NAME] forKey:USER_NAME];
    [defaults setObject:[info objectForKey:HOTEL] forKey:HOTEL];
    [defaults setObject:[info objectForKey:PAID_DEPOSIT] forKey:PAID_DEPOSIT];
    [defaults setObject:[info objectForKey:SCHOOL_NAME] forKey:SCHOOL_NAME];
    [defaults synchronize];
}

- (void)didGetUserInfo:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if ([YMAPIInterfaceCenter validateUserInfo:userInfo]) {
        for (NSDictionary *purchase in [userInfo objectForKey:PURCHASES]) {
            [Transaction createTransactionWithName:[purchase objectForKey:NAME] transactionId:[purchase objectForKey:ID] amount:[purchase objectForKey:AMOUNT] date:[NSString getDateFromUserInfo:[purchase objectForKey:DATE]] type:PURCHASES];
            
        }
        for (NSDictionary *payment in [userInfo objectForKey:PAYMENTS]) {
            [Transaction createTransactionWithName:[payment objectForKey:NAME] transactionId:[payment objectForKey:ID] amount:[payment objectForKey:AMOUNT] date:[NSString getDateFromUserInfo:[payment objectForKey:DATE]] type:PAYMENTS];
        }
        for (NSDictionary *form in [userInfo objectForKey:FORMS]) {
            [Form createFormWithName:[form objectForKey:NAME] formID:[form objectForKey:ID] submitted:[NSNumber numberWithBool:[[form objectForKey:SUBMITTED] boolValue]] dueDate:[NSString getDateFromUserInfo:[form objectForKey:DUEDATE]]];
            [Form modifySubmitted:[NSNumber numberWithBool:[[form objectForKey:SUBMITTED] boolValue]] forFormWithID:[form objectForKey:ID]];
        }
        [self saveGeneralInfoToUserDefault:notification.userInfo];
        [MMProgressHUD dismissWithSuccess:@"Success!"];
        [self performSegueWithIdentifier:@"generalInfoSegue" sender:self];
    } else {
        [MMProgressHUD dismissWithError:@"Incorrect information loaded!"];
    }
#warning need to set up new segue

}   

- (void)didLogin:(NSNotification *)notification
{
    NSLog(@"received login notification!");
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]);
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:LOGIN_STATUS] isEqualToString:@"failure"])
    {
        sleep(1.0);
        [MMProgressHUD dismissWithError:@"Password/email error :(" title:@"Try again?"];
    } else {
        sleep(1.0);
        [MMProgressHUD dismissWithSuccess:@"Awesome!"];
        [YMAPIInterfaceCenter getUserInfo];
        [MMProgressHUD showWithTitle:@"Loading Data" status:@"Please wait..."];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];

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
    NSString *placeHolderText;
    if (indexPath.row == 0) {
        placeHolderText = @"Email";
        cellTextField.keyboardType = UIKeyboardTypeEmailAddress;
        cellTextField.returnKeyType = UIReturnKeyNext;
    } else {
        placeHolderText = @"Required";
        cellTextField.keyboardType = UIKeyboardTypeDefault;
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.secureTextEntry = YES;
    }
    cellTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderText attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.textAlignment = NSTextAlignmentLeft;
    cellTextField.tag = 0;
    cellTextField.clearButtonMode = UITextFieldViewModeNever;
    cellTextField.enabled = YES;
    cellTextField.delegate = self;
    [cell addSubview:cellTextField];    
    
    cell.textLabel.backgroundColor =[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Email";
    } else {
        cell.textLabel.text = @"Password";
    }
    
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
