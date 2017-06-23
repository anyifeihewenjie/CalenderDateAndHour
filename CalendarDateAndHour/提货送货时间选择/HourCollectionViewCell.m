//
//  HourCollectionViewCell.m
//  Calendar
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//


#import "HourCollectionViewCell.h"
#import "MonthModel.h"
@interface HourCollectionViewCell ()
@property (nonatomic,copy)UILabel *hourLable;
@property (nonatomic,copy)UILabel *stateLable;
@end

@implementation HourCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        
        _hourLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _hourLable.textAlignment = NSTextAlignmentCenter;
        _hourLable.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:_hourLable];
        
        _stateLable = [[UILabel alloc]init];
        _stateLable.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-8);
        _stateLable.bounds = CGRectMake(0, 0, self.bounds.size.width, 16);
        _stateLable.textAlignment = NSTextAlignmentCenter;
        _stateLable.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_stateLable];
        
    }
    return self;
}
- (void)setModel:(HourModel *)model {
    
    _model = model;
    
    _hourLable.text = model.hourString;
    switch (model.state) {
        case HourModelStateStart:
            _stateLable.text = @"最早";
            _stateLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.backgroundColor = [UIColor whiteColor];
            _hourLable.layer.masksToBounds = YES;
            _hourLable.layer.borderWidth = 1;
            _hourLable.layer.borderColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1].CGColor;
            break;
        case HourModelStateSelected:
            _hourLable.layer.masksToBounds = YES;
            _hourLable.layer.borderWidth = 0;
            _hourLable.layer.borderColor = [UIColor whiteColor].CGColor;
            _hourLable.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:207/255.0 alpha:1];
            _stateLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
            
            _stateLable.text = @"";
            break;
        case HourModelStateEnd:
            _stateLable.text = @"最迟";
            _stateLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.backgroundColor = [UIColor whiteColor];
            _hourLable.layer.masksToBounds = YES;
            _hourLable.layer.borderWidth = 1;
            _hourLable.layer.borderColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1].CGColor;
            
            break;
        case HourModelStateNormal:
            _hourLable.layer.masksToBounds = YES;
            _hourLable.layer.borderWidth = 0;
            _hourLable.layer.borderColor = [UIColor whiteColor].CGColor;
            _hourLable.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
            _stateLable.textColor = [UIColor colorWithRed:250/255.0 green:172/255.0 blue:25/255.0 alpha:1];
            _hourLable.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
            
            _stateLable.text = @"";
            break;
        default:
            break;
    }
    
}
@end
