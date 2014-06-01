//
//  MazeGameViewController.m
//  TamagAppa
//
//  Created by Lab User on 6/1/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MazeGameViewController.h"
#import "MazeScene.h"

@implementation MazeGameViewController


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        SKScene * scene = [MazeScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end

