//
//  MainPageViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController

@property (weak, nonatomic)IBOutlet UIButton* feedButton;
@property (weak, nonatomic)IBOutlet UIButton* sleepButton;
@property (weak, nonatomic)IBOutlet UIButton* trashButton;
@property (weak, nonatomic)IBOutlet UIButton* playButton;
@property (weak, nonatomic)IBOutlet UIButton* appaFaceZone;

@property (weak, nonatomic)IBOutlet UIView* slidingStatusView;
@property (weak, nonatomic)IBOutlet UIImageView* appaIcon;
@property (weak, nonatomic)IBOutlet UIImageView* mainAppaView;
@property (weak, nonatomic)IBOutlet UILabel* levelLabel;
@property (weak, nonatomic)IBOutlet UIProgressView* healthBar;
@property (weak, nonatomic)IBOutlet UIProgressView* happinessBar;
@property (weak, nonatomic)IBOutlet UIProgressView* hungerBar;
@property (weak, nonatomic)IBOutlet UIProgressView* energyBar;
@property (weak, nonatomic)IBOutlet UILabel* healthLabel;
@property (weak, nonatomic)IBOutlet UILabel* happinessLabel;
@property (weak, nonatomic)IBOutlet UILabel* hungerLabel;
@property (weak, nonatomic)IBOutlet UILabel* energyLabel;

@end
