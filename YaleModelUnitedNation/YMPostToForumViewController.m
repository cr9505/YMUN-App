//
//  YMPostToForumViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/27/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMPostToForumViewController.h"
#import "BZGFormField.h"
#import "YMAPIInterfaceCenter.h"
#import "MBProgressHUD.h"

@interface YMPostToForumViewController () <BZGFormFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet BZGFormField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation YMPostToForumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (![textField.text isEqualToString:@""])
    {
        [textField resignFirstResponder];
        [self.contentTextView becomeFirstResponder];
    }

    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.itemTitle = textField.text;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content = textView.text;
}

- (IBAction)cancelBtnPressed:(id)sender {
    [self dismissFormSheetControllerAnimated:YES completionHandler:NULL];
}

- (IBAction)postContent:(id)sender {
    [self.contentTextView resignFirstResponder];
    if (self.newTopic)
    {
        [YMAPIInterfaceCenter createNewTopicWithForumID:self.FTid content:self.content title:self.itemTitle];
    } else {
        [YMAPIInterfaceCenter replyToTopicWithTopicID:self.FTid content:self.content];
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"Posting...";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleField.textField.placeholder = @"title";
    [self.titleField setTextValidationBlock:^BOOL(NSString *text) {
        if ([text isEqualToString:@""]) return NO;
        return YES;
    }];
    self.titleField.delegate = self;
    self.contentTextView.delegate = self;
    self.contentTextView.layer.borderColor = [UIColor colorWithRed:125/255.0 green:185/255.0 blue:209/255.0 alpha:0.5].CGColor;
    self.contentTextView.layer.borderWidth = 1.0;
    self.contentTextView.layer.cornerRadius = 4;
    if (!self.newTopic)
    {
        self.titleField.textField.text = @"Reply";
        self.titleField.textField.enabled = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostToForum:) name:YMUNDidPostToForumNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNetworkError:) name:YMUNNetworkErrorNotificatoin object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveNetworkError:(NSNotification *)notification
{
    self.hud.labelText = @"check connection";
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissFormSheetControllerAnimated:YES completionHandler:NULL];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didPostToForum:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (![userInfo objectForKey:@"success"])
    {
        self.hud.labelText = @"failed to post";
    } else {
        self.hud.labelText = @"success!";
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        UIViewController *presentingVC = formSheetController.presentingViewController;
        if ([presentingVC respondsToSelector:@selector(refresh)])
        {
            [presentingVC performSelector:@selector(refresh) withObject:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
