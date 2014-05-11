//
//  StatusBarViewController.m
//  StatusBars
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 Lab User. All rights reserved.
//

#import "StatusBarViewController.h"

@interface StatusBarViewController (){
    float maxHealth;
    float curHealth;
    float healthProgress;
    
    float maxHappiness;
    float curHappiness;
    float happinessProgress;
    
    float maxHunger;
    float curHunger;
    float hungerProgress;
    
    float maxEnergy;
    float curEnergy;
    float energyProgress;
}

@end

@implementation StatusBarViewController
@synthesize healthBar;
@synthesize happinessBar;
@synthesize hungerBar;
@synthesize energyBar;

@synthesize healthLabel;
@synthesize happinessLabel;
@synthesize hungerLabel;
@synthesize energyLabel;

@synthesize progressBars;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}


-(void)initializeBars{
    
    if(!healthBar.progress){
        healthBar.progress = 1.0;
        happinessBar.progress = 1.0;
        hungerBar.progress = 1.0;
        energyBar.progress = 1.0;
        
        int i;
        
        for (i=0; i<[progressBars count]; i++){
            UIProgressView* returnedBar = [progressBars objectAtIndex:i];
            returnedBar.progressTintColor = [UIColor greenColor];
        }

    }
    
    progressBars = [NSMutableArray arrayWithObjects: healthBar, happinessBar, hungerBar, energyBar, nil];
    
    [[NSUserDefaults standardUserDefaults] setFloat:healthBar.progress forKey:@"savedHealthProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:happinessBar.progress forKey:@"savedHappinessProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:hungerBar.progress forKey:@"savedHungerProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:energyBar.progress forKey:@"savedEnergyProgress"];

}

-(void) updateStatusBars:(id)sender{
    int i;
    for (i=0; i<[progressBars count]; i++){
        UIProgressView* returnedBar = [progressBars objectAtIndex:i];
        if(returnedBar.progress == 0){
            continue;
        }
        else{
            returnedBar.progress -= .01;
        }
        if(.81<returnedBar.progress && returnedBar.progress<1.0){
            returnedBar.progressTintColor = [UIColor greenColor];
        }
        else if (.21<returnedBar.progress && returnedBar.progress<.80){
            returnedBar.progressTintColor = [UIColor yellowColor];
        }
        else{
            returnedBar.progressTintColor = [UIColor redColor];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:healthBar.progress forKey:@"savedHealthProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:happinessBar.progress forKey:@"savedHappinessProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:hungerBar.progress forKey:@"savedHungerProgress"];
    [[NSUserDefaults standardUserDefaults] setFloat:energyBar.progress forKey:@"savedEnergyProgress"];

}

- (void)viewDidLoad
{
    
    healthBar.progress = [[NSUserDefaults standardUserDefaults] floatForKey:@"savedHealthProgress"];
    happinessBar.progress = [[NSUserDefaults standardUserDefaults] floatForKey:@"savedHappinessProgress"];
    hungerBar.progress = [[NSUserDefaults standardUserDefaults] floatForKey:@"savedHungerProgress"];
    energyBar.progress = [[NSUserDefaults standardUserDefaults] floatForKey:@"savedEnergyProgress"];
    
    if(healthBar.progress){
         NSLog(@"Current health is: %f", healthBar.progress);
    }
    
    [self initializeBars];

    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateStatusBars:)
                                   userInfo:nil
                                    repeats:YES];

    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
