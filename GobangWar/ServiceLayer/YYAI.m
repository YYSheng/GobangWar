//
//  YYAI.m
//  GobangWar
//
//  Created by Apple on 2017/4/13.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import "YYAI.h"

static NSInteger kBoardSize = 17;

#pragma mark - **************** YYPointData
@implementation YYPointData

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.p = [[YYPoint alloc] initPointWith:-1 y:-1];
        self.count = 0;
    }
    
    return self;
}

- (instancetype)initWithPoint:(YYPoint *)point count:(int)ncount {
    
    self = [self init];
    if (self) {
        //        self.p = point;
        self.p = [[YYPoint alloc] initPointWith:-1 y:-1];
        self.p.x = point.x;
        self.p.y = point.y;
        self.count = ncount;
    }
    
    return self;
}

@end

#pragma mark - **************** YYOmni
@implementation YYOmni

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.oppoType = OccupyTypeEmpty;
        self.myType = OccupyTypeEmpty;
    }
    
    return self;
}

- (instancetype)initWithArr:(NSMutableArray *)arr opp:(OccupyType)opp my:(OccupyType)my {
    
    self = [self init];
    if (self) {
        self.curBoard = arr;
        self.oppoType = opp;
        self.myType = my;
    }
    
    return self;
}
/** 查找pp点的8个方向有无对应type类型的num个数的连珠  并且左右两侧都是可以落子的空点返回YES */
- (int)stepCountWithEmergent:(YYPoint *)pp Num:(int)num type:(OccupyType)xType {
    int count = 0;
    //    NSLog(@"is Step emergent");
    
    YYPoint* check = [[YYPoint alloc] initPointWith:pp.x y:pp.y];
    if (![self checkPoint:check]) {
        return NO;
    } else {
        YYPoint *star = [[YYPoint alloc]initPointWith:check.x y:check.y];  //中心点
        YYPoint *left = [[YYPoint alloc]initPointWith:star.x-num y:star.y];  //中心点左侧的点
        YYPoint *top = [[YYPoint alloc]initPointWith:star.x y:star.y-num];  //中心点上侧的点
        YYPoint *topLeft = [[YYPoint alloc]initPointWith:star.x-num y:star.y-num];  //中心点上左的点
        YYPoint *topRight = [[YYPoint alloc]initPointWith:star.x+num y:star.y-num];  //中心点上右的点
        for (int i = 0; i < num + 1; i ++) {
            int number = 0;
            for (int f = 0; f < num + 1; f ++) {
                if ([self checkPoint:left]) {
                    if ([self.curBoard[(int)left.x][(int)left.y] integerValue] == xType) {
                        number ++;
                    }
                }
                left = [[YYPoint alloc]initPointWith:left.x+1 y:left.y];
                
            }
            if (number >= num) {
                count++;
            }
            left = [[YYPoint alloc]initPointWith:check.x-num + i + 1 y:check.y];
            
        }
        
        for (int i = 0; i < num + 1; i ++) {
            int number = 0;
            for (int f = 0; f < num + 1; f ++) {
                if ([self checkPoint:top]) {
                    if ([self.curBoard[(int)top.x][(int)top.y] integerValue] == xType) {
                        number ++;
                    }
                }
                top = [[YYPoint alloc]initPointWith:top.x y:top.y+1];
                
            }
            if (number >= num) {
                count++;
            }
            top = [[YYPoint alloc]initPointWith:check.x y:check.y-num + i + 1];
            
        }
        
        for (int i = 0; i < num + 1; i ++) {
            int number = 0;
            for (int f = 0; f < num + 1; f ++) {
                if ([self checkPoint:topLeft]) {
                    if ([self.curBoard[(int)topLeft.x][(int)topLeft.y] integerValue] == xType) {
                        number ++;
                    }
                }
                topLeft = [[YYPoint alloc]initPointWith:topLeft.x+1 y:topLeft.y+1];
                
            }
            if (number >= num) {
                count++;
            }
            topLeft = [[YYPoint alloc]initPointWith:check.x-num + i + 1 y:check.y-num + i + 1];
            
        }
        
        for (int i = 0; i < num + 1; i ++) {
            int number = 0;
            for (int f = 0; f < num + 1; f ++) {
                if ([self checkPoint:topRight]) {
                    if ([self.curBoard[(int)topRight.x][(int)topRight.y] integerValue] == xType) {
                        number ++;
                    }
                }
                topRight = [[YYPoint alloc]initPointWith:topRight.x-1 y:topRight.y+1];
                
            }
            if (number >= num) {
                count++;
            }
            topRight = [[YYPoint alloc]initPointWith:check.x + num - i - 1 y:check.y - num + i + 1];
            
        }
            
        
    }

        
    
    return count;
}
/** 查找pp点的8个方向有无对应type类型的num个数的连珠  并且左右两侧都是可以落子的空点返回YES */
- (BOOL)isStepEmergent:(YYPoint *)pp Num:(int)num type:(OccupyType)xType isDouble:(BOOL)dob{
    
    //    NSLog(@"is Step emergent");
    
    YYPoint* check = [[YYPoint alloc] initPointWith:pp.x y:pp.y];
    if (![self checkPoint:check]) {
        return FALSE;
    } else {
        
        YYPoint *test = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 开始进行寻找的点
        YYPoint *testR = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 遍历点的左侧的点
        YYPoint *testL = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 遍历点的右侧的点
        
        testR = [[YYPoint alloc] initPointWith:check.x + 1 y:check.y]; // 开始遍历点的正右侧
        testL = [[YYPoint alloc] initPointWith:check.x - 1 y:check.y]; // 开始遍历的点的正左侧
        
        for(int hi = 1; (test.x+hi < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); hi++) //在相应点向右侧进行遍历，寻找最长的连续距离
            testR = [[YYPoint alloc] initPointWith:testR.x + 1 y:testR.y];
        for(int hii = 1; (test.x-hii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); hii++) //在相应点向左侧进行遍历，寻找最长的连续距离
            testL = [[YYPoint alloc] initPointWith:testR.x - 1 y:testR.y];
        
        if ([self checkPoint:testL] && [self checkPoint:testR]) {// 如果两个点都是可用的
            if (testR.x - testL.x >= num) { // 如果两个点之间的距离大于或等于我们需要的距离
                if (dob) {
                    if ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty || [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty) { // 并且这段连续距离的一侧都是可以落子的空点
                        return true;
                    }
                }else{
                    if ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty) { // 并且这段连续距离的两侧都是可以落子的空点
                        return true;
                    }
                }
            }
        }
        
        
        testR = [[YYPoint alloc] initPointWith:check.x y:check.y + 1]; // 开始遍历点的正下方
        testL = [[YYPoint alloc] initPointWith:check.x y:check.y - 1]; // 开始遍历的点的正上方
        
        for(int vi = 1; (test.y+vi < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); vi++){ // 不断向正下方寻找最长连续
            testR.x = testR.x;
            testR.y = testR.y + 1;
        }
        for(int vii = 1; (test.y-vii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); vii++){ // 不断向正上方寻找最长连续
            //            testL = CGPointMake(testL.x, test.y - 1);
            testL.x = testL.x;
            testL.y = testL.y - 1;
        }
        
        if ([self checkPoint:testL]  && [self checkPoint:testR]) {
            if(testR.y - testL.y >= num)
                if (dob) {
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty || [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty){
                        return true;
                    }
                }else{
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty){
                        return true;
                    }
                }
        }
        
        testR.x = check.x + 1; // 开始遍历点的右下方
        testR.y = check.y + 1;
        testL.x = check.x - 1; // 开始遍历点的左上方
        testL.y = check.y - 1;
        
        // 后面的判断逻辑和上面是相同的 不再赘述
        for(int ri = 1; (test.x+ri < kBoardSize && test.y+ri < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); ri++) {
            testR.x = testR.x + 1;
            testR.y = testR.y + 1;
        }
        //            testR = CGPointMake(testR.x + 1, testR.y + 1);
        
        for(int rii = 1; (test.x-rii >= 0 && test.y-rii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); rii++) {
            
            testL.x = testL.x - 1;
            testL.y = testL.y - 1;
        }
        
        if ([self checkPoint:testL] && [self checkPoint:testR]) {
            if(testR.x - testL.x >= num)
                if (dob) {
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty || [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty){
                        return true;
                    }
                }else{
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty){
                        return true;
                    }
                }
        }
        
        
        testR.x = check.x + 1; // 开始遍历点的右上方
        testR.y = check.y - 1;
        testL.x = check.x - 1; // 开始遍历点的左下方
        testL.y = check.y + 1;
        for(int li = 1; (test.x+li < kBoardSize && test.y-li >= 0) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); li++) {
            //            testR = CGPointMake(testR.x + 1, testR.y - 1);
            testR.x = testR.x + 1;
            testR.y = testR.y - 1;
        }
        
        //            testR.Set(testR.x+1, testR.y-1);
        for(int lii = 1; (test.x-lii >= 0 && test.y+lii < kBoardSize) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); lii++) {
            //            testL = CGPointMake(testL.x - 1, testL.y + 1);
            testL.x = testL.x - 1;
            testL.y = testL.y + 1;
        }
        if ([self checkPoint:testL] && [self checkPoint:testR]) {
            if(testR.x - testL.x >= num)
                if (dob) {
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty){
                        return true;
                    }
                }else if(!dob){
                    if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty)
                        return true;
                }
        }
        
    }
    return FALSE;
}
/** 查找pp点的8个方向有无对应type类型的num个数的连珠  并且左右两侧都是可以落子的空点返回YES */
- (BOOL)isStepEmergent:(YYPoint *)pp Num:(int)num type:(OccupyType)xType {
    
    //    NSLog(@"is Step emergent");
    
    YYPoint* check = [[YYPoint alloc] initPointWith:pp.x y:pp.y];
    if (![self checkPoint:check]) {
        return FALSE;
    } else {
        
        YYPoint *test = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 开始进行寻找的点
        YYPoint *testR = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 遍历点的左侧的点
        YYPoint *testL = [[YYPoint alloc] initPointWith:check.x y:check.y]; // 遍历点的右侧的点
        
        testR = [[YYPoint alloc] initPointWith:check.x + 1 y:check.y]; // 开始遍历点的正右侧
        testL = [[YYPoint alloc] initPointWith:check.x - 1 y:check.y]; // 开始遍历的点的正左侧
        
        for(int hi = 1; (test.x+hi < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); hi++) //在相应点向右侧进行遍历，寻找最长的连续距离
            testR = [[YYPoint alloc] initPointWith:testR.x + 1 y:testR.y];
        for(int hii = 1; (test.x-hii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); hii++) //在相应点向左侧进行遍历，寻找最长的连续距离
            testL = [[YYPoint alloc] initPointWith:testR.x - 1 y:testR.y];
        
        if ([self checkPoint:testL] && [self checkPoint:testR]) {// 如果两个点都是可用的
            if (testR.x - testL.x >= num) { // 如果两个点之间的距离大于或等于我们需要的距离
                if ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty) { // 并且这段连续距离的两侧都是可以落子的空点
                    return true;
                }
            }
        }
        
        
        testR = [[YYPoint alloc] initPointWith:check.x y:check.y + 1]; // 开始遍历点的正下方
        testL = [[YYPoint alloc] initPointWith:check.x y:check.y - 1]; // 开始遍历的点的正上方
        
        for(int vi = 1; (test.y+vi < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); vi++){ // 不断向正下方寻找最长连续
            testR.x = testR.x;
            testR.y = testR.y + 1;
        }
        for(int vii = 1; (test.y-vii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); vii++){ // 不断向正上方寻找最长连续
            //            testL = CGPointMake(testL.x, test.y - 1);
            testL.x = testL.x;
            testL.y = testL.y - 1;
        }
        
        if ([self checkPoint:testL]  && [self checkPoint:testR]) {
            if(testR.y - testL.y >= num)
                if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty)
                    return true;
        }
        
        testR.x = check.x + 1; // 开始遍历点的右下方
        testR.y = check.y + 1;
        testL.x = check.x - 1; // 开始遍历点的左上方
        testL.y = check.y - 1;
        
        // 后面的判断逻辑和上面是相同的 不再赘述
        for(int ri = 1; (test.x+ri < kBoardSize && test.y+ri < kBoardSize) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); ri++) {
            testR.x = testR.x + 1;
            testR.y = testR.y + 1;
        }
        //            testR = CGPointMake(testR.x + 1, testR.y + 1);
        
        for(int rii = 1; (test.x-rii >= 0 && test.y-rii >= 0) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); rii++) {
            
            testL.x = testL.x - 1;
            testL.y = testL.y - 1;
        }
        
        if ([self checkPoint:testL] && [self checkPoint:testR]) {
            if(testR.x - testL.x >= num)
                if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty)
                    return true;
        }
        
        
        testR.x = check.x + 1; // 开始遍历点的右上方
        testR.y = check.y - 1;
        testL.x = check.x - 1; // 开始遍历点的左下方
        testL.y = check.y + 1;
        for(int li = 1; (test.x+li < kBoardSize && test.y-li >= 0) && ([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == xType); li++) {
            //            testR = CGPointMake(testR.x + 1, testR.y - 1);
            testR.x = testR.x + 1;
            testR.y = testR.y - 1;
        }
        
        //            testR.Set(testR.x+1, testR.y-1);
        for(int lii = 1; (test.x-lii >= 0 && test.y+lii < kBoardSize) && ([self.curBoard[(int)testL.x][(int)testL.y] integerValue] == xType); lii++) {
            //            testL = CGPointMake(testL.x - 1, testL.y + 1);
            testL.x = testL.x - 1;
            testL.y = testL.y + 1;
        }
        if ([self checkPoint:testL] && [self checkPoint:testR]) {
            if(testR.x - testL.x >= num)
                if([self.curBoard[(int)testR.x][(int)testR.y] integerValue] == OccupyTypeEmpty && [self.curBoard[(int)testL.x][(int)testL.y] integerValue] == OccupyTypeEmpty)
                    return true;
        }
        
    }
    return FALSE;
}
/** point点是否在棋盘上 */
- (BOOL)checkPoint:(YYPoint *)point {
    
    // 如果一个点的X Y 坐标都大于等于0且小于棋盘大小时才认为可用
    
    if (((int)point.x >= 0 && (int)point.x < kBoardSize) && ((int)point.y >= 0 && (int)point.y < kBoardSize)) {
        return YES;
    }
    return NO;
}
/**
 *  @brief    从(x,y)点开始四个方向遍历寻找是否有thre个的连珠点 (该方法是个递归方法会无限查找下一个点，直到结束)
 *  @param    xType       点的类型
 *  @param    num         将要形成连珠的个数
 *  @param    threshold   已经形成连珠的个数
 *  @param    startX      中心点的X
 *  @param    startY      中心点的y
 *  @return   YYPoint
 */
