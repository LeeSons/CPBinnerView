//
//  CPBinnerUtility.m
//  zent
//
//  Created by 孙登峰 on 2018/1/25.
//  Copyright © 2018年 zentcm. All rights reserved.
//

#import "CPBinnerUtility.h"

@implementation CPBinnerUtility

+ (void)setCenterX:(CGFloat)centerX view:(UIView *)view
{
    view.center = CGPointMake(centerX, view.center.y);
}

+ (void)setCenterY:(CGFloat)centerY view:(UIView *)view
{
    view.center = CGPointMake(view.center.x, centerY);
}

+ (void)setTop:(CGFloat)top view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = top;
    view.frame = frame;
}

+ (void)setLeft:(CGFloat)left view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x = left;
    view.frame = frame;
}

+ (void)setBottom:(CGFloat)bottom view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = bottom - frame.size.height;
    view.frame = frame;
}

+ (void)setRight:(CGFloat)right view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.x = right - frame.size.width;
    view.frame = frame;
}

+ (void)setWidth:(CGFloat)width view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}

+ (void)setHeight:(CGFloat)height view:(UIView *)view
{
    CGRect frame = view.frame;
    frame.size.height = height;
    view.frame = frame;
}

+ (CGFloat)getCenterX:(UIView *)view
{
    return view.center.x;
}

+ (CGFloat)getCenterY:(UIView *)view
{
    return view.center.y;
}

+ (CGFloat)getTop:(UIView *)view
{
    return view.frame.origin.y;
}

+ (CGFloat)getLeft:(UIView *)view
{
    return view.frame.origin.x;
}

+ (CGFloat)getBottom:(UIView *)view
{
    return view.frame.origin.y + view.frame.size.height;
}

+ (CGFloat)getRight:(UIView *)view
{
    return view.frame.origin.x + view.frame.size.width;
}

+ (CGFloat)getWidth:(UIView *)view
{
    return view.frame.size.width;
}

+ (CGFloat)getHeight:(UIView *)view
{
    return view.frame.size.height;
}

+ (void)removeAllSubviews:(UIView *)view
{
    while (view.subviews.count)
    {
        [view.subviews.lastObject removeFromSuperview];
    }
}

+ (UIViewController *)getVC:(UIView *)view
{
    UIViewController *viewController = nil;
    UIResponder *next = view.nextResponder;
    while (next)
    {
        if ([next isKindOfClass:[UIViewController class]])
        {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

+ (NSString *)transformToPinyin:(NSString *)str
{
    NSMutableString *pinyin = [str mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return pinyin;
}

@end
