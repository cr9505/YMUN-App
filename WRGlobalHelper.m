//
//  WRGlobalHelper.m
//  WifiReporter
//
//  Created by Hengchu Zhang on 11/14/13.
//  Copyright (c) 2013 STC. All rights reserved.
//

#import "WRGlobalHelper.h"

@implementation WRGlobalHelper

+ (float)currentDeviceVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

@end