- (YYPoint *)nextStep:(OccupyType)xType num:(int)num thre:(int)threshold x:(int)startX y:(int)startY {
    
    YYPoint *search = [[YYPoint alloc] initPointWith:startX y:startY];
    YYPoint * hPoint;
    YYPoint * vPoint;
    YYPoint * rPoint;
    YYPoint * lPoint;
    // 横向上寻找形成的num连珠的起始点
    hPoint = [self horizontal:search type:xType num:num thre:threshold];
    // 竖向上寻找形成的num连珠的起始点
    vPoint = [self vertical:search type:xType num:num thre:threshold];
    // 右下方向上寻找形成的num连珠的起始点
    rPoint = [self rightDown:search type:xType num:num thre:threshold];
    // 左下方向上寻找形成的num连珠的起始点
    lPoint = [self leftDown:search type:xType num:num thre:threshold];
    
    if(num == 5){
        if([self checkPoint:hPoint])// 表示找到胜利的五子连珠了
            return hPoint;
        if([self checkPoint:vPoint])
            return vPoint;
        if([self checkPoint:rPoint])
            return rPoint;
        if([self checkPoint:lPoint])
            return lPoint;
    } else{
        
        while([self checkPoint:hPoint] && ![self isStepEmergent:hPoint Num:num type:xType]){
            hPoint = [self horizontal:[self getNextPoint:hPoint] type:xType num:num thre:threshold];//在横向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:hPoint Num:num type:xType])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return hPoint;
        
        
        while([self checkPoint:vPoint] && ![self isStepEmergent:vPoint Num:num type:xType]){
            vPoint = [self vertical:[self getNextPoint:vPoint] type:xType num:num thre:threshold]; //在竖向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:vPoint Num:num type:xType])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return vPoint;
        
        while([self checkPoint:rPoint] && ![self isStepEmergent:rPoint Num:num type:xType]){
            rPoint = [self rightDown:[self getNextPoint:rPoint] type:xType num:num thre:threshold]; //在右下向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:rPoint Num:num type:xType])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return rPoint;
        
        while([self checkPoint:lPoint] && ![self isStepEmergent:lPoint Num:num type:xType]){
            lPoint = [self leftDown:[self getNextPoint:lPoint] type:xType num:num thre:threshold];//在左下向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:lPoint Num:num type:xType])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return lPoint;
    }
    
    YYPoint * invalid = [[YYPoint alloc] init];
    return invalid;
}
- (YYPoint *)nextStep:(OccupyType)xType num:(int)num thre:(int)threshold x:(int)startX y:(int)startY isDouble:(BOOL)dob{
    
    YYPoint *search = [[YYPoint alloc] initPointWith:startX y:startY];
    YYPoint * hPoint;
    YYPoint * vPoint;
    YYPoint * rPoint;
    YYPoint * lPoint;
    // 横向上寻找形成的num连珠的起始点
    hPoint = [self horizontal:search type:xType num:num thre:threshold];
    // 竖向上寻找形成的num连珠的起始点
    vPoint = [self vertical:search type:xType num:num thre:threshold];
    // 右下方向上寻找形成的num连珠的起始点
    rPoint = [self rightDown:search type:xType num:num thre:threshold];
    // 左下方向上寻找形成的num连珠的起始点
    lPoint = [self leftDown:search type:xType num:num thre:threshold];
    
    if(num == 5){
        if([self checkPoint:hPoint])// 表示找到胜利的五子连珠了
            return hPoint;
        if([self checkPoint:vPoint])
            return vPoint;
        if([self checkPoint:rPoint])
            return rPoint;
        if([self checkPoint:lPoint])
            return lPoint;
    } else{
        
        while([self checkPoint:hPoint] && ![self isStepEmergent:hPoint Num:num type:xType isDouble:dob]){
            hPoint = [self horizontal:[self getNextPoint:hPoint] type:xType num:num thre:threshold];//在横向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:hPoint Num:num type:xType isDouble:dob])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return hPoint;
        
        
        while([self checkPoint:vPoint] && ![self isStepEmergent:vPoint Num:num type:xType isDouble:dob]){
            vPoint = [self vertical:[self getNextPoint:vPoint] type:xType num:num thre:threshold]; //在竖向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:vPoint Num:num type:xType isDouble:dob])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return vPoint;
        
        while([self checkPoint:rPoint] && ![self isStepEmergent:rPoint Num:num type:xType isDouble:dob]){
            rPoint = [self rightDown:[self getNextPoint:rPoint] type:xType num:num thre:threshold]; //在右下向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:rPoint Num:num type:xType isDouble:dob])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return rPoint;
        
        while([self checkPoint:lPoint] && ![self isStepEmergent:lPoint Num:num type:xType isDouble:dob]){
            lPoint = [self leftDown:[self getNextPoint:lPoint] type:xType num:num thre:threshold];//在左下向上寻找threshold连续且可以形成num连续的点
        }
        if([self isStepEmergent:lPoint Num:num type:xType isDouble:dob])// 在找到threshold连续的点并且两侧可以落子后，返回该点
            return lPoint;
    }
    
    YYPoint * invalid = [[YYPoint alloc] init];
    return invalid;
}

/** 判断有无多活3 或者多活2 V型棋 */
- (YYPoint *)manyLiveWithType:(OccupyType)xType num:(int)num thre:(int)threshold x:(int)startX y:(int)startY {
    
    YYPoint *search = [[YYPoint alloc] initPointWith:startX y:startY];
    YYPoint * hPoint;
    YYPoint * vPoint;
    YYPoint * rPoint;
    YYPoint * lPoint;
    // 横向上寻找形成的num连珠的起始点
    hPoint = [self horizontal:search type:xType num:num thre:threshold];
    // 竖向上寻找形成的num连珠的起始点
    vPoint = [self vertical:search type:xType num:num thre:threshold];
    // 右下方向上寻找形成的num连珠的起始点
    rPoint = [self rightDown:search type:xType num:num thre:threshold];
    // 左下方向上寻找形成的num连珠的起始点
    lPoint = [self leftDown:search type:xType num:num thre:threshold];
    
    if(num == 5){
        if([self checkPoint:hPoint])// 表示找到胜利的五子连珠了
            return hPoint;
        if([self checkPoint:vPoint])
            return vPoint;
        if([self checkPoint:rPoint])
            return rPoint;
        if([self checkPoint:lPoint])
            return lPoint;
    } else{
        
        return [self pointWithSeath:search type:xType num:num thres:threshold];
    }
    
    YYPoint * invalid = [[YYPoint alloc] init];
    return invalid;
}
/** 查找点的8个方向有无多活 */
- (YYPoint *)pointWithSeath:(YYPoint *)seath type:(OccupyType)type num:(int)num thres:(int)threshold{
    YYPoint * point = [[YYPoint alloc] init];
    for (int i = 0; i < kBoardSize * kBoardSize; i ++) {
        if ([self.curBoard[(int)seath.x][(int)seath.y] integerValue] == OccupyTypeEmpty) {
            if ([self stepCountWithEmergent:seath Num:threshold type:type] > 1) {
                return seath;
            }
        }
        seath = [self getNextPoint:seath];
        
    }
    return point;
}
/** 横向上寻找形成的num连珠的起始点 */
- (YYPoint *)horizontal:(YYPoint *)pp type:(OccupyType)xType num:(int)num thre:(int)threshold {
    
    if (![self checkPoint:pp]) {
        return pp;
    }
    
    int count = 0;
    YYPoint *solution = [[YYPoint alloc] init];
    for(int ii = 0; ii < num; ii++){
        
        NSInteger x = (int)(pp.x) + ii; // 在横向上逐渐寻找下一个点
        NSInteger y = (int)pp.y;
        
        if (x < kBoardSize) {
            if([self.curBoard[x][(int)pp.y] integerValue] == xType){ // 如果满足了一定连续条件
                count ++;
            }
            
            if([self.curBoard[x][(int)pp.y] integerValue] == OccupyTypeEmpty) { // 在横向上找到了一个空点
                solution.x = x;
                solution.y = y;
            }
        }
        
    }
    if(count >= threshold && [self checkPoint:solution])// 如果找到了我们希望的连珠个数，并且这些连珠之后还有可以落子的点
        return solution;
    
    return [self horizontal:[self getNextPoint:pp] type:xType num:num thre:threshold]; // 否则以递归的方式向后一个点进行遍历
}
/** 竖向上寻找形成的num连珠的起始点 */
- (YYPoint *)vertical:(YYPoint *)pp type:(OccupyType)xType num:(int)num thre:(int)threshold {
    
    if (![self checkPoint:pp]) {
        return pp;
    }
    
    //    NSLog(@"in vertical pp.x is %@, pp.y is %@", @(pp.x), @(pp.y));
    
    int count = 0;
    YYPoint *solution = [[YYPoint alloc] init];
    for(int ii = 0; ii < num; ii++){
        
        NSInteger x = (int)(pp.x);
        NSInteger y = (int)pp.y + ii;// 在竖向上逐渐寻找下一个点
        
        if (y < kBoardSize) {
            if([self.curBoard[x][y] integerValue] == xType){
                count ++;
            }
            
            if([self.curBoard[x][y] integerValue] == OccupyTypeEmpty) {
                solution.x = pp.x;
                solution.y = pp.y + ii;
            }
        }
        
    }
    if(count >= threshold && [self checkPoint:solution])
        return solution;
    
    return [self vertical:[self getNextPoint:pp] type:xType num:num thre:threshold];
}
/** 右下方向上寻找形成的num连珠的起始点 */
- (YYPoint *)rightDown:(YYPoint *)pp type:(OccupyType)xType num:(int)num thre:(int)threshold {
    
    //    if(!pp.Valid())
    //        return pp;
    if (![self checkPoint:pp]) {
        return pp;
    }
    
    int count = 0;
    YYPoint *solution = [[YYPoint alloc] init];
    for(int ii = 0; ii < num; ii++){
        NSInteger x = (int)(pp.x + ii);// 在右下向上逐渐寻找下一个点
        NSInteger y = (int)pp.y + ii;
        
        if ((pp.x+ii < kBoardSize) &&
            (pp.y+ii < kBoardSize)) {
            if(([self.curBoard[x][y] integerValue] == xType))
                count ++;
            
            if([self.curBoard[x][y] integerValue] == OccupyTypeEmpty) {
                solution.x = pp.x+ ii;
                solution.y = pp.y + ii;
            }
        }
        
    }
    if(count >= threshold && [self checkPoint:solution])
        return solution;
    
    //    return rightDown(getNextPoint(pp), xType, num, threshold);
    return [self rightDown:[self getNextPoint:pp] type:xType num:num thre:threshold];
}
/** 左下方向上寻找形成的num连珠的起始点 */
- (YYPoint *)leftDown:(YYPoint *)pp type:(OccupyType)xType num:(int)num thre:(int)threshold {
    
    if(![self checkPoint:pp])
        return pp;
    
    int count = 0;
    YYPoint *solution = [[YYPoint alloc] init];
    for(int ii = 0; ii < num; ii++){
        
        NSInteger x = (int)(pp.x - ii);// 在左下向上逐渐寻找下一个点
        NSInteger y = (int)pp.y + ii;
        
        if ((pp.x-ii >= 0) &&
            (pp.y+ii < kBoardSize)) {
            if(([self.curBoard[x][y] integerValue] == xType))
                count ++;
            //                solution = CGPointMake(pp.x - ii, pp.y + ii);
            
            if([self.curBoard[x][y] integerValue] == OccupyTypeEmpty) {
                solution.x = pp.x - ii;
                solution.y = pp.y + ii;
            }
        }
        
        
        //            solution.Set(pp.x-ii, pp.y+ii);
    }
    if(count >= threshold && [self checkPoint:solution])
        return solution;
    
    //    return leftDown(getNextPoint(pp), xType, num, threshold);
    return [self leftDown:[self getNextPoint:pp] type:xType num:num thre:threshold];
}
/** 获取下一个点 */
- (YYPoint *)getNextPoint:(YYPoint *)pp {
    
    YYPoint *result = [[YYPoint alloc] init];
    result.x = pp.x;
    result.y = pp.y;
    if(pp.x+1 < kBoardSize){
        result.x = pp.x + 1; //如果下一个点在同一排 则返回下一个
        result.y = pp.y;
        return result;
    }
    result.x = 0; // 否则返回下一排第一个
    result.y = pp.y + 1;
    return result;
}

@end

#pragma mark - **************** YYAI
@implementation YYAI

+ (YYPoint *)geablog:(NSMutableArray *)board type:(OccupyType)type level:(NSInteger)level{
    if (level != 1) {
        YYPoint *calibur = [[self class] SeraphTheGreat:board type:type level:level];
        return calibur;
    }
    YYPoint *calibur = [[self class] SeraphTheGreat:board type:type];
    return calibur;
}
/** 先便利棋盘上面的点，找到AI的棋子有活四，死四的点，既下一步能形成5个点的落子点，找到就直接在此点落子。
 
 如果没找到，就遍历玩家活四，或者死四的点，并在此进行落点进行防守，虽然活四没法防守。
 
 然后这两个点都没找到的话，就直接找AI有形成活三，或者死三的点，进行落子进攻。
 
 如果没找到，就找用户能形成活三，死三的点进行防守。就这样简单的进行交互。 */
+ (YYPoint *)SeraphTheGreat:(NSMutableArray *)board type:(OccupyType)myType {
    
    YYOmni *omniknight = [[YYOmni alloc] init];
    if(myType == OccupyTypeUser)
        
        omniknight = [[YYOmni alloc] initWithArr:board opp:OccupyTypeAI my:OccupyTypeUser];
    else
        
        omniknight = [[YYOmni alloc] initWithArr:board opp:OccupyTypeUser my:OccupyTypeAI];
    YYPoint *calibur;
    
    calibur = [omniknight nextStep:omniknight.myType num:5 thre:4 x:0 y:0];// 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有4子连珠并且可以形成5子连珠的点
    if([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成进攻或直接胜利
        return calibur;
    }
    
    calibur = [omniknight nextStep:omniknight.oppoType num:5 thre:4 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有4子连珠并且可以形成5子连珠的点
    if ([omniknight checkPoint:calibur]) { // 如果有 则在此落子进行防守
        return calibur;
    }
    
    calibur = [omniknight nextStep:omniknight.myType num:4 thre:3 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有3子连珠并且可以形成4子连珠的点
    if([omniknight checkPoint:calibur])// 如果有 在此摆子形成进攻
        
        return calibur;
    
    calibur = [omniknight nextStep:omniknight.oppoType num:4 thre:3 x:0 y:0];  // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有3子连珠并且可以形成4子连珠的点
    if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
        return calibur;
    }
    
    calibur = [omniknight nextStep:omniknight.myType num:3 thre:2 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有2子连珠并且可以形成3子连珠的点
    if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
        return calibur;
    
    calibur = [omniknight nextStep:omniknight.myType num:2 thre:1 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有1子连珠并且可以形成2子连珠的点
    if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
        return calibur;
    
    calibur = [omniknight nextStep:omniknight.oppoType num:3 thre:2 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有2子连珠并且可以形成3子连珠的点
    if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
        return calibur;
    }
    
    calibur = [omniknight nextStep:omniknight.oppoType num:2 thre:1 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有1子连珠并且可以形成2子连珠的点
    if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
        return calibur;
    }
    
    //  如果什么都没有则返回不可用的点
    YYPoint *sad = [[YYPoint alloc] initPointWith:(kBoardSize+1)/2 y:(kBoardSize+1)/2];
    return sad;
}
+ (YYPoint *)SeraphTheGreat:(NSMutableArray *)board type:(OccupyType)myType level:(NSInteger)level{
    YYOmni *omniknight = [[YYOmni alloc] init];
    if(myType == OccupyTypeUser)
        
        omniknight = [[YYOmni alloc] initWithArr:board opp:OccupyTypeAI my:OccupyTypeUser];
    else
        
        omniknight = [[YYOmni alloc] initWithArr:board opp:OccupyTypeUser my:OccupyTypeAI];
    YYPoint *calibur;
    if (level == 1) {
        //  如果什么都没有则返回不可用的点
        YYPoint *sad = [[YYPoint alloc] initPointWith:(kBoardSize+1)/2 y:(kBoardSize+1)/2];
        return sad;
    }else if (level == 2){
        calibur = [omniknight nextStep:omniknight.myType num:5 thre:4 x:0 y:0];// 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有4子连珠并且可以形成5子连珠的点
        if([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成进攻或直接胜利
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.oppoType num:5 thre:4 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有4子连珠并且可以形成5子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 则在此落子进行防守
            return calibur;
        }
        
        /** 在这里判断有无多活3  有则防守 */
//        calibur = [omniknight manyLiveWithType:omniknight.oppoType num:4 thre:3 x:0 y:0];
//        if ([omniknight checkPoint:calibur]) {
//            return calibur;
//        }
        
        calibur = [omniknight nextStep:omniknight.myType num:4 thre:3 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有3子连珠并且可以形成4子连珠的点
        if([omniknight checkPoint:calibur])// 如果有 在此摆子形成进攻
            return calibur;
        calibur = [omniknight nextStep:omniknight.myType num:4 thre:3 x:0 y:0 isDouble:YES]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有3子连珠并且可以形成4子连珠的点
        if([omniknight checkPoint:calibur])// 如果有 在此摆子形成进攻
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.oppoType num:4 thre:3 x:0 y:0];  // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有3子连珠并且可以形成4子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        /** 在这里判断有没有多活2  有则防守 */
        calibur = [omniknight manyLiveWithType:omniknight.oppoType num:3 thre:2 x:0 y:0];
        if ([omniknight checkPoint:calibur]) {
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.myType num:3 thre:2 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有2子连珠并且可以形成3子连珠的点
        if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.myType num:2 thre:1 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有1子连珠并且可以形成2子连珠的点
        if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.oppoType num:3 thre:2 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有2子连珠并且可以形成3子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.oppoType num:2 thre:1 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有1子连珠并且可以形成2子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        //  如果什么都没有则返回不可用的点
        YYPoint *sad = [[YYPoint alloc] initPointWith:(kBoardSize+1)/2 y:(kBoardSize+1)/2];
        return sad;
    }else if (level == 3){
        calibur = [omniknight nextStep:omniknight.myType num:5 thre:4 x:0 y:0];// 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有4子连珠并且可以形成5子连珠的点
        if([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成进攻或直接胜利
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.oppoType num:5 thre:4 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有4子连珠并且可以形成5子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 则在此落子进行防守
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.myType num:4 thre:3 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有3子连珠并且可以形成4子连珠的点
        if([omniknight checkPoint:calibur])// 如果有 在此摆子形成进攻
            
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.oppoType num:4 thre:3 x:0 y:0];  // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有3子连珠并且可以形成4子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.myType num:3 thre:2 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有2子连珠并且可以形成3子连珠的点
        if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.oppoType num:3 thre:2 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有2子连珠并且可以形成3子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        calibur = [omniknight nextStep:omniknight.myType num:2 thre:1 x:0 y:0]; // 以AI自己的角度观察场上形势，从（0， 0）点开始遍历，寻找是否有1子连珠并且可以形成2子连珠的点
        if([omniknight checkPoint:calibur]) // 如果有 在此摆子形成进攻
            return calibur;
        
        calibur = [omniknight nextStep:omniknight.oppoType num:2 thre:1 x:0 y:0]; // AI以用户的角度观察场上形势，从（0， 0）点开始遍历，寻找用户棋子排放是否有1子连珠并且可以形成2子连珠的点
        if ([omniknight checkPoint:calibur]) { // 如果有 在此摆子形成防守
            return calibur;
        }
        
        //  如果什么都没有则返回不可用的点
        YYPoint *sad = [[YYPoint alloc] initPointWith:(kBoardSize+1)/2 y:(kBoardSize+1)/2];
        return sad;
    }else{
        //  如果什么都没有则返回不可用的点
        YYPoint *sad = [[YYPoint alloc] initPointWith:(kBoardSize+1)/2 y:(kBoardSize+1)/2];
        return sad;
    }
    
}
@end

