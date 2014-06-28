//
//  NSDate+SSAdditions.h
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SSAdditions)

+ (NSDate *)startOfCurrentWeekWithCalendar:(NSCalendar *)calendar;
+ (NSDate *)endOfCurrentWeekWithCalendar:(NSCalendar *)calendar;

@end
