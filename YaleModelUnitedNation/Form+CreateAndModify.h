//
//  Form+CreateAndModify.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "Form.h"

@interface Form (CreateAndModify)

+ (void)createFormWithName:(NSString *)name formID:(NSNumber *)formID submitted:(NSNumber *)submitted dueDate:(NSDate *)dueDate;
+ (void)modifySubmitted:(NSNumber *)submitted forFormWithID:(NSNumber *)formID;

@end
