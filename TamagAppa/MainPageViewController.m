//
//  MainPageViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MainPageViewController.h"
#import "Appa.h"
#import "PetGestureRecognizer.h"
#import <QuartzCore/QuartzCore.h>

@interface MainPageViewController (){
    UIColor *skyColor;
    UIButton *wedgeButton;
    BOOL beingTickled;
    NSMutableDictionary *imageCache;
    NSMutableArray *buttonsToCleanUp;
    NSMutableArray *buttonsToCleanUpOriginalPoints;
}

@end

@implementation MainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    wedgeButton = nil;
    beingTickled = NO;
    skyColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    buttonsToCleanUp = [[NSMutableArray alloc] init];
    buttonsToCleanUpOriginalPoints = [[NSMutableArray alloc] init];
    
    [_statusButton addTarget:self action:@selector(statusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self setTopMenuButtonAttrs:_statusButton];

    [_feedButton addTarget:self action:@selector(feedButtonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_feedButton addTarget:self action:@selector(feedImageDragging:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_feedButton addTarget:self action:@selector(feedImageDragging:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_feedButton addTarget:self action:@selector(checkPhase:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    
    [_mainAppaView addGestureRecognizer:[[PetGestureRecognizer alloc] initWithTarget:self action:@selector(petting:)]];
    
    
}

-(void)petting:(PetGestureRecognizer *)rsd{
    if (rsd.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Change");
        [self toggleTickling];
    }
    else if (rsd.state == UIGestureRecognizerStateBegan) {
        beingTickled = YES;
        NSLog(@"Began");
    }
    else if (rsd.state == UIGestureRecognizerStatePossible) {
        beingTickled = NO;
        NSLog(@"Possible");
    }
}

-(void)toggleTickling {
    if (beingTickled) {
        self.mainAppaView.image = [self getImage:@"appaTickled1"];
    }
    else {
        self.mainAppaView.image = [self getImage:@"appaNeutral"];
    }
}

- (UIImage*)getImage:(NSString*)fileName {
    UIImage *myImage = [imageCache objectForKey:fileName];
    
    if (nil == myImage)
    {
        NSString *imageFile = [NSString stringWithFormat:@"%@", fileName];
        myImage = [UIImage imageNamed:imageFile];
        [imageCache setObject:myImage forKey:fileName];
    }
    return myImage;
}


- (IBAction)feedButtonPressed:(id)sender withEvent:(UIEvent *) event {
    [self.view bringSubviewToFront:_appaFaceZone];
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
    wedgeButton = (UIButton*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    wedgeButton.tag = 11;
    [wedgeButton setImage:[self getImage:@"foodSliceButton"] forState:UIControlStateNormal];
    [self.view addSubview:wedgeButton];
    wedgeButton.center = [[[event allTouches] anyObject] locationInView:self.view];
}

- (IBAction)sleepButtonPressed:(id)sender {
    if([[Appa sharedInstance] getSleepStatus]){
        [[Appa sharedInstance] wakeAppaUp];
        [sender setImage:[self getImage:@"sleepButton"] forState:UIControlStateNormal];
        self.mainAppaView.image = [self getImage:@"appaNeutral"];
    }
    else {
        [[Appa sharedInstance] putAppaToSleep];
        [sender setImage:[self getImage:@"wakeUpButton"] forState:UIControlStateNormal];
        self.mainAppaView.image = [self getImage:@"appaSleeping"];
    }
}

- (IBAction)playButtonPressed:(id)sender {
    if([[Appa sharedInstance] getSleepStatus]){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  nil message:@"Appa is Asleep! Wake him up in order to play!" delegate:self
                                                 cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alertView show];
    }
    else {
        [[Appa sharedInstance] playWithAppa];
        [self performSegueWithIdentifier:@"mainViewToLevelSelect" sender:self];
    }
}

- (IBAction)feedImageDragging:(id)sender withEvent:(UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:11]) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        wedgeButton = (UIButton*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        wedgeButton.tag = 11;
        [wedgeButton setImage:[self getImage:@"foodSliceButton"] forState:UIControlStateNormal];
        [self.view addSubview:wedgeButton];
    }
    [self.view viewWithTag:11].center = point;
}

- (IBAction)statusButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"mainViewToStatus" sender:self];
}

- (IBAction)imageToCleanUpDragging:(id)sender withEvent:(UIEvent *) event {
    [_dimView setAlpha:.5];
    [_sleepButton setHighlighted:YES];
    [_feedButton setHighlighted:YES];
    [_playButton setHighlighted:YES];
    [_cleanUpButton setUserInteractionEnabled:YES];
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    UIButton* myButton = (UIButton*)sender;
    myButton.center = point;
}

- (void)showPoop {
    int xCoord = arc4random() % 290;
    int yCoord = arc4random() % 80 + 400;
    UIButton *poopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [poopButton setImage:[self getImage:@"littleAppaPoop"] forState:UIControlStateNormal];
    [poopButton setFrame:CGRectMake(xCoord, yCoord, 30, 30)];
    
    [poopButton addTarget:self action:@selector(imageToCleanUpDragging:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [poopButton addTarget:self action:@selector(imageToCleanUpDragging:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [poopButton addTarget:self action:@selector(imageToCleanUpDragEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsToCleanUp addObject:poopButton];
    [buttonsToCleanUpOriginalPoints addObject:NSStringFromCGPoint(poopButton.center)];
    
    [self.view addSubview:poopButton];
}

- (void)showFoodWaste {
    int yCoord = arc4random() % 30 + 400;
    UIButton *foodWasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [foodWasteButton setImage:[self getImage:@"foodSliceButton"] forState:UIControlStateNormal];
    [foodWasteButton setFrame:wedgeButton.frame];
    
    CGRect newFrame = foodWasteButton.frame;
    if (yCoord > newFrame.origin.y) {
        newFrame.origin.y = yCoord;
    }
    [wedgeButton removeFromSuperview];
    wedgeButton = nil;
    [self.view addSubview:foodWasteButton];
    [UIView animateWithDuration:.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         foodWasteButton.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         [foodWasteButton setImage:[self getImage:@"foodMess"] forState:UIControlStateNormal];
                         [foodWasteButton addTarget:self action:@selector(imageToCleanUpDragging:withEvent:) forControlEvents:UIControlEventTouchDragInside];
                         [foodWasteButton addTarget:self action:@selector(imageToCleanUpDragging:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
                         [foodWasteButton addTarget:self action:@selector(imageToCleanUpDragEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside];
                         
                         [buttonsToCleanUp addObject:foodWasteButton];
                         [buttonsToCleanUpOriginalPoints addObject:NSStringFromCGPoint(foodWasteButton.center)];
                     }
     ];
    
}

- (void)imageToCleanUpDragEnd:(id)sender withEvent:(UIEvent*) event {
    
    [_dimView setAlpha:0];
    [_sleepButton setHighlighted:NO];
    [_feedButton setHighlighted:NO];
    [_playButton setHighlighted:NO];
    [_cleanUpButton setUserInteractionEnabled:NO];
    
    NSSet* touches = [event allTouches];
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    int myIndex = [buttonsToCleanUp indexOfObject:sender];
    
    if (CGRectContainsPoint(_toolBar.frame, touchLocation)) {
        UIButton* myButton = (UIButton*)sender;
        if (CGRectContainsPoint([_toolBar convertRect:_cleanUpButton.frame toView:self.view], touchLocation)){
            [buttonsToCleanUpOriginalPoints removeObjectAtIndex:myIndex];
            [buttonsToCleanUp removeObjectAtIndex:myIndex];
            [myButton removeFromSuperview];
        }
        else {
            myButton.center = CGPointFromString([NSString stringWithFormat:@"%@",buttonsToCleanUpOriginalPoints[myIndex]]);
        }
    }
    else {
        [buttonsToCleanUpOriginalPoints replaceObjectAtIndex: myIndex withObject:NSStringFromCGPoint(touchLocation)];
    }
}

- (void)setTopMenuButtonAttrs:(UIButton*)button {
    [button setTitleColor:skyColor forState:UIControlStateNormal];
    [[button layer] setBorderWidth:0.5f];
    [[button layer] setBorderColor:skyColor.CGColor];
    [button setAlpha:0.7f];
}

- (void)checkPhase:(id)sender withEvent:(UIEvent *) event {
    NSSet* touches = [event allTouches];
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (touch.phase == 3) { // signifies dragging has ended
        if (CGRectContainsPoint(_appaFaceZone.frame, touchLocation)) {
            if (![[Appa sharedInstance] getSleepStatus]) {
                [[Appa sharedInstance] feedAppa];
                int randInt = arc4random() % 4;
                if (randInt == 0) {
                    [self showPoop];
                }
                [self.view sendSubviewToBack:_appaFaceZone];
            }
            [wedgeButton removeFromSuperview];
            wedgeButton = nil;
        }
        else {
            if (touchLocation.y >= 475) {
                [wedgeButton removeFromSuperview];
                wedgeButton = nil;
            }
            else {
                [self showFoodWaste];
            }
        }
        if(![[Appa sharedInstance] getSleepStatus]){
            self.mainAppaView.image = [self getImage:@"appaNeutral"];
        }
    }
    else if (touch.phase == 1) { // dragging has not ended
        if(![[Appa sharedInstance] getSleepStatus]){
            if (CGRectContainsPoint(_appaFaceZone.frame, touchLocation)) {
                self.mainAppaView.image = [self getImage:@"appaEating"];
            }
            else {
                self.mainAppaView.image = [self getImage:@"appaNeutral"];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController) {
        [[Appa sharedInstance]saveState];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[Appa sharedInstance]loadState];
}


@end
