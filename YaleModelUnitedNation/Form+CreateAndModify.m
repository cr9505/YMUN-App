//
//  Form+CreateAndModify.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "Form+CreateAndModify.h"

@implementation Form (CreateAndModify)

+ (void)createFormWithName:(NSString *)name formID:(NSNumber *)formID submitted:(NSNumber *)submitted dueDate:(NSDate *)dueDate
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", formID];
    Form *formFound = [Form MR_findFirstWithPredicate:predicate inContext:context];
    
    if (!formFound) {
        Form *form = [Form MR_createInContext:context];
        form.name = name;
        form.id = formID;
        form.submitted = submitted;
        form.dueDate = dueDate;
        
        NSLog(@"%@", form);
        
        [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (!success) NSLog(@"%@", error.localizedDescription);
        }];
    }
}

+ (void)modifySubmitted:(NSNumber *)submitted forFormWithID:(NSNumber *)formID
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", formID];
    Form *formFound = [Form MR_findFirstWithPredicate:predicate inContext:context];
    
    if (formFound) {
        formFound.submitted = submitted;
        [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (!success) NSLog(@"%@", error.localizedDescription);
        }];
    }
}

@end
