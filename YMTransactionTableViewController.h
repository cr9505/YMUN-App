//
//  YMTransactinTableViewController.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/14/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMAPIInterfaceCenter.h"
#import "YMBaseTableViewController.h"

@interface YMTransactionTableViewController : YMBaseTableViewController
@property (nonatomic, strong) YMAPIInterfaceCenter *interfaceCenter;
@end
