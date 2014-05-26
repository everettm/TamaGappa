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
    bool statusPageOpen;
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
    statusPageOpen = NO;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    buttons = [[NSArray alloc] initWithObjects: _feedButton, _playButton, _sleepButton, _trashButton, nil];
    wedgeButton = nil;
    wedgeImage = nil;
    
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_feedButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
    [_feedButton addTarget:self action:@selector(checkPhase:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
    
    _levelLabel.text = [NSString stringWithFormat:@"%d", [[Appa sharedInstance] getLevel]];
    _levelLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    
    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(updateStatusBars:)
                                   userInfo:nil
                                    repeats:YES];
    
}

-(void) initializeImages{
    //slidingBar Background
    UIGraphicsBeginImageContext(self.slidingStatusView.frame.size);
    [[UIImage imageNamed:@"statusBG.png"] drawInRect:self.slidingStatusView.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.slidingStatusView.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (IBAction) foodImageMoved:(id) sender withEvent:(UIEvent *) event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    if (![self.view viewWithTag:11]) {

        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        
        wedgeButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        
        wedgeButton.tag = 11;

        wedgeImage = [[UIImage alloc] initWithCGImage:[[UIImage imageNamed:@"watermelon-wedge"] CGImage]];
        
        
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
        statusPageOpen = NO;
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

    }
}

-(void) updateStatusBars:(id)sender{
    _healthBar.progress = [[Appa sharedInstance] getHealthStatus];
    [self updateColor: _healthBar];
    _happinessBar.progress = [[Appa sharedInstance] getHappinessStatus];
    [self updateColor: _happinessBar];
    _hungerBar.progress = [[Appa sharedInstance] getHungerStatus];
    [self updateColor: _hungerBar];
    _energyBar.progress = [[Appa sharedInstance] getEnergyStatus];
    [self updateColor: _energyBar];
}

-(void) updateColor:(UIProgressView*)statusBar{
    if(.80<statusBar.progress && statusBar.progress<=1.0){
        statusBar.progressTintColor = [UIColor greenColor];
    }
    else if (.21<statusBar.progress && statusBar.progress<=.80){
        statusBar.progressTintColor = [UIColor yellowColor];
    }
    else{
        statusBar.progressTintColor = [UIColor redColor];
    }
}

- (IBAction)sleepButtonPressed:(id)sender {
    if([[Appa sharedInstance] getSleepStatus]){
        [[Appa sharedInstance] wakeAppaUp];
        [sender setImage:[UIImage imageNamed:@"sleepButton.png"] forState:UIControlStateNormal];
        self.mainAppaView.image = [UIImage imageNamed:@"appa-default.png"];
    }
    else{
        [[Appa sharedInstance] putAppaToSleep];
        [sender setImage:[UIImage imageNamed:@"alarmClock.png"] forState:UIControlStateNormal];
        self.mainAppaView.image = [UIImage imageNamed:@"appaSleeping.png"];
    }
}

- (IBAction)playButtonPressed:(id)sender {
    statusPageOpen = false;
}

- (IBAction)slidingButtonPressed:(id)sender {
    CGRect viewFrame = self.slidingStatusView.frame;
    
    if(statusPageOpen){
        viewFrame.origin.x -= 234;
        statusPageOpen = false;
    }
    else{
        viewFrame.origin.x += 234;
        statusPageOpen = true;
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.slidingStatusView.frame = viewFrame;
                     }
                     completion:^(BOOL finished){}];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
