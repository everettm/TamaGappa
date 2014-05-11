//
//  StatusBarViewController.h
//  StatusBars
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 Lab User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusBarViewController : UIViewController{
    NSTimer* updateTimer;
}
@property (strong, nonatomic) IBOutlet UIProgressView* healthBar;
@property (strong, nonatomic) IBOutlet UIProgressView *happinessBar;
@property (weak, nonatomic) IBOutlet UIProgressView *hungerBar;
@property (weak, nonatomic) IBOutlet UIProgressView *energyBar;
@property (weak, nonatomic) IBOutlet UILabel *healthLabel;
@property (weak, nonatomic) IBOutlet UILabel *happinessLabel;
@property (weak, nonatomic) IBOutlet UILabel *hungerLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (strong, nonatomic) NSMutableArray* progressBars;


@end
