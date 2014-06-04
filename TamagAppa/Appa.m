//
//  Appa.m
//  TamagAppa
//
//  Created by Lab User on 5/25/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "Appa.h"

@implementation Appa{
    bool isAsleep;
    bool isBeingTickled;
    float happinessMultiplier;
    float hungerMultiplier;
    float hour;
    int amountOfFoodMess;
    int amountOfWasteMess;
    
    NSUserDefaults* appaSettings;
}
@synthesize level;
@synthesize maxHappiness;
@synthesize maxEnergy;
@synthesize maxHunger;
@synthesize maxHealth;
@synthesize curHappiness;
@synthesize curEnergy;
@synthesize curHunger;
@synthesize curHealth;


-(id)initWithNothing{
    
    appaSettings = [NSUserDefaults standardUserDefaults];
    
    if([appaSettings boolForKey:@"isSaveState"]){
        [self loadState];
    }
    
    else{
        level = 1;
        curHappiness = 100 + level*0.5;
        curEnergy = 100 + level*0.5;
        curHunger = 100 + level*0.5;
        curHealth = 100 + level*0.5;
        isAsleep = false;
        isBeingTickled = false;
        amountOfFoodMess = 0;
        amountOfWasteMess = 0;
    }
    
    maxHappiness = 100 + level*0.5;
    maxEnergy = 100 + level*0.5;
    maxHunger = 100 + level*0.5;
    maxHealth = 100 + level*0.5;
    
    hour = 3600;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                               target:self
                                             selector:@selector(updateStatus)
                                             userInfo:nil
                                              repeats:YES];
    
    return self;
}


-(float) getHappinessStatus{
    return curHappiness/maxHappiness;
}

-(float) getEnergyStatus{
    return curEnergy/maxEnergy;
}

-(float) getHungerStatus{
    return curHunger/maxHunger;
}

-(float) getHealthStatus{
    return curHealth/maxHealth;
}

-(int) getLevel{
    return level;
}

-(bool) getSleepStatus{
    return isAsleep;
}

-(void) updateStatus{
    if(isAsleep){
        [self restoreStatus];
        [self updateHungerBy:(maxHunger/3*hour)*[self toThePowerOf:.98 :(float)level]];
        
        [self calculateMultipliers];
        
        [self calculateHealth];
        
    }
    
    else {
        [self updateHappinessBy: -(maxHappiness/3*hour)*[self toThePowerOf:.98 :(float)level]*(amountOfWasteMess + amountOfFoodMess)];

        [self updateHungerBy:-((maxHunger/hour*3)*[self toThePowerOf:.98 :(float)level])];
        [self calculateMultipliers];
        
        [self updateEnergyBy:-(maxEnergy/hour*3)*hungerMultiplier*[self toThePowerOf:.98 :(float)level]/happinessMultiplier];

        [self calculateHealth];
    }
}

-(void) restoreStatus{
    [self updateEnergyBy:(maxEnergy/1800)];
    [self updateHealthBy:(maxHealth/1800)];
}

-(void)calculateMultipliers {
    if(curHappiness <= 0.5*maxHappiness) happinessMultiplier = 2.0;
    else happinessMultiplier = 1.0;
    
    if(curHunger <= 0.5*maxHunger) hungerMultiplier = 2.0;
    else hungerMultiplier = 1.0;
}

-(void)calculateHealth {
    float baseHealth = ((curEnergy + curHappiness + curHunger)/3)*[self toThePowerOf:.98 :(float)level];
    curHealth = baseHealth - (amountOfWasteMess) * 5 - amountOfFoodMess;
    if(curHealth <= 0) curHealth = 0;
}

-(void) feedAppa{
    if(curHunger >= maxHunger - 5) {
        curHunger = maxHunger;
        [self updateHappinessBy:(-maxHappiness/5)];
        [self updateHealthBy:(-maxHealth/5)];
    }
    
    else {
        [self updateHungerBy:(maxHunger/4)];
        [self updateHappinessBy:(maxHappiness/5)];
        [self updateEnergyBy:(maxEnergy/5)];
    }
}

-(void) playWithAppa{
    [self updateHappinessBy:(maxHappiness/4)];
    [self updateEnergyBy:(maxEnergy/3)];
}

-(void)putAppaToSleep{
    isAsleep = true;
    [self updateHappinessBy:(maxHappiness/4)];
}

-(void)tickleAppa{
    isBeingTickled = true;
    if (isAsleep) [self updateHappinessBy: -maxHappiness/5];
    else [self updateHappinessBy:maxHappiness/5];
}

-(void)stopTickling {
    isBeingTickled = false;
}

-(void)wakeAppaUp{
    isAsleep = false;
}

-(void)updateHappinessBy:(float) amount {
    curHappiness += amount;
    if (curHappiness < 0) curHappiness = 0;
    else if (curHappiness > maxHappiness) curHappiness = maxHappiness;
}

-(void)updateHealthBy:(float) amount {
    curHealth += amount;
    if (curHealth < 0) curHealth = 0;
    else if (curHealth > maxHealth) curHealth = maxHealth;
}

-(void)updateEnergyBy:(float) amount {
    curEnergy += amount;
    if (curEnergy < 0) curEnergy = 0;
    else if (curEnergy > maxEnergy) curEnergy = maxEnergy;
}

-(void)updateHungerBy:(float) amount {
    curHunger += amount;
    if (curHunger < 0) curHunger = 0;
    else if (curHunger > maxHunger) curHunger = maxHunger;
}

-(void)updateFoodMessAmountBy:(int) num{
    amountOfFoodMess += num;
}

-(void)updateWasteAmountBy:(int)num {
    amountOfWasteMess += num;
}

-(void) saveState{
    [appaSettings setFloat:curHappiness forKey:@"curHappiness" ];
    [appaSettings setFloat:curHealth forKey:@"curHealth" ];
    [appaSettings setFloat:curHunger forKey:@"curHunger" ];
    [appaSettings setFloat:curEnergy forKey:@"curEnergy" ];
    [appaSettings setInteger:level forKey:@"level"];
    [appaSettings setBool:isAsleep forKey:@"isAsleep"];
    [appaSettings setBool:true forKey:@"isSaveState"];
}

-(void) loadState{
    curHappiness = [appaSettings floatForKey:@"curHappiness"];
    curHealth = [appaSettings floatForKey:@"curHealth"];
    curHunger = [appaSettings floatForKey:@"curHunger"];
    curEnergy = [appaSettings floatForKey:@"curEnergy"];
    level = [appaSettings integerForKey:@"level"];
    isAsleep = [appaSettings boolForKey:@"isAsleep"];
}

-(float)toThePowerOf:(float)x :(float)y{
    if(y==0){
        return 1;
    }
    else{
        return x * [self toThePowerOf:x :y-1];
    }
}

-(bool)isInTrouble {
    if (curHealth > maxHealth/5 && curEnergy > maxEnergy/5 && curHappiness > maxHappiness/5 && curHunger > maxHunger/5) {
        return NO;
    }
    return YES;
}

+ (Appa*)sharedInstance{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithNothing]; // or some other init method
    });
    return _sharedObject;
}

@end
