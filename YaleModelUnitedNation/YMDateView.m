//
//  YMDateView.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 7/31/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMDateView.h"
#import <QuartzCore/QuartzCore.h>

@interface YMDateView()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UIView *smallTriangleView;

@end

@implementation YMDateView

@synthesize date = _date;
@synthesize monthLabel = _monthLabel;
@synthesize dayLabel = _dayLabel;
@synthesize smallTriangleView = _smallTriangleView;

- (id)initWithFrame:(CGRect)frame andDate:(NSDate *)date
{
    self = [super initWithFrame:frame];
    if (self) {
        self.date = date;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20)];
    self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, self.bounds.size.height - 20)];
    self.monthLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:118/255.0 blue:166/255.0 alpha:1.0];
    // get date and month
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSDayCalendarUnit | NSMonthCalendarUnit fromDate:self.date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    self.dayLabel.backgroundColor = [UIColor clearColor];
    // cosmetics for month label
    self.monthLabel.layer.cornerRadius = 2.0f;
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.adjustsFontSizeToFitWidth = YES;
    self.monthLabel.textColor = [UIColor whiteColor];
    self.monthLabel.text = [[[[NSDateFormatter alloc]init] monthSymbols] objectAtIndex:month-1];
    // cosmetics for day label
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.dayLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:30.0];
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", (long)day];
    [self addSubview:self.monthLabel];
    [self addSubview:self.dayLabel];
}


//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextBeginPath(context);
//    CGContextMoveToPoint(context, 30 - 5.0, 20);
//    CGContextAddLineToPoint(context, 30 + 5.0, 20);
//    CGContextAddLineToPoint(context, 30, 20 + 4.0);
//    CGContextAddLineToPoint(context, 30 - 5.0, 20);
//    CGContextSetRGBFillColor(context, 0, 118/255.0, 166/255.0, 1.0);
//    CGContextFillPath(context);
//}

@end
