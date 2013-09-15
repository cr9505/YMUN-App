//
//  Transaction+Create.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/15/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "Transaction.h"

@interface Transaction (Create)

+ (void)createTransactionWithName:(NSString *)name transactionId:(NSNumber *)transactionID amount:(NSNumber *)amount date:(NSDate *)date type:(NSString *)type;

@end
