//
//  AppaStatusViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/29/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppaStatusViewController : UIViewController
@property (weak, nonatomic)IBOutlet UILabel* levelLabel;
@property (weak, nonatomic)IBOutlet UIProgressView* healthBar;
@property (weak, nonatomic)IBOutlet UIProgressView* happinessBar;
@property (weak, nonatomic)IBOutlet UIProgressView* hungerBar;
@property (weak, nonatomic)IBOutlet UIProgressView* energyBar;
@end
