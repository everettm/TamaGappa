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
    float happinessMultiplier;
    float hungerMultiplier;
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
        level = 0;
        curHappiness = 100 + level*0.5;
        curEnergy = 100 + level*0.5;
        curHunger = 100 + level*0.5;
        curHealth = 100 + level*0.5;
        isAsleep = false;
    }
    
    maxHappiness = 100 + level*0.5;
    maxEnergy = 100 + level*0.5;
    maxHunger = 100 + level*0.5;
    maxHealth = 100 + level*0.5;
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
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
    }
    
    else{
        //        curHappiness -= (maxHappiness/10800);
        curHappiness -= .5;
        if(curHappiness <= 0.5*maxHappiness){
            happinessMultiplier = 2.0;
        }
        else{
            happinessMultiplier = 1.0;
        }
        if(curHappiness <=0){
            curHappiness = 0;
        }
        
        //        curHunger -= maxHunger/21600;
        curHunger -= .5;
        if(curHunger <= 0.5*maxHunger){
            hungerMultiplier = 2.0;
        }
        else{
            hungerMultiplier = 1.0;
        }
        if(curHunger <= 0){
            curHunger = 0;
        }
        
        //        curEnergy -= (maxEnergy/21600)*happinessMultiplier*hungerMultiplier;
        curEnergy -= .5;
        if(curEnergy <= 0){
            curEnergy = 0;
        }
        
        //        curHealth -= (maxHealth/21600)*hungerMultiplier;
        curHealth -= .5;
        if(curHealth <= 0){
            curHealth = 0;
        }
    }
}

-(void) restoreStatus{
    //    curEnergy += maxEnergy/1800;
    //    curHappiness += maxHappiness/1800;
    //    curHealth += maxHealth/1800;
    curEnergy += 2;
    curHappiness += 2;
    curHealth += 2;
    
    if(curEnergy >= maxEnergy){
        curEnergy = maxEnergy;
    }
    
    if(curHealth >= maxHealth){
        curHealth = maxHealth;
    }
    
    if(curHappiness >= maxHappiness){
        curHappiness = maxHappiness;
    }
}

-(void) feedAppa{
    curHunger += 30;
    
    if(curHunger >= maxHunger){
        curHunger = maxHunger;
    }
}

-(void) putAppaToSleep{
    isAsleep = true;
}

-(void) wakeAppaUp{
    isAsleep = false;
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

+ (Appa*)sharedInstance{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithNothing]; // or some other init method
    });
    return _sharedObject;
}


@end
