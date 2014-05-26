//
//  MainPageViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MainPageViewController.h"

@implementation MainPageViewController

@synthesize feedButton;
@synthesize appaImage;
@synthesize gamesButton;
@synthesize sleepButton;
@synthesize trashButton;

BOOL draggingFood = NO;
UIButton *wedgeButton;
NSArray *buttons;
UIImage *wedgeImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    buttons = [[NSArray alloc] initWithObjects: feedButton, gamesButton, sleepButton, trashButton, nil];
    wedgeButton = nil;
    wedgeImage = nil;
    
    [feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [feedButton addTarget:self action:@selector(checkcheck) forControlEvents:UIControlEventAllTouchEvents];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"%@", NSStringFromCGPoint(touchLocation));
//    NSLog(@"%@",[touch.view class]);
//    NSLog(@"%@",wedgeButton);
//    NSLog(@"%f",wedgeButton.y);
//    if (draggingFood) {
//        [self toggleButtonsUserInteraction];
//        draggingFood = NO;
//    }
    
}


- (IBAction) foodImageMoved:(id) sender withEvent:(UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:11]) {
        draggingFood = YES;
//        [self toggleButtonsUserInteraction];
        for (UIView *subview in [self.view subviews]) {
            if (![subview isKindOfClass:[UIButton class]] ) {
                //do your code
//            NSLog(@"%@",subview);
//            NSLog(@"%hhd",subview.userInteractionEnabled);
            }
        }

        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        
        wedgeButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        
        wedgeButton.tag = 11;

        wedgeImage = [[UIImage alloc] initWithCGImage:[[UIImage imageNamed:@"watermelon-wedge"] CGImage]];
        
        
        [wedgeButton setImage:wedgeImage forState:UIControlStateNormal];
        [wedgeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
//        [wedgeButton addTarget:self action:@selector(checkcheck) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:wedgeButton];
    }
    NSLog(@"%@ --- %@", sender, wedgeButton);
    
    [self.view viewWithTag:11].center = point;
}
-(void) checkcheck {
    NSLog(@"HERE WE ARE");
}

-(void) toggleButtonsUserInteraction {
    for (UIButton *b in buttons) {
        if (b.userInteractionEnabled) {
            b.userInteractionEnabled = NO;
        }
        else {
            b.userInteractionEnabled = YES;
        }
    }
}

- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIControl *control = sender;
    control.center = point;
}

-(IBAction)checkForMouth:(id)sender withEvent:(UIEvent *) event {
//    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    NSLog(@"ended...");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
