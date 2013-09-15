//
//  UIBarButtonItem+buttonWithImage.m
//  WifiReporter
//
//  Created by Hengchu Zhang on 7/19/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "UIBarButtonItem+buttonWithImage.h"

@implementation UIBarButtonItem (buttonWithImage)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0.5, 0.5)] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.width)];
    [buttonView addSubview:button];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonView];
    return barButtonItem;
}

@end
