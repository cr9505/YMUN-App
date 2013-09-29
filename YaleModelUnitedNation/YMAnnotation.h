//
//  YMAnnotation.h
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/28/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface YMAnnotation : NSObject <MKAnnotation>


@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                    title:(NSString *)title
                 subtitle:(NSString *)subtitle;

@end
