//
//  YMAnnotation.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/28/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMAnnotation.h"

@implementation YMAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                    title:(NSString *)title
                 subtitle:(NSString *)subtitle
{
    self = [super init];
    if (self)
    {
        _coordinate = location;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end
