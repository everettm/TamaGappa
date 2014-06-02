//
//  MainPageViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MainPageViewController.h"
#import "Appa.h"
#import <QuartzCore/QuartzCore.h>

@interface MainPageViewController (){
    UIColor *skyColor;
    UIButton *wedgeButton;
    UIButton *poopButtonDrag;
    NSMutableDictionary *imageCache;
}

@end

@implementation MainPageViewController

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
    
    wedgeButton = nil;
    poopButtonDrag = nil;
    skyColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    
    [_statusButton addTarget:self action:@selector(statusButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self setTopMenuButtonAttrs:_statusButton];
    
    
    [_poopButton addTarget:self action:@selector(poopButtonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    NSLog(@"Not entirely sure when this should print...");
    [_poopButton addTarget:self action:@selector(poopButtonMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    NSLog(@"I think these should just print right away...");
    [_poopButton addTarget:self action:@selector(poopButtonMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    NSLog(@"Now I'm just wasting time...");
    [_poopButton addTarget:self action:@selector(checkPhasePoop:withEvent:) forControlEvents:UIControlEventAllTouchEvents];

    [_feedButton addTarget:self action:@selector(feedButtonPressed:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_feedButton addTarget:self action:@selector(checkPhase:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
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

- (IBAction)foodImageMoved:(id) sender withEvent:(UIEvent *) event {
    NSLog(@"This is getting called...But why?");
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


- (IBAction)feedButtonPressed:(id) sender withEvent:(UIEvent *) event {
    int randInt = arc4random() % 5;
    if (randInt == 0) {
        [self showPoop];
    }
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

- (IBAction)poopButtonMoved:(id) sender withEvent:(UIEvent *) event {
    NSLog(@"POOP BUTTON IS MOVING!!");
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:77]) {
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        poopButtonDrag =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        poopButtonDrag.tag = 12;
        [poopButtonDrag setImage:[self getImage:@"littleAppaPoop"] forState:UIControlStateNormal];
        [self.view addSubview:poopButtonDrag];
    }
    [self.view viewWithTag:12].center = point;
}

- (IBAction)poopButtonPressed:(id) sender withEvent:(UIEvent *) event {
    NSLog(@"Poop Button has been Pressed!!");
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
    poopButtonDrag = (UIButton*)[NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
    poopButtonDrag.tag = 77;
    [poopButtonDrag setImage:[self getImage:@"littleAppaPoop"] forState:UIControlStateNormal];
    [self.view addSubview:poopButtonDrag];
    poopButtonDrag.center = [[[event allTouches] anyObject] locationInView:self.view];
}

- (void)showPoop {
    int xCoord = arc4random() % 290;
    int yCoord = arc4random() % 80 + 400;
    _poopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_poopButton addTarget:self action:@selector(poopButtonPressed:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_poopButton setImage:[UIImage imageNamed:@"littleAppaPoop"] forState:UIControlStateNormal];
    _poopButton.frame = CGRectMake(xCoord, yCoord, 30, 30);
    [self.view addSubview:_poopButton];
}

- (IBAction)statusButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"mainViewToStatus" sender:self];
}

- (void) setTopMenuButtonAttrs:(UIButton*)button {
    [button setTitleColor:skyColor forState:UIControlStateNormal];
    [[button layer] setBorderWidth:0.5f];
    [[button layer] setBorderColor:skyColor.CGColor];
    [button setAlpha:0.7f];
}

- (void) checkPhase:(id) sender withEvent:(UIEvent *) event {
    NSSet* touches = [event allTouches];
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (touch.phase == 3) {
        if (CGRectContainsPoint(_appaFaceZone.frame, touchLocation)) {
            if (![[Appa sharedInstance] getSleepStatus]) {
                [[Appa sharedInstance] feedAppa];
            }
        }
        [wedgeButton removeFromSuperview];
        wedgeButton = nil;
        if(![[Appa sharedInstance] getSleepStatus]){
        self.mainAppaView.image = [self getImage:@"appaNeutral"];
        }
    }
    else if (touch.phase == 1) {
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

- (void) checkPhasePoop:(id) sender withEvent:(UIEvent *) event {
    NSSet* touches = [event allTouches];
    UITouch* touch = [touches anyObject];
    NSLog(@"IN HERE");
    CGPoint touchLocation = [touch locationInView:self.view];
    if (touch.phase == 3) {
        if (CGRectContainsPoint(_cleanUpButton.frame, touchLocation)) {
            NSLog(@"WORKING!!");
        }
        [_poopButton removeFromSuperview];
        [poopButtonDrag removeFromSuperview];
        poopButtonDrag = nil;
    }
    else if (touch.phase == 1) {
        NSLog(@"Wtf is this code?");
    }
}



-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _originalPosition = self.view.center;
    _touchOffset = CGPointMake(self.view.center.x,self.view.center.y);
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


@end
