//
//  YMPostToForumViewController.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 11/27/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetController.h"

@interface YMPostToForumViewController : UIViewController

@property (nonatomic, strong) NSString *itemTitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *FTid;
@property (nonatomic) BOOL newTopic;

@end
