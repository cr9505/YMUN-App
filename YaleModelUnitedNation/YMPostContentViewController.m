//
//  YMPostContentViewController.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/10/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMPostContentViewController.h"

@interface YMPostContentViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation YMPostContentViewController

@synthesize content = _content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"p6.png"]];
    UILabel *textView = [[UILabel alloc] init];
    textView.numberOfLines = 0;
    textView.font = [UIFont systemFontOfSize:14.0];
    textView.textColor = [UIColor blackColor];
    textView.backgroundColor = [UIColor clearColor];
    textView.text = self.content;
    textView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    CGSize size = [self.content sizeWithFont:[UIFont systemFontOfSize:14]
                      constrainedToSize:CGSizeMake(310, 8000)
                          lineBreakMode:NSLineBreakByWordWrapping];
    textView.frame = CGRectMake(5, 5, 310, size.height);
    [self.scrollView addSubview:textView];
    self.scrollView.contentSize = CGSizeMake(310, textView.frame.size.height + 100);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
