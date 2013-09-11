//
//  SpaceshipScene.m
//  Bang
//
//  Created by Jun Lin on 9/8/13.
//  Copyright (c) 2013 Jun. All rights reserved.
//

#import "SpaceshipScene.h"

@interface SpaceshipScene ()
@property BOOL contentCreated;
@end

@implementation SpaceshipScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.physicsWorld.contactDelegate = self;
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;

    // Spaceship
    Spaceship *spaceship = [[Spaceship alloc] init];
    spaceship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame) + 64);
    [self addChild:spaceship];

    // Rocks
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(addRock) onTarget:self],
                                                [SKAction waitForDuration:0.40 withRange:0.15]
                                                ]];
    [self runAction: [SKAction repeatActionForever:makeRocks]];
}

static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}

- (void)addRock
{
    Rock *rock = [[Rock alloc] init];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height-50);
    [self addChild:rock];
}

- (void)destroyNode:(SKNode *)node
{
    [node removeFromParent];

    SKEmitterNode *fire =  [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"]];
    fire.position = node.position;

    [self addChild:fire];

    SKAction *disappear = [SKAction group:@[
                                          [SKAction scaleBy:0.3 duration:1],
                                          [SKAction fadeOutWithDuration:1]
                                          ]];

    [fire runAction:disappear completion:^{
        [fire removeFromParent];
    }];
}

#pragma mark - Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        [self moveSpaceshipToLocation:touchLocation duration:0.1];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint touchLocation = [touch locationInNode:self];
        [self moveSpaceshipToLocation:touchLocation duration:0];
    }
}

- (void)moveSpaceshipToLocation:(CGPoint)location duration:(NSTimeInterval)sec
{
    Spaceship *spaceship = (Spaceship *)[self childNodeWithName:@"spaceship"];
    if (spaceship != nil) {
        [spaceship moveToLocation:location duration:sec];
    }
}

#pragma mark - Physics
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;

    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }

    [self destroyNode:firstBody.node];
}

- (void)didEndContact:(SKPhysicsContact *)contact
{

}

- (void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"rock" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y < 0)
            [node removeFromParent];
    }];
}
@end
