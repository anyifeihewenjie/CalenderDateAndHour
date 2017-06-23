//
//  HourCollectionViewCell.h
//  Calendar
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MonthModel,DayModel,HourModel;
@interface HourCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)HourModel *model;
@end
