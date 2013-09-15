//
//  Transaction+Create.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "Transaction+Create.h"

@implementation Transaction (Create)

+ (Transaction *)createTransactionWithName:(NSString *)name transactionId:(NSNumber *)transactionID amount:(NSNumber *)amount date:(NSDate *)date type:(NSString *)type
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@ AND type == %@", transactionID, type];
    Transaction *transactionFound = [Transaction MR_findFirstWithPredicate:predicate inContext:context];
    
    if (!transactionFound) {
        Transaction *transaction = [Transaction MR_createInContext:context];
        transaction.name = name;
        transaction.id = transactionID;
        transaction.amount = amount;
        transaction.type = type;
        transaction.transactionDate = date;
        
        NSLog(@"%@", transaction);
        
        [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            if (!success) NSLog(@"%@", error.localizedDescription);
        }];
        
        return transaction;
    }
    return transactionFound;
}

@end
