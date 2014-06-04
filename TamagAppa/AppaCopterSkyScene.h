//
//  AppaCopterSkyScene.h
//  TamagAppa
//
//  Created by Lab User on 6/1/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AppaCopterSkyScene : SKScene <SKPhysicsContactDelegate>

typedef NS_OPTIONS(NSUInteger, CollisionCategory) {
    categoryOne = (1 << 0),
    categoryTwo = (1 << 1)
};


@end
