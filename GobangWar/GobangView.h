//
//  GobangView.h
//  GobangWar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYAI.h"
@interface GobangView : UIView
@property (nonatomic, assign) NSInteger level;
/** 选择困难等级 3.困难   2.中级  1.简单 */
- (void)swithLevel:(NSInteger)level;
/** 重新开始 */
- (void)reset;
/** 悔棋 */
- (void)undo;
@end
