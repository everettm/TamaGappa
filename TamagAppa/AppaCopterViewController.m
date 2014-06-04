//
//  AppaCopterViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/28/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "AppaCopterViewController.h"
#import "AppaCopterSkyScene.h"

@interface AppaCopterViewController (){
    int animateHelper;
}

@end

@implementation AppaCopterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpButtons];
    SKView* gameView = (SKView*) self.view;
//    gameView.showsDrawCount = YES;
//    gameView.showsFPS = YES;
//    gameView.showsNodeCount = YES;
    
}

-(void)setUpButtons{
    [_leftButton setBackgroundImage:[UIImage imageNamed:@"leftArrow.png"] forState:UIControlStateNormal];
    [_rightButton setBackgroundImage:[UIImage imageNamed:@"rightArrow.png"] forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated{
    AppaCopterSkyScene* skyScene = [[AppaCopterSkyScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    SKView* gameView = (SKView*)self.view;
    [gameView presentScene:skyScene];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
