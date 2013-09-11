//
//  Rock.m
//  Bang
//
//  Created by Jun Lin on 9/11/13.
//  Copyright (c) 2013 Jun. All rights reserved.
//

#import "Rock.h"

@implementation Rock
-(Rock *)init
{
    self = [super initWithColor:[SKColor brownColor] size:CGSizeMake(8,8)];
    self.name = @"rock";
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.categoryBitMask = RockCategory;
    self.physicsBody.collisionBitMask = SpaceshipCategory;
    self.physicsBody.contactTestBitMask = SpaceshipCategory;

    return self;
}
@end
