//
//  GobangView.m
//  GobangWar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import "GobangView.h"
/** 线条个数 */
const NSInteger kBoardSize = 17;
/** AI休眠的时间 单位毫秒*/
const NSInteger kInSeconds = 800;
// 这个view负责展示和智能逻辑

@interface GobangView ()

@property (nonatomic, assign) BOOL isPlayerPlaying; // 标志为，标志是否是玩家正在下棋
@property (nonatomic, strong) NSMutableArray *places; // 记录所有的位置状态
@property (nonatomic, strong) NSMutableArray *chesses; // 记录所有在棋盘上的棋子
@property (nonatomic, strong) NSMutableArray *holders; // 记录五子连珠后对应的五个棋子
@property (nonatomic, strong) UIView *redDot; // 指示AI最新一步所在的位置

@end

@implementation GobangView
#pragma mark - **************** 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.level = 1;
//        self.redDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
//        self.redDot.backgroundColor = [UIColor redColor];
//        self.redDot.layer.cornerRadius = 1;
        
        /** 初始化棋盘背景 */
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:frame];
        bgImageView.image = [UIImage imageNamed:@"background"];
        [self addSubview:bgImageView];
        /** 水平线条 */
        for (NSUInteger i = 0; i < kBoardSize; i ++) {
            UIView *horizentalLine = [[UIView alloc]initWithFrame:CGRectMake(kBoardSize,
                                                                             i * (frame.size.width - kBoardSize * 2)/(kBoardSize - 1) +kBoardSize,
                                                                             frame.size.width - kBoardSize * 2,
                                                                             0.5)];
            horizentalLine.backgroundColor = [UIColor blackColor];
            [self addSubview:horizentalLine];
        }
        /** 垂直线条 */
        for (NSUInteger i = 0; i < kBoardSize; i ++) {
            UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(i * (frame.size.width - kBoardSize * 2)/(kBoardSize - 1) +kBoardSize,
                                                                           kBoardSize,
                                                                           0.5,
                                                                           frame.size.height - kBoardSize * 2)];
            verticalLine.backgroundColor = [UIColor blackColor];
            [self addSubview:verticalLine];
        }
        /** 上边框 */
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake((kBoardSize-6),(kBoardSize-6),frame.size.width - (kBoardSize-6) * 2,2)];
        topLine.backgroundColor = [UIColor blackColor];
        [self addSubview:topLine];
        /** 左边框 */
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake((kBoardSize-6),(kBoardSize-6),2,frame.size.height - (kBoardSize-6) * 2)];
        leftLine.backgroundColor = [UIColor blackColor];
        [self addSubview:leftLine];
        /** 下边框 */
        UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake((kBoardSize-6),frame.size.height-(kBoardSize-4),frame.size.width - (kBoardSize-6) * 2,2)];
        bottomLine.backgroundColor = [UIColor blackColor];
        [self addSubview:bottomLine];
        /** 右边框 */
        UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-(kBoardSize-4),(kBoardSize-6),2,frame.size.height - (kBoardSize-6) * 2)];
        rightLine.backgroundColor = [UIColor blackColor];
        [self addSubview:rightLine];
        
        self.places = [NSMutableArray array];
        for (int i = 0; i < kBoardSize; i ++) {
            NSMutableArray *chil = [NSMutableArray array];
            for (int j = 0; j < kBoardSize; j ++) {
                [chil addObject:@(OccupyTypeEmpty)];
            }
            [self.places addObject:chil];
        }
        self.chesses = [NSMutableArray array];
        
        self.holders = [NSMutableArray array];
        
    }
    return self;
}
#pragma mark - **************** 点击屏幕
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.userInteractionEnabled = NO;
    
    self.isPlayerPlaying = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //两根线直接的间距
    CGFloat space = (GetViewWidth(self) - kBoardSize * 2) / (kBoardSize-1);
    NSUInteger w =0, h = 0;
    for (NSUInteger i = 0; i < kBoardSize; i ++) {
        if (space >= point.x) {
            NSLog(@"%f >= %f",space,point.x);
            w = 0;
            break;
        }
        if ((kBoardSize - 1) * space + kBoardSize <= point.x) {
            w = kBoardSize - 1;
            break;
        }
        /** 判断点击位置的X值是否大于第一根线且小于第二根线 */
        if (i * space + kBoardSize <= point.x && (i + 1) * space + kBoardSize > point.x) {
            if (fabs(i * space + kBoardSize - point.x) >= (i + 1) * space + kBoardSize - point.x) {
                w = i + 1;
                break;
            }else{
                w = i;
                break;
            }
        }
    }
    for (NSUInteger i = 0; i < kBoardSize; i ++) {
        if (space >= point.y) {
            h = 0;
            break;
        }
        if ((kBoardSize - 1) * space + kBoardSize <= point.y) {
            h = kBoardSize - 1;
            break;
        }
        /** 判断点击位置的Y值是否大于第一根线且小于第二根线 */
        if (i * space + kBoardSize <= point.y && (i + 1) * space + kBoardSize > point.y) {
            if (fabs(i * space + kBoardSize - point.y) >= (i + 1) * space + kBoardSize - point.y) {
                h = i + 1;
                break;
            }else{
                h = i;
                break;
            }
        }
    }
    
