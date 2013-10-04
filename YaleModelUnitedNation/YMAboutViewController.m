//
//  YMAboutViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 10/3/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMAboutViewController.h"
#import "UIBarButtonItem+buttonWithImage.h"

@interface YMAboutViewController ()

@end

@implementation YMAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)showLogin
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"about.png"] target:self action:@selector(showLogin)];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
