//
//  YYPoint.h
//  GobangWar
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#pragma mark - **************** 替换系统的CGPoint 

#import <Foundation/Foundation.h>

@interface YYPoint : NSObject

@property (nonatomic, assign) NSInteger x;
@property (nonatomic, assign) NSInteger y;

- (instancetype)initPointWith:(NSInteger)x y:(NSInteger)y;

@end
