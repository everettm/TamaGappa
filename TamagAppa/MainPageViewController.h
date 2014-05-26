//
//  MainPageViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainPageViewController : UIViewController {
    IBOutlet UIButton *feedButton;
    IBOutlet UIButton *sleepButton;
    IBOutlet UIButton *trashButton;
    IBOutlet UIButton *gamesButton;
    IBOutlet UIImageView *appaImage;
}

@property (retain, nonatomic) IBOutlet UIButton *feedButton;
@property (retain, nonatomic) IBOutlet UIButton *sleepButton;
@property (retain, nonatomic) IBOutlet UIButton *trashButton;
@property (retain, nonatomic) IBOutlet UIButton *gamesButton;
@property (retain, nonatomic) IBOutlet UIImageView *appaImage;

@end
