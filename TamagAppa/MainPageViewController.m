//
//  MainPageViewController.m
//  TamagAppa
//
//  Created by Lab User on 5/22/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MainPageViewController.h"

@implementation MainPageViewController

BOOL draggingFood;
@synthesize foodButton;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    draggingFood = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [foodButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [foodButton addTarget:self action:@selector(foodImageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];


}


//- (IBAction) imageMoved:(id) sender withEvent:(UIEvent *) event {
//    NSLog(@"moved");
//    
//    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
//    
//    if (![self.view viewWithTag:11]) {
//        
//        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
//        
//        UIButton *anotherButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
//        
//        anotherButton.tag = 11;
//        
//        
//        UIImage *senderImage=[(UIButton *)sender imageForState:UIControlStateNormal];
//        
//        
//        
//        
//        CGImageRef cgImage = [senderImage CGImage];
//        
//        
//        UIImage *copyOfImage = [[UIImage alloc] initWithCGImage:cgImage];
//        
//        
//        
//        [anotherButton setImage:copyOfImage forState:UIControlStateNormal];
//        
//        [self.view addSubview:anotherButton];
//    }
//    
//    [self.view viewWithTag:11].center = point;
//}

- (IBAction) foodImageMoved:(id) sender withEvent:(UIEvent *) event {
 
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    
    if (![self.view viewWithTag:11]) {
        
        NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:(UIButton*)sender];
        
        UIButton *anotherButton =(UIButton*) [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
        
        anotherButton.tag = 11;
        
        [anotherButton setImage:[UIImage imageNamed:@"watermelon-wedge"] forState:UIControlStateNormal];
        
        [self.view addSubview:anotherButton];
    }
    
    [self.view viewWithTag:11].center = point;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
