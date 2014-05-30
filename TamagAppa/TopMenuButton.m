//
//  TopMenuButton.m
//  TamagAppa
//
//  Created by Lab User on 5/29/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "TopMenuButton.h"

@implementation TopMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = (__bridge CGColorRef)([UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]);
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.5;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
