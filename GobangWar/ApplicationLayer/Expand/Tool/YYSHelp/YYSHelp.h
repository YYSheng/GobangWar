//
//  YYSHelp.h
//  WuaniOS
//
//  Created by Apple on 2017/2/22.
//  Copyright © 2017年 yunzhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface YYSHelp : NSObject
//磁盘总空间
+ (CGFloat)diskOfAllSizeMBytes;

//磁盘可用空间
+ (CGFloat)diskOfFreeSizeMBytes;

//获取文件大小
+ (long long)fileSizeAtPath:(NSString *)filePath;

//获取文件夹下所有文件的大小
+ (long long)folderSizeAtPath:(NSString *)folderPath;

//获取字符串(或汉字)首字母
+ (NSString *)firstCharacterWithString:(NSString *)string;

//获取当前时间
//format: @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
+ (NSString *)currentDateWithFormat:(NSString *)format;

/** 当前系统的准确时间
 *  @brief 当前时间
 *  @return 当前时间
 */
+ (NSDate *)getNowTime;

/**
 *  计算上次日期距离现在多久
 *
 *  @param lastTime    上次日期(需要和格式对应)
 *  @param format1     上次日期格式
 *  @param currentTime 最近日期(需要和格式对应)
 *  @param format2     最近日期格式
 *
 *  @return xx分钟前、xx小时前、xx天前
 */
+ (NSString *)timeIntervalFromLastTime:(NSString *)lastTime
                        lastTimeFormat:(NSString *)format1
                         ToCurrentTime:(NSString *)currentTime
                     currentTimeFormat:(NSString *)format2;

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

//利用正则表达式验证
//判断邮箱格式是否正确
+ (BOOL)isAvailableEmail:(NSString *)email;

//将十六进制颜色转换为 UIColor 对象
+ (UIColor *)colorWithHexString:(NSString *)color;

#pragma mark - 对图片进行滤镜处理
// 怀旧 --> CIPhotoEffectInstant                         单色 --> CIPhotoEffectMono
// 黑白 --> CIPhotoEffectNoir                            褪色 --> CIPhotoEffectFade
// 色调 --> CIPhotoEffectTonal                           冲印 --> CIPhotoEffectProcess
// 岁月 --> CIPhotoEffectTransfer                        铬黄 --> CIPhotoEffectChrome
// CILinearToSRGBToneCurve, CISRGBToneCurveToLinear, CIGaussianBlur, CIBoxBlur, CIDiscBlur, CISepiaTone, CIDepthOfField
+ (UIImage *)filterWithOriginalImage:(UIImage *)image filterName:(NSString *)name;

#pragma mark - 对图片进行模糊处理
// CIGaussianBlur ---> 高斯模糊
// CIBoxBlur      ---> 均值模糊(Available in iOS 9.0 and later)
// CIDiscBlur     ---> 环形卷积模糊(Available in iOS 9.0 and later)
// CIMedianFilter ---> 中值模糊, 用于消除图像噪点, 无需设置radius(Available in iOS 9.0 and later)
// CIMotionBlur   ---> 运动模糊, 用于模拟相机移动拍摄时的扫尾效果(Available in iOS 9.0 and later)
+ (UIImage *)blurWithOriginalImage:(UIImage *)image blurName:(NSString *)name radius:(NSInteger)radius;

/**
 *  调整图片饱和度, 亮度, 对比度
 *
 *  @param image      目标图片
 *  @param saturation 饱和度
 *  @param brightness 亮度: -1.0 ~ 1.0
 *  @param contrast   对比度
 *
 */
+ (UIImage *)colorControlsWithOriginalImage:(UIImage *)image
                                 saturation:(CGFloat)saturation
                                 brightness:(CGFloat)brightness
                                   contrast:(CGFloat)contrast;

//Avilable in iOS 8.0 and later
//创建一张实时模糊效果 View (毛玻璃效果)
+ (UIVisualEffectView *)effectViewWithFrame:(CGRect)frame;

//全屏截图
+ (UIImage *)shotScreen;

//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;

//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

//压缩图片到指定尺寸大小
+ (UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size;

//压缩图片到指定文件大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 *  判断名称是否合法
 *  @param name 名称
 *  @return yes / no
 */
+ (BOOL)isNameValid:(NSString *)name;

//判断字符串是否含有中文
+ (BOOL)isHaveChineseInString:(NSString *)string;

//判断字符串是否全部为数字
+ (BOOL)isAllNum:(NSString *)string;

/*  绘制虚线
 ** lineFrame:     虚线的 frame
 ** length:        虚线中短线的宽度
 ** spacing:       虚线中短线之间的间距
 ** color:         虚线中短线的颜色
 */
+ (UIView *)createDashedLineWithFrame:(CGRect)lineFrame
                           lineLength:(int)length
                          lineSpacing:(int)spacing lineColor:(UIColor *)color;
@end
