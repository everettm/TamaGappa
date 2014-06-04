//
//  AppaStatusViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/29/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "AppaStatusViewController.h"
#import "Appa.h"

@interface AppaStatusViewController ()

@end

@implementation AppaStatusViewController

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
    _levelLabel.text = [NSString stringWithFormat:@"%d", [[Appa sharedInstance] getLevel]];
    _levelLabel.font = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:14];
    
    [NSTimer scheduledTimerWithTimeInterval:.1
                                     target:self
                                   selector:@selector(updateStatusBars:)
                                   userInfo:nil
                                    repeats:YES];
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
        statusBar.progressTintColor = [UIColor colorWithRed:80.0/255.0 green:150.0/255.0 blue:40.0/255.0 alpha:1.0];
    }
    else if (.21<statusBar.progress && statusBar.progress<=.80){
        statusBar.progressTintColor = [UIColor colorWithRed:225.0/255.0 green:200.0/255.0 blue:50.0/255.0 alpha:1.0];
    }
    else{
        statusBar.progressTintColor = [UIColor colorWithRed:220.0/255.0 green:70.0/255.0 blue:30.0/255.0 alpha:1.0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
