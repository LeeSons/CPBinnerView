//
//  CPBinnerUtility.h
//  zent
//
//  Created by 孙登峰 on 2018/1/25.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SafePerformSelector(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface CPBinnerUtility : NSObject

+ (void)setCenterX:(CGFloat)centerX view:(UIView *)view;
+ (void)setCenterY:(CGFloat)centerY view:(UIView *)view;
+ (void)setTop:(CGFloat)top view:(UIView *)view;
+ (void)setLeft:(CGFloat)left view:(UIView *)view;
+ (void)setBottom:(CGFloat)bottom view:(UIView *)view;
+ (void)setRight:(CGFloat)right view:(UIView *)view;
+ (void)setWidth:(CGFloat)width view:(UIView *)view;
+ (void)setHeight:(CGFloat)height view:(UIView *)view;

+ (CGFloat)getCenterX:(UIView *)view;
+ (CGFloat)getCenterY:(UIView *)view;
+ (CGFloat)getTop:(UIView *)view;
+ (CGFloat)getLeft:(UIView *)view;
+ (CGFloat)getBottom:(UIView *)view;
+ (CGFloat)getRight:(UIView *)view;
+ (CGFloat)getWidth:(UIView *)view;
+ (CGFloat)getHeight:(UIView *)view;

+ (void)removeAllSubviews:(UIView *)view;

+ (UIViewController *)getVC:(UIView *)view;

+ (NSString *)transformToPinyin:(NSString *)str;

@end
