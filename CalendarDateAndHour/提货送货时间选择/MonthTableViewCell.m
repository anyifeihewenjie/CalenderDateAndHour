
//
//  MonthTableViewCell.m
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//

#import "MonthTableViewCell.h"
#import "MonthModel.h"
#import "DayCollectionViewCell.h"
// RGB颜色
#define WuboColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGB颜色
#define WuboColorR_G_B_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define WuboScreen [UIScreen mainScreen].bounds
#define WuboScreen_W [UIScreen mainScreen].bounds.size.width
#define WuboScreen_H [UIScreen mainScreen].bounds.size.height

@interface MonthTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) BOOL changeHeight;
@end
@implementation MonthTableViewCell

- (void)setContentView{
    _changeHeight = NO;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.collectionView];
}
- (UIView *)lineView {

    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 9)];
        _lineView.backgroundColor = WuboColor(239, 239, 239);
    }
    return _lineView;
}
- (UILabel *)dateLabel {

    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 48)];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.font = [UIFont systemFontOfSize:20];
    }
    return _dateLabel;
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        flowLayout.itemSize =  CGSizeMake(([UIScreen mainScreen].bounds.size.width)/7, 60);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 500) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DayCollectionViewCell class] forCellWithReuseIdentifier:@"DayCollectionViewCellID"];
        
    }
    return _collectionView;
}


#pragma mark - 设置内容
- (void)setModel:(MonthModel *)model{
    _model = model;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect frame = self.collectionView.frame;
        frame.size.height = model.cellHight - 60;
        
        self.collectionView.frame = frame;
    });
    self.dateLabel.text = [NSString stringWithFormat:@"%04ld年%02ld月",(long)model.year ,model.month];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.collectionView reloadData];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return _model.cellNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayCollectionViewCellID" forIndexPath:indexPath];
    
    if ((indexPath.row < _model.cellStartNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        cell.model = nil;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        cell.model = model;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ((indexPath.row < _model.cellStartNum+_model.havePassedNum) || (indexPath.row >= (_model.days.count + _model.cellStartNum))) {
        return;
    }else{
        DayModel *model = _model.days[indexPath.row - _model.cellStartNum];
        if (self.selectedDay) {
            self.selectedDay(model,_model,_indexPathRow,indexPath.row);
        }
            
    }
    
    
    
}

@end
