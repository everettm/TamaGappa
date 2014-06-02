//
//  AppaCopterViewController.h
//  TamagAppa
//
//  Created by Lab User on 5/28/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface AppaCopterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *flyingAppa;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *theMagicButton;

@end
