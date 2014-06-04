//
//  PetGestureRecognizer.m
//  TamagAppa
//
//  Created by Lab User on 6/4/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "PetGestureRecognizer.h"
#define SHOW printf("%s %d %d %d\n", __FUNCTION__, self.state, touches.count, self.numberOfTouches)

@interface PetGestureRecognizer () {
    int changedDirection;
    bool prevTouchWasOnLeftSide;
}
@end

@implementation PetGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action{
    if ((self = [super initWithTarget:target action:action])){
        changedDirection = 0;
        prevTouchWasOnLeftSide = nil;
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    SHOW;
    UITouch *touch = [touches anyObject];
    if ([touch locationInView:self.view].x < CGRectGetMidX(self.view.bounds)) prevTouchWasOnLeftSide = YES;
    else prevTouchWasOnLeftSide = NO;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    SHOW;
    UITouch *touch = [touches anyObject];
    if([touch locationInView:self.view].x < CGRectGetMidX(self.view.bounds)) {
        if (!prevTouchWasOnLeftSide) {
            changedDirection +=1;
        }
        prevTouchWasOnLeftSide = YES;
    }
    else {
        if (prevTouchWasOnLeftSide) {
            changedDirection +=1;
        }
        prevTouchWasOnLeftSide = NO;
    }
    if (!CGRectContainsPoint(self.view.bounds, [touch locationInView:self.view])) {
        self.state = UIGestureRecognizerStateCancelled;
    }
    else if (changedDirection > 2) self.state = UIGestureRecognizerStateBegan;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    SHOW;
    self.state = UIGestureRecognizerStateEnded;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
//    SHOW;
    self.state = UIGestureRecognizerStateCancelled;
}
-(void)reset{
    prevTouchWasOnLeftSide = nil;
    changedDirection = 0;
}

@end
