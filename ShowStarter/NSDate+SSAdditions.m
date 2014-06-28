//
//  NSDate+SSAdditions.m
//  ShowStarter
//
//  Created by Rahul Jaswa on 6/29/14.
//  Copyright (c) 2014 Rahul Jaswa. All rights reserved.
//

#import "NSDate+SSAdditions.h"

@implementation NSDate (SSAdditions)

+ (NSDate *)startOfCurrentWeekWithCalendar:(NSCalendar *)calendar
{
    NSDate *now = [NSDate date];
    NSDate *startOfWeek;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&startOfWeek
                 interval:&interval
                  forDate:now];
    return startOfWeek;
}

+ (NSDate *)endOfCurrentWeekWithCalendar:(NSCalendar *)calendar
{
    NSDate *now = [NSDate date];
    NSDate *startOfWeek;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSWeekCalendarUnit
                startDate:&startOfWeek
                 interval:&interval
                  forDate:now];
    
    return [startOfWeek dateByAddingTimeInterval:interval-1];
}

@end