//    UIImageView *piece = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
//    piece.image = [UIImage imageNamed:@"black"];
//    [self addSubview:piece];
//    piece.center = CGPointMake(w * space + kBoardSize, h * space + kBoardSize);
    
    if (w >= kBoardSize || h >= kBoardSize) {
        
        NSLog(@"failed!");
        self.userInteractionEnabled = YES;
        return;
    }
    
    if ([self.places[w][h] integerValue] == 0) {
        
    } else {
        self.userInteractionEnabled = YES;
        return;
    }
    
    YYPoint *p;
//    p = [KWAI geablog:self.places type:OccupyTypeUser];
    p = [[YYPoint alloc] initPointWith:w y:h];
    
    /** 先在p点绘制棋子，如果返回为FALSE则AI胜利弹窗 */
    if ([self move:p] == FALSE) {
        [self win:OccupyTypeAI];
//        self.userInteractionEnabled = YES;
        return;
    }
    /** 如果是用户获得胜利则弹窗 */
    if ([self checkVictory:OccupyTypeUser]== OccupyTypeUser) {
        [self win:OccupyTypeUser];
//        self.userInteractionEnabled = YES;
        return;
    }
    /** 轮到AI绘制棋子 */
    p = [YYAI geablog:self.places type:OccupyTypeAI level:self.level];
    
    /** 先在p点绘制棋子，如果返回为FALSE则用户胜利弹窗 */
    if ([self move:p] == FALSE) {
        [self win:OccupyTypeUser];
//        self.userInteractionEnabled = YES;
        return;
    }
    /** 如果是AI获得胜利则弹窗 */
    if ([self checkVictory:OccupyTypeAI] == OccupyTypeAI) {
        [self win:OccupyTypeAI];
//        self.userInteractionEnabled = YES;
        return;
    }
    
    self.userInteractionEnabled = YES;
}

- (OccupyType)getType:(CGPoint)point {
    
    if ((point.x >= 0 && point.x < kBoardSize) && (point.y >= 0 && point.y < kBoardSize)) {
        NSInteger x = (int)point.x;
        NSMutableArray *arr = self.places[x];
        NSInteger y = (int)point.y;
        return [arr[y] integerValue];
    }
    
    return OccupyTypeUnknown;
}

