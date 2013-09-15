//
//  Form.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Form : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * submitted;

@end
