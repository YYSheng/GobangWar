//
//  ViewController.m
//  GobangWar
//
//  Created by Apple on 2017/4/12.
//  Copyright © 2017年 YYSheng. All rights reserved.
//

#import "ViewController.h"
#import "GobangView.h"

@interface ViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) UIImageView *maskView;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *stopButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) GobangView *gobangView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bg = [[UIImageView alloc]initWithFrame:self.view.frame];
    bg.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:bg];
    
    self.gobangView = [[GobangView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width)];
    [self.view addSubview:self.gobangView];
    self.gobangView.center = self.view.center;
    self.gobangView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    self.gobangView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    self.gobangView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    self.gobangView.layer.shadowRadius = 6;//阴影半径，默认3
    
    UIButton *difficultyButton = [[UIButton alloc] initWithFrame:CGRectMake(20, self.gobangView.frame.size.height + self.gobangView.frame.origin.y + 50, 80, 30)];
    [difficultyButton setTitle:@"简单" forState:UIControlStateNormal];
    difficultyButton.tag = 3000;
    difficultyButton.backgroundColor = [UIColor whiteColor];
    difficultyButton.layer.masksToBounds = YES;
    difficultyButton.layer.cornerRadius = 15;
    [difficultyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [difficultyButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [difficultyButton addTarget:self action:@selector(difficultyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:difficultyButton];
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2-40, self.gobangView.frame.size.height + self.gobangView.frame.origin.y + 50, 80, 30)];
    [resetButton setTitle:@"重来" forState:UIControlStateNormal];
    resetButton.backgroundColor = [UIColor whiteColor];
    resetButton.layer.masksToBounds = YES;
    resetButton.layer.cornerRadius = 15;
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [resetButton addTarget:self action:@selector(resetButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetButton];
    
    UIButton *undoButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-100, self.gobangView.frame.size.height + self.gobangView.frame.origin.y + 50, 80, 30)];
    [undoButton setTitle:@"悔棋" forState:UIControlStateNormal];
    undoButton.backgroundColor = [UIColor whiteColor];
    undoButton.layer.masksToBounds = YES;
    undoButton.layer.cornerRadius = 15;
    [undoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [undoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [undoButton addTarget:self action:@selector(undoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undoButton];
    
    
    self.maskView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.maskView];
    self.maskView.image = [UIImage imageNamed:@"launch"];
    self.maskView.contentMode = UIViewContentModeScaleAspectFill;
    self.maskView.userInteractionEnabled = YES;
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width/2-40, kScreen_Height-100, 80, 25)];
    [self.maskView addSubview:self.startButton];
    [self.startButton setBackgroundImage:[UIImage imageNamed:@"start"] forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.stopButton = [[UIButton alloc] initWithFrame:CGRectMake(166, 475, 86, 25)];
//    [self.stopButton setBackgroundImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
//    [self.maskView addSubview:self.stopButton];
}
#pragma mark - **************** 点击事件
- (void)difficultyButtonClick:(UIButton *)button{
    //切换难度
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请选择困难度：" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"困难",@"中级",@"简单", nil];
    [alertView show];
}
- (void)undoButtonClick:(UIButton *)button{
    //悔棋
    [self.gobangView undo];
}
- (void)resetButtonPressed:(UIButton *)button {
    //重置棋盘
    [self.gobangView reset];
}

- (void)startButtonPressed:(UIButton *)button {
    
    [self.maskView removeFromSuperview];
}

#pragma mark - **************** 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    /** 1.困难   2.中级  3.简单 */
    UIButton *button = (UIButton *)[self.view viewWithTag:3000];
    if (buttonIndex == 1) {
        [button setTitle:@"困难" forState:UIControlStateNormal];
        [self.gobangView swithLevel:3];
    }else if (buttonIndex == 2){
        [button setTitle:@"中级" forState:UIControlStateNormal];
        [self.gobangView swithLevel:2];
    }else if (buttonIndex == 3){
        [button setTitle:@"简单" forState:UIControlStateNormal];
        [self.gobangView swithLevel:1];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
