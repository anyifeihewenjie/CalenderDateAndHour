//
//  HotelCalendarViewController.h
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotelCalendarViewController : UIViewController

@property (nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy) void(^selectCheckDateBlock)(NSString *startDate,NSString *endDate);
@end