- (OccupyType)checkNode:(CGPoint)point { //对个给定的点向四周遍历 看是否能形成5子连珠
    
    OccupyType curType = [self getType:point];
    BOOL vic = TRUE;
    for (int i = 1; i < 5; i ++) {
        CGPoint nextP = CGPointMake(point.x + i, point.y);
        if (point.x + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = FALSE;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x, point.y + i);
        if (point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i++) {
        CGPoint nextP = CGPointMake(point.x + i, point.y + i);
        if (point.x + i >= kBoardSize || point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    vic = TRUE;
    for (int i = 1; i < 5; i ++) {
        CGPoint nextP = CGPointMake(point.x - i, point.y + i);
        if (point.x - i < 0 || point.y + i >= kBoardSize || [self getType:nextP] != curType) {
            vic = false;
            break;
        }
    }
    
    if (vic == TRUE) {
        return curType;
    }
    
    return OccupyTypeEmpty;
}

- (OccupyType)checkVictory:(OccupyType)type { // 检查是否type方胜利了的方法
    
    BOOL isFull = TRUE;
    for (int i = 0; i < kBoardSize; i ++) {
        for (int j = 0; j < kBoardSize; j ++) {
            CGPoint p = CGPointMake(i, j);
            OccupyType winType = [self checkNode:p]; // 检查是否形成5子连珠
            if (winType == OccupyTypeUser) {
                return OccupyTypeUser;
            } else if (winType == OccupyTypeAI) {
                return OccupyTypeAI;
            }
            NSMutableArray *arr = self.places[i];
            OccupyType ty = [arr[j] integerValue];
            if (ty == OccupyTypeEmpty) {
                isFull = false;
            }
        }
    }
    
    if (isFull == TRUE) {
        return type;
    }
    
    return OccupyTypeEmpty;
}


- (BOOL)move:(YYPoint *)p { // 向p点进行落子并绘制的方法
    if (p.x < 0 || p.x >= kBoardSize ||
        p.y < 0 || p.y >= kBoardSize) {
        return false;
    }
    //两根线直接的间距
    CGFloat space = (GetViewWidth(self) - kBoardSize * 2) / (kBoardSize-1);
    NSInteger x = p.x;
    NSMutableArray *arr = self.places[x];
    NSInteger y = p.y;
    OccupyType ty = [arr[y] integerValue];
    if (ty == OccupyTypeEmpty) {
        if (self.isPlayerPlaying) {
            [arr replaceObjectAtIndex:y withObject:@(OccupyTypeUser)];
            
            UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            black.backgroundColor = [UIColor clearColor];
            black.image = [UIImage imageNamed:@"black"];
            black.tag = 3001;
            black.clipsToBounds = YES;
            [self addSubview:black];
            black.center = CGPointMake(p.x * space + kBoardSize, p.y * space + kBoardSize);
            [self.chesses addObject:black];
            
        } else {
            
            [arr replaceObjectAtIndex:y withObject:@(OccupyTypeAI)];
            
            UIImageView *black = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            black.image = [UIImage imageNamed:@"white"];
            black.backgroundColor = [UIColor clearColor];
            black.tag = 3002;
            black.clipsToBounds = YES;
            [self addSubview:black];
            black.center = CGPointMake(p.x * space + kBoardSize, p.y * space + kBoardSize);
            [self.chesses addObject:black];
            
//            [weakSelf.redDot removeFromSuperview];
//            [black addSubview:self.redDot];
//            weakSelf.redDot.frame = CGRectMake(2.5, 2.5, 2, 2);
            
        }
        self.isPlayerPlaying = !self.isPlayerPlaying;
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void)reset { // 重新开始的方法
    
    self.userInteractionEnabled = YES;
    
    for (UIView *view in self.chesses) {
        [view removeFromSuperview];
    }
    
    [self.chesses removeAllObjects];
    
    self.places = [NSMutableArray array];
    for (int i = 0; i < kBoardSize; i ++) {
        NSMutableArray *chil = [NSMutableArray array];
        for (int j = 0; j < kBoardSize; j ++) {
            [chil addObject:@(OccupyTypeEmpty)];
        }
        [self.places addObject:chil];
    }
}
/** 悔棋 */
- (void)undo{
    self.userInteractionEnabled = YES;
    //两根线直接的间距
    CGFloat space = (GetViewWidth(self) - kBoardSize * 2) / (kBoardSize-1);
    YYPoint *point1;
    YYPoint *point2;
    
    UIImageView *view1 = self.chesses.lastObject;
    point1 = [[YYPoint alloc]initPointWith:(view1.center.x - kBoardSize)/space y:(view1.center.y - kBoardSize)/space];
    NSMutableArray *arr1 = self.places[point1.x];
    //将改点初始化为OccupyTypeEmpty
    [arr1 replaceObjectAtIndex:point1.y withObject:@(OccupyTypeEmpty)];
    //删除视图点
    [view1 removeFromSuperview];
    //移除点数据
    [self.chesses removeObject:self.chesses.lastObject];
    
    /** 如果删除后该用户落子，如果不是则再删 */
    UIImageView *view2 = self.chesses.lastObject;
    if (view2.tag == 3001) {
        point2 = [[YYPoint alloc]initPointWith:(view2.center.x - kBoardSize)/space y:(view2.center.y - kBoardSize)/space];
        NSMutableArray *arr2 = self.places[point2.x];
        [arr2 replaceObjectAtIndex:point2.y withObject:@(OccupyTypeEmpty)];
        [view2 removeFromSuperview];
        [self.chesses removeObject:self.chesses.lastObject];
    }
}
/** 选择困难等级 1.困难   2.中级  3.简单 */
- (void)swithLevel:(NSInteger)level{
    self.level = level;
}
- (void)win:(OccupyType)type { // type方获得胜利时出现动画的效果
    
    
    
    self.userInteractionEnabled = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.frame.size.height - 40) / 2, self.frame.size.width-80, 45)];
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.backgroundColor = RGBA(200, 200, 200, 0.8);
    label.layer.borderColor = [[UIColor redColor] CGColor];
    label.layer.borderWidth = 3;
    label.font = [UIFont systemFontOfSize:30];
    [self addSubview:label];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    
    if (OccupyTypeAI == type) {
        label.text = @"您输了～";
        
    } else if (OccupyTypeUser == type) {
        label.text = @"您赢了";
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        label.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [self reset];
            [label removeFromSuperview];
            self.userInteractionEnabled = YES;
        }];
    }];
}


@end
