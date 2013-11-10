//
//  YMLoginViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/25/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMLoginViewController.h"
#import "YMAPIInterfaceCenter.h"
#import "MBProgressHUD.h"
#import "YMAfterLoginInitialViewController.h"
#import "RNFrostedSidebar.h"
#import "YMAppDelegate.h"
#import "YMTransactionTableViewController.h"
#import "Transaction+Create.h"
#import "Form+CreateAndModify.h"
#import "NSString+Date.h"
#import "UIBarButtonItem+buttonWithImage.h"
#import <QuartzCore/QuartzCore.h>

@interface YMLoginViewController () <UITextFieldDelegate, RNFrostedSidebarDelegate>

@property (nonatomic, strong) NSMutableDictionary *emailAndPassword;
@property (nonatomic, strong) YMAPIInterfaceCenter *interfaceCenter;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, weak) UITableViewCell *emailCell;
@property (nonatomic, weak) UITableViewCell *passwordCell;
@property (nonatomic, strong) UITextField *emailField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation YMLoginViewController


@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;

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
        YMTransactionTableViewController *destinationVC = (YMTransactionTableViewController *)segue.destinationViewController;
        destinationVC.interfaceCenter = self.interfaceCenter;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // check whether we already have user info or not
    if ([YMAPIInterfaceCenter hasUserAccessToken]) {
        DLog(@"we already got your info, no need to login");
        // test if API data is valid
        // if yes, go to the next page directly
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"Loading Data";
        [YMAPIInterfaceCenter getUserInfo];

        // else
        // clear the userDefaults first then
        // make the user login again
    } else {
        DLog(@"we don't have your info");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // top margin for table view    
    UIEdgeInsets inset = UIEdgeInsetsMake(self.tableView.bounds.size.height/2 - 46*4, 0, 0, 0);
    self.tableView.contentInset = inset;
    UIImageView *bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginbg.png"]];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [bgImageV setFrame:self.tableView.frame];
    } else {
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        [bgImageV setFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width, self.view.frame.size.height - statusBarHeight)];
    }
    [bgImageV setAlpha:0.9];
    self.tableView.backgroundView = bgImageV;
    
    self.emailAndPassword = [NSMutableDictionary dictionary];
        
    // set observer for login notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogin:) name:YMUNLoginStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUserInfo:) name:YMUNDidGetUserInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNetworkError:) name:YMUNNetworkErrorNotificatoin object:nil];
    
    // set up about page
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"about.png"] target:self action:@selector(showAbout)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)showAbout
{
    UINavigationController *aboutNav = [self.storyboard instantiateViewControllerWithIdentifier:@"aboutNav"];
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:aboutNav animated:YES completion:NULL];
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
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Hi there!";
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
    if (textField == self.emailField) {
        [self.emailAndPassword setObject:textField.text forKey:@"email"];
        [textField resignFirstResponder];
        // make the password field first responder
        [self.passwordField becomeFirstResponder];
    } else {
        [self.emailAndPassword setObject:textField.text forKey:@"password"];
        [self login];
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveNetworkError:(NSNotification *)notification
{
    
    if ([YMAPIInterfaceCenter hasUserAccessToken]) {
        [self performSegueWithIdentifier:@"generalInfoSegue" sender:self];
    }
    self.hud.labelText = @"Network Error. Please check your connection.";
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    BOOL isDelegate = [[info objectForKey:IS_DELEGATE] boolValue];
    [defaults setObject:[info objectForKey:IS_DELEGATE] forKey:IS_DELEGATE];
    NSString *schooleName = [info objectForKey:SCHOOL_NAME];
    if ([schooleName isKindOfClass:[NSNull class]]) schooleName = @"NULL";
    [defaults setObject:schooleName forKey:SCHOOL_NAME];
    NSString *hotelName = [info objectForKey:HOTEL];
    if ([hotelName isKindOfClass:[NSNull class]]) hotelName = @"NULL";
    [defaults setObject:hotelName forKey:HOTEL];
    if (!isDelegate)
    {
        // data to save for non-delegates
        [defaults setObject:[info objectForKey:ADVISOR_COUNT] forKey:ADVISOR_COUNT];
        [defaults setObject:[info objectForKey:DELEGATE_COUNT] forKey:DELEGATE_COUNT];
        NSString *userName = [info objectForKey:USER_NAME];
        if ([userName isKindOfClass:[NSNull class]]) userName = @"NULL";
        [defaults setObject:userName forKey:USER_NAME];
        [defaults setObject:[info objectForKey:PAID_DEPOSIT] forKey:PAID_DEPOSIT];
    }
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
        BOOL isDelegate = [[notification.userInfo objectForKey:IS_DELEGATE] boolValue];
        if (isDelegate) {
            // perform segue into the delegate UI
            [self performSegueWithIdentifier:@"delegateGeneralInfo" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"generalInfoSegue" sender:self];
        }
        self.hud.labelText = @"Success";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else {
        self.hud.labelText = @"Pleas re-authenticate";
        [self.hud hide:YES afterDelay:0.5];
    }
}

- (void)hudTapped:(UIGestureRecognizer *)tap
{
    [self.hud hide:YES];
}

- (void)didLogin:(NSNotification *)notification
{
    DLog(@"received login notification!");
    DLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]);
    NSDictionary *userInfo = notification.userInfo;
    if ([[userInfo objectForKey:LOGIN_STATUS] isEqualToString:@"failure"])
    {
        sleep(1.0);
        self.hud.labelText = @"Password/email error";
        [self.hud hide:YES afterDelay:0.5];
    } else {
        sleep(1.0);
        self.hud.labelText = @"Awesome";
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.labelText = @"Loading Data";
        [YMAPIInterfaceCenter getUserInfo];
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
        self.emailField = cellTextField;
    } else {
        placeHolderText = @"Required";
        cellTextField.keyboardType = UIKeyboardTypeDefault;
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.secureTextEntry = YES;
        self.passwordField = cellTextField;
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

        self.emailCell = cell;
    } else {
        cell.textLabel.text = @"Password";
        self.passwordCell = cell;
    }
    
    return cell;
}

- (void)removeTextInCell:(UITableViewCell *)cell
{
    for (UIView *subview in cell.subviews)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            [(UITextField *)subview setText:@""];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSIndexPath *idx = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:idx];
    [self removeTextInCell:cell];
    idx = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:idx];
    [self removeTextInCell:cell];
    [super viewWillDisappear:animated];
    self.emailField.text = nil;
    self.passwordField.text = nil;
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
