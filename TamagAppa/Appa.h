//
//  Appa.h
//  TamagAppa
//
//  Created by Lab User on 5/25/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Appa : NSObject{
    NSTimer* myTimer;
}
@property (nonatomic, assign) int level;
@property (nonatomic, assign) float maxHappiness;
@property (nonatomic, assign) float maxEnergy;
@property (nonatomic, assign) float maxHunger;
@property (nonatomic, assign) float maxHealth;
@property (nonatomic, assign) float curHappiness;
@property (nonatomic, assign) float curEnergy;
@property (nonatomic, assign) float curHunger;
@property (nonatomic, assign) float curHealth;

-(float)getHappinessStatus;
-(float)getHungerStatus;
-(float)getHealthStatus;
-(float)getEnergyStatus;
-(int)getLevel;
-(bool)getSleepStatus;
-(void)feedAppa;
-(void)putAppaToSleep;
-(void)wakeAppaUp;
-(void)restoreStatus;
+(void)saveState;
-(void)loadState;
+(Appa*)sharedInstance;


@end
