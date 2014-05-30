//
//  MainPageViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MainPageViewController.h"
#import "Appa.h"

@interface MainPageViewController (){
    UIButton *wedgeButton;
    NSArray *buttons;
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
    
    buttons = [[NSArray alloc] initWithObjects: _feedButton, _playButton, _sleepButton, _cleanUpButton, nil];
    wedgeButton = nil;
    
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_feedButton addTarget:self action:@selector(checkPhase:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
}

- (UIImage*)getImage:(NSString*)fileName
{
    UIImage *myImage = [imageCache objectForKey:fileName];
    
    if (nil == myImage)
    {
        NSString *imageFile = [NSString stringWithFormat:@"%@", fileName];
        myImage = [UIImage imageNamed:imageFile];
        [imageCache setObject:myImage forKey:fileName];
    }
    return myImage;
}

- (IBAction) foodImageMoved:(id) sender withEvent:(UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:11]) {

        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        
        wedgeButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        
        wedgeButton.tag = 11;
        
        [wedgeButton setImage:[self getImage:@"foodSliceButton"] forState:UIControlStateNormal];
        
        [self.view addSubview:wedgeButton];
    }
    
    [self.view viewWithTag:11].center = point;
}
-(void) checkPhase:(id) sender withEvent:(UIEvent *) event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    if (touch.phase == 3) {
        if (CGRectContainsPoint(_appaFaceZone.frame, touchLocation)) {
            if (![[Appa sharedInstance] getSleepStatus]) {
                NSLog(@"Yay!");
                [[Appa sharedInstance] feedAppa];
            }
            else {
                NSLog(@"Cheater!");
            }
        }
        else {
            NSLog(@"Boo...");
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

- (IBAction)sleepButtonPressed:(id)sender {
    if([[Appa sharedInstance] getSleepStatus]){
        [[Appa sharedInstance] wakeAppaUp];
        [sender setImage:[self getImage:@"sleepButton"] forState:UIControlStateNormal];
        self.mainAppaView.image = [self getImage:@"appaNeutral"];
    }
    else{
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
        [self performSegueWithIdentifier:@"mainViewToLevelSelect" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
