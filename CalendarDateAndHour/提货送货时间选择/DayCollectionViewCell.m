//
//  DayCollectionViewCell.m
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "DayCollectionViewCell.h"
#import "MonthModel.h"
// RGB颜色
#define WuboColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGB颜色
#define WuboColorR_G_B_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define WuboScreen [UIScreen mainScreen].bounds
#define WuboScreen_W [UIScreen mainScreen].bounds.size.width
#define WuboScreen_H [UIScreen mainScreen].bounds.size.height
#define NormalColor [UIColor whiteColor]
#define StartAndEndColor WuboColor(250, 175, 25);
#define SelectedColor WuboColor(255, 255, 207);


@interface DayCollectionViewCell ()
@property(nonatomic,strong) UILabel *gregorianCalendarLabel;
@property(nonatomic,strong) UILabel *haveSelectedStartDate;
@property(nonatomic,strong) UIView *lunarCalendarView;
@property(nonatomic,strong) UIView *markView;
@end
@implementation DayCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.lunarCalendarView = [[UIView alloc] init];
        self.lunarCalendarView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.lunarCalendarView.bounds = CGRectMake(0, 0, self.bounds.size.width, 40);
        [self.contentView addSubview:self.lunarCalendarView];
       

       
        self.gregorianCalendarLabel = [[UILabel alloc] init];
        self.gregorianCalendarLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.gregorianCalendarLabel.bounds = CGRectMake(0, 0, 40, 40);
        self.gregorianCalendarLabel.textAlignment = NSTextAlignmentCenter;
        self.gregorianCalendarLabel.font = [UIFont systemFontOfSize:16];
        self.gregorianCalendarLabel.textColor = [UIColor blackColor];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.gregorianCalendarLabel.bounds byRoundingCorners:UIRectEdgeAll |  UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.gregorianCalendarLabel.frame.size.width, self.gregorianCalendarLabel.frame.size.height)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = self.gregorianCalendarLabel.bounds;
        maskLayer.path = path.CGPath;
        self.gregorianCalendarLabel.layer.mask = maskLayer;
        [self.contentView addSubview:self.gregorianCalendarLabel];
        
        self.haveSelectedStartDate = [[UILabel alloc] init];
        self.haveSelectedStartDate.center = CGPointMake(self.bounds.size.width/2, 45);
        self.haveSelectedStartDate.bounds = CGRectMake(0, 0, self.bounds.size.width, 10);
        self.haveSelectedStartDate.textAlignment = NSTextAlignmentCenter;
        self.haveSelectedStartDate.font = [UIFont systemFontOfSize:10];
        self.haveSelectedStartDate.textColor = WuboColor(24, 25, 20);
        [self.contentView addSubview:self.haveSelectedStartDate];
        
        self.markView = [[UIView alloc]init];
        self.markView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height-15);
        
        self.markView.bounds = CGRectMake(0, 0, 6, 6);
        UIBezierPath *markViewPath = [UIBezierPath bezierPathWithRoundedRect:self.markView.bounds byRoundingCorners:UIRectEdgeAll |  UIRectCornerBottomLeft cornerRadii:CGSizeMake(self.markView.frame.size.width, self.markView.frame.size.height)];
        CAShapeLayer *markViewPathMaskLayer = [[CAShapeLayer alloc]init];
        markViewPathMaskLayer.frame = self.gregorianCalendarLabel.bounds;
        markViewPathMaskLayer.path = markViewPath.CGPath;
        self.markView.layer.mask = markViewPathMaskLayer;
        
        [self.contentView addSubview:self.markView];

    }
    return self;
}

