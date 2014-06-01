//
//  MazeScene.m
//  TamagAppa
//
//  Created by Lab User on 6/1/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "MazeScene.h"
#import "GameOverScene.h"

static const uint32_t bisonCategory =  0x1 << 0;
static const uint32_t obstacleCategory =  0x1 << 1;

static const float BG_VELOCITY = 100.0;
static const float OBJECT_VELOCITY = 160.0;

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b)
{
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat b)
{
    return CGPointMake(a.x * b, a.y * b);
}


@implementation MazeScene {
    
    SKSpriteNode *bison;
    SKAction *actionMoveLeft;
    SKAction *actionMoveRight;
    SKAction *actionMoveUp;
    SKAction *actionMoveDown;
    
    UISwipeGestureRecognizer *swipeRightGesture;
    UISwipeGestureRecognizer *swipeLeftGesture;
    UISwipeGestureRecognizer *swipeUpGesture;
    UISwipeGestureRecognizer *swipeDownGesture;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        // 320 X 568
        self.backgroundColor = [SKColor whiteColor];
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        [self addAppa];
        [self addWall];
        
        //Making self delegate of physics World
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        // Add swipe detection recognizers
        swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeRight:)];
        [swipeRightGesture setDirection: UISwipeGestureRecognizerDirectionRight];
        swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeLeft:)];
        [swipeLeftGesture setDirection: UISwipeGestureRecognizerDirectionLeft];
        swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeUp:)];
        [swipeUpGesture setDirection: UISwipeGestureRecognizerDirectionUp];
        swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector( handleSwipeDown:)];
        [swipeDownGesture setDirection: UISwipeGestureRecognizerDirectionDown];
    }
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    [self.view addGestureRecognizer: swipeRightGesture ];
    [self.view addGestureRecognizer: swipeLeftGesture ];
    [self.view addGestureRecognizer: swipeUpGesture ];
    [self.view addGestureRecognizer: swipeDownGesture ];
}


-(void)addAppa {
    //initalizing spaceship node
    bison = [SKSpriteNode spriteNodeWithImageNamed:@"Appa"];
    [bison setScale:0.095];
    
    //Adding SpriteKit physicsBody for collision detection
    bison.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bison.size];
    NSLog(@"width = %f, height = %f", bison.size.width, bison.size.height);
    bison.physicsBody.categoryBitMask = bisonCategory;
    bison.physicsBody.dynamic = YES;
    bison.physicsBody.contactTestBitMask = obstacleCategory;
    bison.physicsBody.collisionBitMask = 0;
    bison.physicsBody.usesPreciseCollisionDetection = YES;
    bison.name = @"bison";
    bison.position = CGPointMake(160,284);
//    bison.position = CGPointMake(320,568);
    actionMoveLeft = [SKAction moveByX:-30 y:0 duration:.2];
    actionMoveRight = [SKAction moveByX:30 y:0 duration:.2];
    actionMoveUp = [SKAction moveByX:0 y:30 duration:.2];
    actionMoveDown = [SKAction moveByX:0 y:-30 duration:.2];
    
    [self addChild:bison];
}

-(void)addWall {
    CGRect rect = CGRectMake(0, 0, 10, 80);
    
    SKNode *wallNode = [[SKSpriteNode alloc] initWithColor:[UIColor redColor] size:CGSizeMake(10,80)];
    wallNode.position = CGPointMake(200 + rect.size.width * 0.5,
                                    300 - rect.size.height * 0.5);
    
    wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rect.size];
    wallNode.physicsBody.dynamic = NO;
    wallNode.physicsBody.categoryBitMask = obstacleCategory;
    [self addChild:wallNode];
}


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint touchLocation = [touch locationInNode:self.scene];
//    // add in button?
//}

-(void) handleSwipeRight:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.x < 270){
        [bison runAction:actionMoveRight];
    }
}

-(void) handleSwipeLeft:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.x > 50){
        [bison runAction:actionMoveLeft];
    }
}

-(void) handleSwipeUp:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.y < 500){
        [bison runAction:actionMoveUp];
    }
}

-(void) handleSwipeDown:( UISwipeGestureRecognizer *) recognizer {
    if(bison.position.y > 50){
        [bison runAction:actionMoveDown];
    }
}

- (void) update:(NSTimeInterval)currentTime{
    
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & bisonCategory) != 0 &&
        (secondBody.categoryBitMask & obstacleCategory) != 0)
    {
        NSLog(@"AAAH");
        [bison removeAllActions];
        bison.speed=0;
//        [bison removeFromParent];
//        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
//        SKScene * gameOverScene = [[GameOverScene alloc] initWithSize:self.size];
//        [self.view presentScene:gameOverScene transition: reveal];
        
    }
}


@end
