//
//  YYPoint.m
//  GobangWar
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import "YYPoint.h"

@implementation YYPoint

- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y {
    
    self = [self init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    return self;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.x = -1;
        self.y = -1;
    }
    
    return self;
}

@end
