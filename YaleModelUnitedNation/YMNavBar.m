//
//  YMNavBar.m
//  YaleModelUnitedNation
//
//  Created by Hengchu Zhang on 9/14/13.
//  Copyright (c) 2013 edu.yale.hengchu. All rights reserved.
//

#import "YMNavBar.h"

@implementation YMNavBar

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBarStyle:UIBarStyleBlackOpaque];
    self.translucent = NO;
    NSMutableDictionary *textAttributes = [self.titleTextAttributes mutableCopy];
    [textAttributes setObject:UITextAttributeTextShadowOffset forKey:[NSValue valueWithUIOffset:UIOffsetZero]];
    self.titleTextAttributes = textAttributes;
}

- (void) drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"navBar.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
