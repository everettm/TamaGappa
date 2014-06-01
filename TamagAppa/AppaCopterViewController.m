//
//  AppaCopterViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/28/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "AppaCopterViewController.h"

@interface AppaCopterViewController (){
    int animateHelper;
}

@end

@implementation AppaCopterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    animateHelper = 1;
    [self performSelectorInBackground:@selector(constantlyAnimate) withObject:nil];
    //    [[FlyingAppa alloc] initWithNothing];
    
}

-(void)constantlyAnimate{
    CGRect viewFrame = _flyingAppa.frame;
    while(true){
        viewFrame.origin.x += animateHelper;
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             _flyingAppa.frame = viewFrame;
                         }
                         completion:^(BOOL finished){}];
    }
}

//-(void)flyUp{
//    animateHelper = 1;
//    if (_theMagicButton.state == UIGestureRecognizerStateEnded) {
//        NSLog(@"Button is released?");
//        animateHelper = -1;
//    }
//}

- (IBAction)flyUp:(id)sender {
    animateHelper = 1;
    if (_theMagicButton.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Button is released?");
        animateHelper = -1;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