-(void)setModel:(DayModel *)model{
    _model = model;
    if (model == nil) {
        self.gregorianCalendarLabel.hidden = YES;
        self.gregorianCalendarLabel.text = @"";
        self.gregorianCalendarLabel.backgroundColor = NormalColor;
        self.lunarCalendarView.backgroundColor = NormalColor;
        self.lunarCalendarView.hidden = YES;
        self.markView.hidden = YES;
        self.haveSelectedStartDate.hidden = YES;
    }else{
        self.gregorianCalendarLabel.hidden = NO;
        if (model.isToday) {//是今天
            self.markView.hidden = NO;
            self.markView.backgroundColor = WuboColor(104, 128, 202);
            
        }else{//不是今天
            self.markView.hidden = YES;
            self.markView.backgroundColor = [UIColor clearColor];
        }

        self.gregorianCalendarLabel.text = [NSString stringWithFormat:@"%02ld",(long)model.day];
        UIBezierPath *cornerBezierPath  = [UIBezierPath bezierPath];
        switch (model.state) {
            case DayModelStateNormal:{
                self.gregorianCalendarLabel.textColor = WuboColor(24, 25, 20);
                self.gregorianCalendarLabel.backgroundColor = NormalColor;
                 self.lunarCalendarView.backgroundColor = NormalColor;
                self.lunarCalendarView.hidden = YES;
                self.haveSelectedStartDate.hidden = YES;
                break;
            }
            case DayModelStateStart:{
                self.haveSelectedStartDate.hidden = YES;
                if (model.isSelectedStartAndEnd) {
                    [cornerBezierPath moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
                    [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
                    [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 40)];
                    [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 40)];
                    [cornerBezierPath fill];
                    CAShapeLayer *aamaskLayer = [[CAShapeLayer alloc]init];
                    aamaskLayer.frame = self.lunarCalendarView.bounds;
                    aamaskLayer.path = cornerBezierPath.CGPath;
                    self.lunarCalendarView.layer.mask = aamaskLayer;
                     self.lunarCalendarView.backgroundColor = SelectedColor;
                    self.gregorianCalendarLabel.backgroundColor = StartAndEndColor;
                    self.lunarCalendarView.hidden = NO;
                    self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                }else {
                    self.gregorianCalendarLabel.backgroundColor = StartAndEndColor;
                    self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                    self.lunarCalendarView.backgroundColor = NormalColor;
                    self.lunarCalendarView.hidden = YES;

                }
                break;
            }
            case DayModelStateEnd:{
                self.haveSelectedStartDate.hidden = YES;
                if (model.isSelectedStartAndEnd) {
                    
                    [cornerBezierPath moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
                    [cornerBezierPath addLineToPoint:CGPointMake(0, 0)];
                    [cornerBezierPath addLineToPoint:CGPointMake(0, 40)];
                    [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 40)];
                    [cornerBezierPath fill];
                    CAShapeLayer *aamaskLayer = [[CAShapeLayer alloc]init];
                    aamaskLayer.frame = self.lunarCalendarView.bounds;
                    aamaskLayer.path = cornerBezierPath.CGPath;
                    self.lunarCalendarView.layer.mask = aamaskLayer;
                    self.lunarCalendarView.backgroundColor = SelectedColor;
                    self.lunarCalendarView.hidden = NO;
                    self.gregorianCalendarLabel.backgroundColor = StartAndEndColor;
                    self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                }else {
                    self.lunarCalendarView.hidden = YES;
                    self.gregorianCalendarLabel.backgroundColor = StartAndEndColor;
                    self.lunarCalendarView.backgroundColor = NormalColor;
                    self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                    
                }
                
                break;
            }
            case DayModelStateSelected:{
                self.haveSelectedStartDate.hidden = YES;
                switch (model.dayOfTheWeek) {
                    case Saturday:
                        [cornerBezierPath moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(0, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(0, 40)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 40)];
                        break;
                    case Sunday:
                        [cornerBezierPath moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 40)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width/2, 40)];
                        break;
                    default:
                        [cornerBezierPath moveToPoint:CGPointMake(0, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
                        [cornerBezierPath addLineToPoint:CGPointMake(self.bounds.size.width, 40)];
                        [cornerBezierPath addLineToPoint:CGPointMake(0, 40)];
                        break;
                }
                [cornerBezierPath fill];
                CAShapeLayer *aamaskLayer = [[CAShapeLayer alloc]init];
                aamaskLayer.frame = self.lunarCalendarView.bounds;
                aamaskLayer.path = cornerBezierPath.CGPath;
                self.lunarCalendarView.layer.mask = aamaskLayer;
                self.gregorianCalendarLabel.backgroundColor = SelectedColor;
                self.gregorianCalendarLabel.textColor = WuboColor(24, 25, 20);
                 self.lunarCalendarView.backgroundColor = SelectedColor;
                self.lunarCalendarView.hidden = NO;
                break;
            }
            case DayModelStateSameDay:{
                self.haveSelectedStartDate.hidden = YES;
                self.gregorianCalendarLabel.textColor = [UIColor whiteColor];
                 self.lunarCalendarView.backgroundColor = NormalColor;
                self.lunarCalendarView.hidden = YES;
                break;
            }
            case DayModelStateDayPassed:{
                self.haveSelectedStartDate.hidden = YES;
                self.gregorianCalendarLabel.textColor = WuboColor(179, 179, 179);
                self.lunarCalendarView.backgroundColor = NormalColor;
                self.lunarCalendarView.hidden = YES;
                break;
            }
            case DayModelStateStartDayHaveSelected:{
                self.haveSelectedStartDate.hidden = NO;
                
                self.haveSelectedStartDate.text = @"最早";
                self.gregorianCalendarLabel.backgroundColor = [UIColor whiteColor]
                ;
                self.gregorianCalendarLabel.textColor = WuboColor(24, 25, 20);
                self.lunarCalendarView.backgroundColor = NormalColor;
                self.lunarCalendarView.hidden = YES;
                break;
            }
   
            default:
                break;
                
        }
}
    
}


@end
