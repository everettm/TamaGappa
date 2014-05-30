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
    UIImage *wedgeImage;
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
    wedgeImage = nil;
    
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_feedButton addTarget:self action:@selector(checkPhase:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
}

- (IBAction) foodImageMoved:(id) sender withEvent:(UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:11]) {

        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        
        wedgeButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        
        wedgeButton.tag = 11;

        wedgeImage = [[UIImage alloc] initWithCGImage:[[UIImage imageNamed:@"foodSliceButton"] CGImage]];
        
        [wedgeButton setImage:wedgeImage forState:UIControlStateNormal];
        
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
            self.mainAppaView.image = [UIImage imageNamed:@"appaNeutral.png"];
        }
    }
    else if (touch.phase == 1) {
        if(![[Appa sharedInstance] getSleepStatus]){
            if (CGRectContainsPoint(_appaFaceZone.frame, touchLocation)) {
                self.mainAppaView.image = [UIImage imageNamed:@"appaEating.png"];
            }
            else {
                self.mainAppaView.image = [UIImage imageNamed:@"appaNeutral.png"];
            }
        }
    }
}

- (IBAction)sleepButtonPressed:(id)sender {
    if([[Appa sharedInstance] getSleepStatus]){
        [[Appa sharedInstance] wakeAppaUp];
        [sender setImage:[UIImage imageNamed:@"sleepButton.png"] forState:UIControlStateNormal];
        self.mainAppaView.image = [UIImage imageNamed:@"appaNeutral.png"];
    }
    else{
        [[Appa sharedInstance] putAppaToSleep];
        [sender setImage:[UIImage imageNamed:@"wakeUpButton.png"] forState:UIControlStateNormal];
        self.mainAppaView.image = [UIImage imageNamed:@"appaSleeping.png"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
