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

- (void)setupCreditsLabel
{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, self.view.bounds.size.width - 20, 405)];
    containerView.clipsToBounds = YES;
    UILabel *creditsLabel = [[UILabel alloc] initWithFrame:CGRectInset(containerView.bounds, 15, 10)];
    creditsLabel.numberOfLines = 0;
    creditsLabel.text = @"The developer would like to express his gratitude to Graham Kaemmer (CC '16) for providing the backend API from the YIRA website and Grace Chiang (CC '15) for providing him the opportunity to create this application.\n\nThis application uses AFNetworking, MBProgressHUD, RNFSideBar, DCIntrospect and MagicalRecord under their respective licenses.\n\nThis application also used glyph icons from the Noun Project. Here are the attributes to the designers of the glyph icons:\n\n - Information designed by Tobias F. Wolf from The Noun Project\n - Document designed by Pieter J. Smits from The Noun Project\n - Add Money designed by Hakan Yalcin from The Noun Project\n - Payment designed by Doug Cavendish from The Noun Project\n\nThis application is designed and created by Hengchu Zhang (CC '15) in New Haven, CT for YMUN.";
    creditsLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
    creditsLabel.textColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1.0];
    creditsLabel.backgroundColor = [UIColor clearColor];
    containerView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    [creditsLabel sizeToFit];
    containerView.layer.borderWidth = 1.0;
    containerView.layer.borderColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:0.3].CGColor;
    containerView.layer.cornerRadius = 2.0;
    [containerView addSubview:creditsLabel];
    [self.view addSubview:containerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCreditsLabel];
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
