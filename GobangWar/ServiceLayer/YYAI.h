//
//  YYAI.h
//  GobangWar
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYPoint.h"

typedef NS_ENUM(NSInteger, WeighingValue) {
    WeighingValue0 = 0, //可落子的点
    WeighingValue1,      //用户占领的点
    WeighingValue2,       //AI占领的点
    WeighingValue3,   //未知的点
};

typedef NS_ENUM(NSInteger, OccupyType) {
    OccupyTypeEmpty = 0, //可落子的点
    OccupyTypeUser,      //用户占领的点
    OccupyTypeAI ,       //AI占领的点
    OccupyTypeUnknown,   //未知的点
};

@interface YYPointData : NSObject

@property (nonatomic, strong) YYPoint *p;  /** 点对象 */
@property (nonatomic, assign) int count;

- (instancetype)initWithPoint:(YYPoint *)point count:(int)count;

@end

@interface YYOmni : NSObject
/** 场上所有棋子的数组 */
@property (nonatomic, strong) NSMutableArray *curBoard;
/** 代表用户的OccupyType */
@property (nonatomic, assign) OccupyType oppoType;
/** 代表AI的OccupyType */
@property (nonatomic, assign) OccupyType myType;
/**
 *  @brief    初始化YYOmni
 *  @param    arr     curBoard棋子的数组
 *  @param    opp     oppoType用户的棋子
 *  @param    my      myType AI的棋子
 *  @return   instancetype
 */
- (instancetype)initWithArr:(NSMutableArray *)arr opp:(OccupyType)opp my:(OccupyType)my;
/**
 *  @brief    是否能形成对应Type下num个数的连珠
 *  @param    pp         YYPoint对象
 *  @param    num        连珠的个数
 *  @param    xType      连珠的类型
 *  @return   BOOL
 */
- (BOOL)isStepEmergent:(YYPoint *)pp Num:(int)num type:(OccupyType)xType;

@end
#pragma mark - **************** 管理类
@interface YYAI : NSObject
@property (nonatomic, assign) NSInteger level;
+ (YYPoint *)geablog:(NSMutableArray *)board type:(OccupyType)type level:(NSInteger)level;
+ (YYPoint *)SeraphTheGreat:(NSMutableArray *)board type:(OccupyType)type;
+ (YYPoint *)SeraphTheGreat:(NSMutableArray *)board type:(OccupyType)type level:(NSInteger)level;

@end
