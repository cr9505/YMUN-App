//
//  UIBarButtonItem+buttonWithImage.h
//  WifiReporter
//
//  Created by Hengchu Zhang on 7/19/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (buttonWithImage)

+ (UIBarButtonItem *)barItemWithImage:(UIImage *)image target:(id)target action:(SEL)action;

@end
