//
//  AppaCopterSkyScene.m
//  TamagAppa
//
//  Created by Lab User on 6/1/14.
//  Copyright (c) 2014 Team G. All rights reserved.
//

#import "AppaCopterSkyScene.h"

static const uint32_t bisonCategory = 0x1 << 0;
static const uint32_t obstacleCategory = 0x1 << 1;

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

@interface AppaCopterSkyScene()
@property BOOL contentCreated;
@property NSTimer* moveRightTimer;
@property NSTimer* moveLeftTimer;
@property NSTimer* cloudSpawnTimer;
@property int level;
@property int score;
@property int numLives;
@end

@implementation AppaCopterSkyScene

-(void)didMoveToView:(SKView *)view{
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

-(void)createSceneContents{
    [self startGame];
    self.physicsWorld.gravity = CGVectorMake(0.0f, -2.45f);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [SKColor grayColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    SKSpriteNode* flyingAppa = [self newAppa];
    SKSpriteNode* leftButton = [self newLeftButton];
    SKSpriteNode* rightButton = [self newRightButton];
    SKSpriteNode* statusBar = [self newStatusBar];
    SKLabelNode* scoreNode = [self newScoreNode];
    SKLabelNode* levelNode = [self newLevelNode];
    SKLabelNode* levelUp = [self newLevelUpNode];
    
    [self addChild:flyingAppa];
    [self addChild:leftButton];
    [self addChild:rightButton];
    [self addChild:statusBar];
    [self addChild:scoreNode];
    [self addChild:levelNode];
    [self addChild:levelUp];
    
    SKSpriteNode* life1 = [self newAppaLifeIndicator];
    life1.name = @"life1";
    life1.position = CGPointMake(115, self.size.height-85);
    SKSpriteNode* life2 = [self newAppaLifeIndicator];
    life2.name = @"life2";
    life2.position = CGPointMake(135, self.size.height-85);
    life2.zPosition = 5;
    
    [self addChild:life1];
    [self addChild:life2];
}

-(void)startGame{
    _level = 1;
    _score = 0;
    _numLives = 2;

    [self spawnClouds];
}

-(void)restartGame{
    
    [_cloudSpawnTimer invalidate];
    _cloudSpawnTimer = nil;
    
    [self enumerateChildNodesWithName:@"cloud" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    SKLabelNode* lup = (SKLabelNode*)[self childNodeWithName:@"lupIndicator"];
    lup.text = @"LEVEL UP!!";
    [lup runAction:[SKAction fadeInWithDuration:2.0]];
    [lup runAction:[SKAction fadeOutWithDuration:2.0]];
    [self addChild:[self newLevelUpNode]];
    
    SKSpriteNode* atemp = (SKSpriteNode*)[self childNodeWithName:@"appa"];
    atemp.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    
    [self spawnClouds];
    
}

-(void)spawnClouds{
    _cloudSpawnTimer = [NSTimer scheduledTimerWithTimeInterval:[self toThePowerOf:0.90 :_level]
                                                        target:self
                                                      selector:@selector(addCloud)
                                                      userInfo:nil
                                                       repeats:YES];
}

-(SKSpriteNode*)newAppa{
    
    SKSpriteNode* appa = [SKSpriteNode spriteNodeWithImageNamed:@"appa-top.png"];
    appa.size = CGSizeMake(40, 100);
    appa.name = @"appa";
    
    appa.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:appa.size];
    appa.physicsBody.dynamic = NO;
    appa.physicsBody.categoryBitMask = bisonCategory;
    appa.physicsBody.contactTestBitMask = obstacleCategory;
    appa.physicsBody.collisionBitMask = obstacleCategory;
    appa.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    
    return appa;
}

-(SKSpriteNode*)newAppaLifeIndicator{
    SKSpriteNode* lifeAppa = [SKSpriteNode spriteNodeWithImageNamed:@"appa-top.png"];
    lifeAppa.size = CGSizeMake(10, 25);
    return lifeAppa;
}



-(SKSpriteNode*)newLeftButton{
    SKSpriteNode* lButton = [SKSpriteNode spriteNodeWithImageNamed:@"leftArrow"];
    lButton.name = @"lButton";
    lButton.size = CGSizeMake(30,30);
    lButton.position = CGPointMake(40.0, 50);
    return lButton;
}

-(SKSpriteNode*)newRightButton{
    SKSpriteNode* rButton = [SKSpriteNode spriteNodeWithImageNamed:@"rightArrow"];
    rButton.name = @"rButton";
    rButton.size = CGSizeMake(30,30);
    rButton.position = CGPointMake(self.size.width-40, 50);
    return rButton;
}

-(SKSpriteNode*)newStatusBar{
    SKSpriteNode* sBar = [SKSpriteNode spriteNodeWithColor:[SKColor orangeColor] size:CGSizeMake(self.size.width*2, 40)];
    sBar.name = @"sBar";
    sBar.position = CGPointMake(0, self.size.height-84);
    return sBar;
}

-(SKLabelNode*)newScoreNode{
    SKLabelNode* sIndicator = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    sIndicator.name = @"sIndicator";
    sIndicator.text = [NSString stringWithFormat:@"Score: %i", _score];
    sIndicator.fontSize = 18;
    sIndicator.position = CGPointMake(self.size.width-60, self.size.height-90);
    return sIndicator;
}

-(SKLabelNode*)newLevelNode{
    SKLabelNode* lIndicator = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lIndicator.name = @"lIndicator";
    lIndicator.text = [NSString stringWithFormat:@"Level: %i", _level];
    lIndicator.fontSize = 18;
    lIndicator.position = CGPointMake(47, self.size.height-90);
    return lIndicator;
}

-(SKLabelNode*)newLevelUpNode{
    SKLabelNode* lupIndicator = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    lupIndicator.name = @"lupIndicator";
    lupIndicator.text = @"";
    lupIndicator.fontSize = 18;
    lupIndicator.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    return lupIndicator;
}


-(void) addCloud{
    SKSpriteNode* cloud = [[SKSpriteNode alloc] initWithImageNamed:@"rock.png"];
    cloud.size = CGSizeMake(10,10);
    cloud.position = CGPointMake(skRand(0,self.size.width), self.size.height-50);
    cloud.name = @"cloud";
    cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cloud.size];
    cloud.physicsBody.dynamic = YES;
    cloud.physicsBody.usesPreciseCollisionDetection = YES;
    cloud.physicsBody.categoryBitMask = obstacleCategory;
    cloud.physicsBody.contactTestBitMask = bisonCategory;
    cloud.physicsBody.collisionBitMask = bisonCategory;
    [self addChild:cloud];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"lButton"]){
        _moveLeftTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                         target:self
                                                       selector:@selector(moveAppaLeft)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    else if([node.name isEqualToString:@"rButton"]){
        _moveRightTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(moveAppaRight)
                                                        userInfo:nil
                                                         repeats:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [_moveLeftTimer invalidate];
    _moveLeftTimer = nil;
    [_moveRightTimer invalidate];
    _moveRightTimer = nil;
}

-(void)moveAppaLeft{
    SKSpriteNode* appa = (SKSpriteNode*)[self childNodeWithName:@"appa"];
    [appa runAction:[SKAction moveByX:-15 y:0 duration:0.1]];
}

-(void)moveAppaRight{
    SKSpriteNode* appa = (SKSpriteNode*)[self childNodeWithName:@"appa"];
    [appa runAction:[SKAction moveByX:15 y:0 duration:0.1]];
}

-(void)updateScore{
    _score += 20;
    SKLabelNode* scoreGetter = (SKLabelNode*)[self childNodeWithName:@"sIndicator"];
    scoreGetter.text = [NSString stringWithFormat:@"Score: %i", _score];
    
    if(_score%500 == 0 && _score != 0){
        [self nextLevel];
    }
}

-(void)nextLevel{
    _level += 1;
    SKLabelNode* levelGetter = (SKLabelNode*)[self childNodeWithName:@"lIndicator"];
    levelGetter.text = [NSString stringWithFormat:@"Level: %i", _level];
    
    [self restartGame];
    
}

-(void)loseLife{
    
    SKSpriteNode* lifeIndicator = (SKSpriteNode*)[self childNodeWithName:[NSString stringWithFormat:@"life%d",_numLives]];
    [lifeIndicator removeFromParent];
    
    _numLives --;
    
    if(_numLives == 0){
        [self gameOver];
    }
    
    else{
        [_cloudSpawnTimer invalidate];
        _cloudSpawnTimer = nil;
        
        [self enumerateChildNodesWithName:@"cloud" usingBlock:^(SKNode *node, BOOL *stop) {
            [node removeFromParent];
        }];
        
        SKLabelNode* lup = (SKLabelNode*)[self childNodeWithName:@"lupIndicator"];
        lup.text = @"YOU LOSE A LIFE";
        [lup runAction:[SKAction fadeInWithDuration:2.0]];
        [lup runAction:[SKAction fadeOutWithDuration:2.0]];
        
        SKSpriteNode* atemp = (SKSpriteNode*)[self childNodeWithName:@"appa"];
        atemp.position = CGPointMake(CGRectGetMidX(self.frame), 50);
        
        [self spawnClouds];
    }

}

-(void)gameOver{
    [_cloudSpawnTimer invalidate];
    _cloudSpawnTimer = nil;
    
    [self enumerateChildNodesWithName:@"cloud" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    SKLabelNode* lup = (SKLabelNode*)[self childNodeWithName:@"lupIndicator"];
    lup.text = @"GAME OVER";
    [lup runAction:[SKAction fadeInWithDuration:2.0]];
    [lup runAction:[SKAction fadeOutWithDuration:2.0]];
    
    if(_score < [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"]){
        _score = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
    }
    
    lup.text = [NSString stringWithFormat:@"HIGH SCORE: %i", _score];
    [lup runAction:[SKAction fadeInWithDuration:2.0]];
    
    [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:@"highScore"];
    
    SKSpriteNode* atemp = (SKSpriteNode*)[self childNodeWithName:@"appa"];
    atemp.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    [atemp removeFromParent];
}

-(void)didSimulatePhysics{
    [self enumerateChildNodesWithName:@"cloud" usingBlock:^(SKNode *node, BOOL *stop){
        if(node.position.y < 0){
            [self updateScore];
            [node removeFromParent];
        }
    }];
}

- (void)didBeginContact:(SKPhysicsContact *)contact{
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
        [self loseLife];
    }
}

-(float)toThePowerOf:(float)x :(float)y{
    if(y==0){
        return 1;
    }
    else{
        return x * [self toThePowerOf:x :y-1];
    }
}

@end
