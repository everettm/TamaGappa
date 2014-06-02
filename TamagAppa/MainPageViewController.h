//
//  MainPageViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController

@property (strong, nonatomic)IBOutlet UIButton* feedButton;
@property (strong, nonatomic)IBOutlet UIButton* poopButton;
@property (strong, nonatomic)IBOutlet UIButton* sleepButton;
@property (strong, nonatomic)IBOutlet UIButton* cleanUpButton;
@property (strong, nonatomic)IBOutlet UIButton* playButton;
@property (strong, nonatomic)IBOutlet UIButton* appaFaceZone;
@property (strong, nonatomic)IBOutlet UIButton* statusButton;

@property (weak, nonatomic)IBOutlet UIImageView* mainAppaView;

@end
