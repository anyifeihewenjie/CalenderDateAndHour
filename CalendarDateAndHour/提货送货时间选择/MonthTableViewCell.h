//
//  MonthTableViewCell.h
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//


#import <UIKit/UIKit.h>
@class MonthModel,DayModel;
typedef void (^SelectedDay)(DayModel *returnDaymodel,MonthModel *returnMonthModel,NSInteger indexPathRow,NSInteger collectionViewIndexPathRow);

@interface MonthTableViewCell : UITableViewCell
@property (nonatomic,strong) MonthModel *model;
@property (nonatomic,assign) NSInteger indexPathRow;
@property (nonatomic,copy) SelectedDay selectedDay;
- (void)setContentView;
@end
