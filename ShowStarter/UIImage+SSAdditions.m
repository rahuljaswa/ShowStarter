//
//  UIImage+SSAdditions.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/28/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "UIImage+SSAdditions.h"


@implementation UIImage (SSAdditions)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = nil;
    if (context) {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    return image;
}

@end
