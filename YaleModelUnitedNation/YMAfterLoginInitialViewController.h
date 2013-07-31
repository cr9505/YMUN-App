//
//  YMAfterLoginInitialViewController.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/30/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAPIInterfaceCenter.h"
#import "ECSlidingViewController.h"

@interface YMAfterLoginInitialViewController : UIViewController <YMAPIInterfaceCenterDelegate>

@property (nonatomic, strong) YMAPIInterfaceCenter *interfaceCenter;

@end
