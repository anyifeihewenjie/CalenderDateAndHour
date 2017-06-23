//
//  MonthModel.h
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



typedef enum : NSUInteger {
    DayModelStateNormal = 0,
    DayModelStateStart,
    DayModelStateEnd,
    DayModelStateSelected,
    DayModelStateSameDay,
    DayModelStateDayPassed,
    DayModelStateStartDayHaveSelected
    
} DayModelState;




typedef enum : NSUInteger {
    Sunday = 1,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday,
} DayModelOfTheWeek;

typedef enum : NSUInteger {
    HourModelStateNormal = 0,
    HourModelStateStart,
    HourModelStateEnd,
    HourModelStateSelected,
    
} HourModelState;
@interface HourModel : NSObject
/**
 * 小时的状态
 */
@property(nonatomic,assign)HourModelState state;
/**
 * 小时
 */
@property (nonatomic,copy)NSString *hourString;

/**
 * 小时是否当前的小时
 */
@property(nonatomic,assign)BOOL isNowHour;
/**
 * 年
 */
@property(nonatomic,assign)NSInteger year;

/**
 * 月
 */
@property(nonatomic,assign)NSInteger month;
/**
 * 日
 */
@property(nonatomic,assign)NSInteger day;
/**
 * 时
 */
@property(nonatomic,assign)NSInteger hour;
/**
 * 日期
 */
@property(nonatomic,strong)NSDate *hourDate;
@end


@interface DayModel : NSObject

/**
 * 年
 */
@property(nonatomic,assign)NSInteger year;

/**
 * 月
 */
@property(nonatomic,assign)NSInteger month;
/**
 * 日
 */
@property(nonatomic,assign)NSInteger day;

/**
 * 日期
 */
@property(nonatomic,strong)NSDate *dayDate;

/**
 * 星期
 */
@property(nonatomic,assign)DayModelOfTheWeek dayOfTheWeek;

/**
 * 日期的状态
 */
@property(nonatomic,assign)DayModelState state;

/**
 * 日期是不是今天
 */
@property(nonatomic,assign)BOOL isToday;
/**
 * 是否开始时间和结束时间都选中
 */
@property(nonatomic,assign)BOOL isSelectedStartAndEnd;


@property(nonatomic,strong)NSMutableArray<HourModel *> * hours;


@end


@interface MonthModel : NSObject
/**
 * 年
 */
@property(nonatomic,assign)NSInteger year;

/**
 * 月
 */
@property(nonatomic,assign)NSInteger month;

/**
 * 一个月中UICollectionViewCell的个数
 */
@property(nonatomic,assign)NSInteger cellNum;

/**
 * 月UITableViewCell的高度
 */
@property(nonatomic,assign)CGFloat cellHight;

/**
 * UICollectionViewCell开始的位置
 */
@property(nonatomic,assign)NSInteger cellStartNum;
/**
 * 当前月已过去天数
 */
@property(nonatomic,assign)NSInteger havePassedNum;
/**
 * 月UITableViewCell的高度
 */
@property(nonatomic,strong)NSMutableArray<DayModel *> * days;
@end
