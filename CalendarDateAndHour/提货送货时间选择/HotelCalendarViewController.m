//
//  HotelCalendarViewController.m
//  BJTResearch
//
//  Created by anyifei’s Mac on 2017/3/22.
//  Copyright © 2017年 MS. All rights reserved.
//




/*  
 1，日历控件   需求是选择完成日期之后 还需要继续选择当天的小时数   并完成最早最迟时间的选择    也可以只选择一个时间   根据需求改
 2，我的做法是每次点击日期之后往数组里面插入一个星期的整数倍的数据，我插入7*3天，因此插入的小时view的高度是本身collectonview的item高度的整数倍，我插入60*3，插入的地方正好覆盖掉插入的无效数据，使用时可以看图层显示，很好理解
 3，因为需要的急，我只能这样先改，实现的方法有可能不好，性能有一定的影响，类似于这样的功能，谁有好的办法，我也可以学习一下？联系我qq：852552254
 
 */
// RGB颜色
#define WuboColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

// RGB颜色
#define WuboColorR_G_B_A(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define WuboScreen [UIScreen mainScreen].bounds
#define WuboScreen_W [UIScreen mainScreen].bounds.size.width
#define WuboScreen_H [UIScreen mainScreen].bounds.size.height

#import "HotelCalendarViewController.h"
#import "MonthModel.h"
#import "MonthTableViewCell.h"
#import "HourCollectionViewCell.h"

/*  覆盖view的高度  */
#define hourViewHeight 185
/*  每行的高度  */
#define calendarRowHeight 60
/*  一星期的天数  */
#define weekDay 7
/*  后面添加的元素个数  */
#define addNum 21
/*  日历添加多少个月  */
#define addMonth 13
@interface HotelCalendarViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/*  放月份的列表  */
@property(nonatomic,strong)UITableView *tableView;
/*  选择小时数的collectionView  */
@property (nonatomic,strong)UICollectionView *hourCollectionView;
/*  预加载的数据数组  */
@property(nonatomic,strong)NSMutableArray *dataArray;
/*  星期view  */
@property(nonatomic,strong)UIView *weekView;
/*  放小时数的view  */
@property (nonatomic,strong)UIView *chooseHourView;
/*  选择第几个月的全局变量   有初始值  50（值不能小于加载的月份）  */
@property (nonatomic ,assign) NSInteger  indexPathRow;
/*  选择第几天的全局变量   有初始值  100（值不能小于《每月天数+21》）  */
@property (nonatomic ,assign) NSInteger  collectionViewIndexPathRow;
/*  选中的月份model  */
@property (nonatomic, strong) MonthModel *selectedMonthModel;
@property (nonatomic ,assign) BOOL isOpen;//是否折叠   yes：折叠  no：不折叠
@end

@implementation HotelCalendarViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _selectedMonthModel = [[MonthModel alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = _titleStr;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    leftItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self.view addSubview:self.weekView];
    [self.view addSubview:self.tableView];
    _isOpen = NO;
    _indexPathRow = 50;//随便设  大于50的
    
    _collectionViewIndexPathRow = 100;//随便设  大于100的
}
- (void)back {

    [self.navigationController popViewControllerAnimated:YES];
}
/////////////////////////////////////创建视图///////////////////////////////////////////
#pragma mark - 创建主视图  懒加载
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.weekView.frame), self.view.bounds.size.width, self.view.bounds.size.height - self.weekView.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[MonthTableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    }
    return _tableView;
}

#pragma mark - 创建星期视图  懒加载
-(UIView *)weekView{
    if (!_weekView) {
        _weekView = [[UIView alloc]initWithFrame:CGRectMake(-1, 63, self.view.bounds.size.width+2, 40)];
        NSArray *title = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
        for (int i =0 ; i < weekDay ; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/weekDay*i+1, 0, self.view.bounds.size.width/weekDay, _weekView.bounds.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title[i];
            if (i==0 || i==6) {//周六，周日
                label.textColor = WuboColor(104, 128, 202);
                
            }
            [_weekView addSubview:label];
        }
        _weekView.backgroundColor = [UIColor whiteColor];
        _weekView.layer.borderWidth = 1;
        _weekView.layer.masksToBounds = YES;
        _weekView.layer.borderColor = WuboColor(230, 230, 230).CGColor;
    }
    return _weekView;
}

#pragma mark - 创建小时视图
- (UIView *)chooseHourView {

    if (!_chooseHourView) {
        _chooseHourView = [[UIView alloc] init];
        [_chooseHourView addSubview:self.hourCollectionView];
        
    }
    return _chooseHourView;
}
#pragma mark - 创建小时视图上面加载collectionView  懒加载
-(UICollectionView *)hourCollectionView
{
    if (!_hourCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 1;
        flowLayout.minimumInteritemSpacing = 1;
        flowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
        flowLayout.itemSize =  CGSizeMake(([UIScreen mainScreen].bounds.size.width - weekDay)/6, 45);
        _hourCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, hourViewHeight) collectionViewLayout:flowLayout];
        _hourCollectionView.dataSource = self;
        _hourCollectionView.delegate = self;
        _hourCollectionView.bounces = NO;
        _hourCollectionView.scrollEnabled = NO;
        _hourCollectionView.backgroundColor = WuboColor(218, 218, 218);
        [_hourCollectionView registerClass:[HourCollectionViewCell class] forCellWithReuseIdentifier:@"HourCollectionViewCellID"];
        
    }
    return _hourCollectionView;
}
#pragma mark -UICollectionViewDelegate&Datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    MonthModel *monthModel = _dataArray[_indexPathRow];
    /* 获取当天的小时数  选中cell-每月空白cell*/
    DayModel *dayModel = monthModel.days[_collectionViewIndexPathRow - monthModel.cellStartNum];
    return dayModel.hours.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HourCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HourCollectionViewCellID" forIndexPath:indexPath];
    MonthModel *monthModel = _dataArray[_indexPathRow];
    DayModel *dayModel = monthModel.days[_collectionViewIndexPathRow-monthModel.cellStartNum];
    cell.model = dayModel.hours[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
    MonthModel *monthModel = _dataArray[_indexPathRow];
    DayModel *dayModel = monthModel.days[_collectionViewIndexPathRow-monthModel.cellStartNum];
    /* 选中的小时  */
    HourModel *returnModel = dayModel.hours[indexPath.row];
    /* 没有开始小时  */
    BOOL isHourHaveStart = NO;
    /* 没有结束小时  */
    BOOL isHourHaveEnd = NO;
    /* 没有中间选中的小时  */
    BOOL isHourHaveSelected = NO;
    /* 初始化开始小时  */
    NSDate *startHour;
    /* 初始化结束小时  */
    NSDate *endHour;
    /* 初始化开始小时model  */
    HourModel *startModel;
    /* 初始化结束小时model  */
    HourModel *endModel;
    /* 遍历所有存放数据的model  */
    for (MonthModel *Mo in self.dataArray) {
        for (DayModel *Day in Mo.days) {
            for (HourModel *hourModel in Day.hours) {/* 小时状态默认为normal  */
                
                if (hourModel.state == HourModelStateStart) {/* 小时状态为开始，有选择过开始小时数  */
                    isHourHaveStart = YES;/* 有开始小时  */
                    startHour = hourModel.hourDate;/* 开始小时赋值  */
                    startModel = hourModel;/* 开始小时model赋值  */
                }else if (hourModel.state == HourModelStateSelected) {/* 小时状态为选中  */
                    isHourHaveSelected = YES;/* 有选中小时  */
                }else if (hourModel.state == HourModelStateEnd) {/* 小时状态为结束  */
                    isHourHaveEnd = YES;/* 有结束小时  */
                    endHour = hourModel.hourDate;/* 结束小时赋值  */
                    endModel = hourModel;/* 结束小时model赋值  */
                    break;
                }

            }
        }
    }
    
    
    /* 从这开始判断操作数据  */
    
    
    if ((!isHourHaveStart && !isHourHaveEnd && !isHourHaveSelected )|| (!isHourHaveStart && !isHourHaveEnd) ) {/* 没有设置开始结束选中  */
        
        returnModel.state = HourModelStateStart;
        
    }else if ((isHourHaveStart && isHourHaveEnd)){/* 有开始小时，有结束小时（这个条件在选择完结束小时就返回上层界面时，是不起作用的）  */
        
        for (MonthModel *Mo in self.dataArray) {
            for (DayModel *Day in Mo.days) {
                for (HourModel *hourModel in Day.hours) {
                    hourModel.state = HourModelStateNormal;
                }
            }
        }
        returnModel.state = HourModelStateStart;
        
    }else if(isHourHaveStart && !isHourHaveEnd){/* 有开始小时，没有结束小时  */
        
        NSString *startDateStr;
        NSString *endDateStr;
        NSInteger ci = [self compareDate:returnModel.hourDate withDate:startHour];/* 当前选择的小时数和选择过的开始小时做对比 */
        switch (ci) {
            case 1:/* 开始小时>当前选择小时   重置开始小时  重置开始天 */
                startModel.state = HourModelStateNormal;
                returnModel.state = HourModelStateStart;
                dayModel.state = DayModelStateStart;
                for (MonthModel *Mo in self.dataArray) {
                    for (DayModel *Day in Mo.days) {
                        if (Day.state == DayModelStateStartDayHaveSelected) {
                            Day.state = DayModelStateNormal;
                        }
                        
                    }
                }
                break;
            case -1:/* 开始小时<当前选择小时   设置结束小时  并返回上层 */
                returnModel.state = HourModelStateEnd;
                startDateStr = [NSString stringWithFormat:@"%@",startModel.hourDate];
                endDateStr = [NSString stringWithFormat:@"%@",returnModel.hourDate];

                if (_selectCheckDateBlock) {
                    _selectCheckDateBlock(startDateStr,endDateStr);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
                for (MonthModel *Mo in self.dataArray) {
                    for (DayModel *Day in Mo.days) {
                        for (HourModel *hourModel in Day.hours) {/*遍历整个数据，比较时间大小*/
                            
                            NSInteger ci1 = [self compareDate:hourModel.hourDate withDate:startHour];
                            NSInteger ci2 = [self compareDate:hourModel.hourDate withDate:returnModel.hourDate];
                            if (ci1 == -1 && ci2 == 1 ) {
                                hourModel.state = HourModelStateSelected;
                            }
                        }
                    }
                }
                
                break;
            case 0:/* 这个暂时用不到 选择同一小时的 */
                returnModel.state = HourModelStateStart;
                break;
            default:
                break;
        }
        
    }
    [_tableView reloadData];
    [_hourCollectionView reloadData];
}

#pragma mark -UITableViewDelegate&Datasource
/////////////////////////////////////代理方法///////////////////////////////////////////
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MonthModel *model = self.dataArray[indexPath.row];
    return model.cellHight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID" forIndexPath:indexPath];
    cell.model =  self.dataArray[indexPath.row];
    cell.indexPathRow = indexPath.row;
    [cell setContentView];
    if (indexPath.row == _indexPathRow) {/* 点击加载小时view */
        [cell.contentView addSubview:self.chooseHourView];
    }else {/* 解决视图重叠 */
    
        for (UIView *view in cell.contentView.subviews) {
            if (view == _chooseHourView) {
                [view removeFromSuperview];
            }
        }
    }
    __weak typeof(self) weakSelf = self;
    cell.selectedDay = ^(DayModel *returnDaymodel,MonthModel *returnMonthModel,NSInteger indexPathRow,NSInteger collectionViewIndexPathRow){/* 选择完日期之后的回调 */
        /* 没有选择开始日期 */
        BOOL isHaveStart = NO;
        /* 没有选择结束日期 */
        BOOL isHaveEnd = NO;
        /* 没有选择选中日期 */
        BOOL isHaveSelected = NO;
        /* 没有选择开始小时 */
        BOOL isHourHaveStart = NO;
        /* 没有选择结束小时 */
        BOOL isHourHaveEnd = NO;
        /* 初始化开始日期 */
        NSDate *startDate ;
        /* 初始化结束日期 */
        NSDate *endDate ;
        /* 初始化已经选择过得日期 */
        NSDate *haveSelectedStartDate;
        /* 初始化开始model */
        DayModel *starModel;
        /* 初始化结束model */
        DayModel *endModel;
        /* 初始化已选择过的开始model */
        DayModel *haveSelectedStartModel;
        if (_isOpen == NO) {/* 小时view非展开状态 */
            returnMonthModel.cellNum +=addNum;/* 添加21天 */
            returnMonthModel.cellHight += hourViewHeight;/* view高度 */
            if (collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<returnMonthModel.days.count) {/* 非每月最后一个星期 */
                for (NSInteger j = 0; j<addNum; j++) {/* 每月添加21天的非有效天数 */
                    [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                }
                
            }
            [_dataArray replaceObjectAtIndex:indexPath.row withObject:returnMonthModel];/* 替换当前数组 */
            weakSelf.chooseHourView.frame = CGRectMake(0, calendarRowHeight+(collectionViewIndexPathRow/weekDay+1)*calendarRowHeight, [UIScreen mainScreen].bounds.size.width, hourViewHeight);/* 设置小时view坐标 */
            
            _selectedMonthModel = returnMonthModel;
            _collectionViewIndexPathRow = collectionViewIndexPathRow;
            _indexPathRow = indexPathRow;
            _isOpen = YES;
            NSMutableArray *hours = [NSMutableArray array];
            MonthModel *newMonthModel = _dataArray[_indexPathRow];
            DayModel *newDayModel = newMonthModel.days[_collectionViewIndexPathRow-returnMonthModel.cellStartNum];
            if (newDayModel.hours.count == 0) {
                for (NSInteger i = 0; i<24; i++) {
                    HourModel *model = [[HourModel alloc]init];
                    model.hourString = [NSString stringWithFormat:@"%02ld:00",(long)i];
                    model.state = HourModelStateNormal;
                    model.day = returnDaymodel.day;
                    model.month = returnMonthModel.month;
                    model.year = returnMonthModel.year;
                    model.hour = i;
                    model.hourDate = [weakSelf dateWithYear:model.year month:model.month day:model.day hour:i];
                    [hours addObject:model];
                }
                
                newDayModel.hours = hours;/* 插入24小时 */
            }
           
        }else {//展开状态
            
            if (indexPathRow == _indexPathRow) {//同一个月
                if (_collectionViewIndexPathRow != collectionViewIndexPathRow) {//不是同一天
                    NSMutableArray *arr = _selectedMonthModel.days;
                    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
                    for (DayModel *tempModel in tempArr) {
                        if (tempModel.day == 00) {
                            [arr removeObject:tempModel];
                        }
                    }
                    if (collectionViewIndexPathRow-_collectionViewIndexPathRow < addNum) {//在数组插入的同一侧
                        
                        weakSelf.chooseHourView.frame = CGRectMake(0, calendarRowHeight+(collectionViewIndexPathRow/weekDay+1)*calendarRowHeight, [UIScreen mainScreen].bounds.size.width, hourViewHeight);
                        if (collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<returnMonthModel.days.count) {//非每月最后一个星期
                            for (NSInteger j = 0; j<addNum; j++) {
                                [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                            }
                        }else {//其他
                            
                            if (collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<returnMonthModel.days.count) {
                                for (NSInteger j = 0; j<addNum; j++) {
                                    [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                                }
                                
                            }
                        }
                        _collectionViewIndexPathRow = collectionViewIndexPathRow;
                    }else {//在数组插入的不同侧
                        
                        weakSelf.chooseHourView.frame = CGRectMake(0, calendarRowHeight+((collectionViewIndexPathRow-addNum)/weekDay+1)*calendarRowHeight, [UIScreen mainScreen].bounds.size.width, hourViewHeight);
                        if (collectionViewIndexPathRow-addNum-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<returnMonthModel.days.count) {//非每月最后一个星期和前半月
                            for (NSInteger j = 0; j<addNum; j++) {
                                [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-addNum-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                            }
                            
                        }else {//其他
                            
                            if (collectionViewIndexPathRow-addNum-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<0) {
                                for (NSInteger j = 0; j<addNum; j++) {
                                    [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                                }
                                
                            }
                        }
                        
                    _collectionViewIndexPathRow = collectionViewIndexPathRow;
                        _collectionViewIndexPathRow -= addNum;
                    }
                }
            }else {//不同月
                _selectedMonthModel.cellNum -=addNum;
                _selectedMonthModel.cellHight -= hourViewHeight;
                NSMutableArray *arr = _selectedMonthModel.days;
                NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
                for (DayModel *tempModel in tempArr) {
                    if (tempModel.day == 00) {
                        [arr removeObject:tempModel];
                    }
                }
                [weakSelf.chooseHourView removeFromSuperview];
                [_dataArray replaceObjectAtIndex:_indexPathRow withObject:_selectedMonthModel];
                _indexPathRow = indexPathRow;
                
                returnMonthModel.cellNum +=addNum;
                returnMonthModel.cellHight += hourViewHeight;
                if (collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)<returnMonthModel.days.count) {
                    for (NSInteger j = 0; j<addNum; j++) {
                        [returnMonthModel.days insertObject:[[DayModel alloc]init] atIndex:collectionViewIndexPathRow-returnMonthModel.cellStartNum+(weekDay-collectionViewIndexPathRow%weekDay)];
                    }
                    
                }
                
                [_dataArray replaceObjectAtIndex:indexPath.row withObject:returnMonthModel];
                _selectedMonthModel = returnMonthModel;
                weakSelf.chooseHourView.frame = CGRectMake(0, calendarRowHeight+(collectionViewIndexPathRow/weekDay+1)*calendarRowHeight, [UIScreen mainScreen].bounds.size.width, hourViewHeight);

                _collectionViewIndexPathRow = collectionViewIndexPathRow;
                
            }
          
            NSMutableArray *hours = [NSMutableArray array];
            MonthModel *newMonthModel = _dataArray[_indexPathRow];
            DayModel *newDayModel = newMonthModel.days[_collectionViewIndexPathRow-returnMonthModel.cellStartNum];
            if (newDayModel.hours.count == 0) {
                for (NSInteger i = 0; i<24; i++) {
                    HourModel *model = [[HourModel alloc]init];
                    model.hourString = [NSString stringWithFormat:@"%02ld:00",(long)i];
                    model.state = HourModelStateNormal;
                    model.day = returnDaymodel.day;
                    model.month = returnMonthModel.month;
                    model.year = returnMonthModel.year;
                    model.hour = i;
                    model.hourDate = [weakSelf dateWithYear:model.year month:model.month day:model.day hour:i];
                
                    [hours addObject:model];
                }
                
                newDayModel.hours = hours;
            }

        }
        for (MonthModel *Mo in self.dataArray) {
            
            for (DayModel *mo in Mo.days) {
                for (HourModel *hourModel in mo.hours) {
                    if (mo.state == DayModelStateStart) {
                        if (hourModel.state == HourModelStateStart) {
                            isHourHaveStart = YES;
                            haveSelectedStartDate = mo.dayDate;
                            haveSelectedStartModel = mo;
                        }
                        isHaveStart = YES;
                        startDate = mo.dayDate;
                        starModel = mo;
                    }else if (mo.state == DayModelStateEnd) {
                        if (hourModel.state == HourModelStateEnd) {
                            isHourHaveEnd = YES;
                        }
                        isHaveEnd = YES;
                        endDate = mo.dayDate;
                        endModel = mo;
                    }else if (mo.state == DayModelStateSelected) {
                        isHaveSelected = YES;
                        
                    }else if (mo.state == DayModelStateStartDayHaveSelected) {
                    isHaveStart = YES;
                    isHourHaveStart = YES;
                    haveSelectedStartDate = mo.dayDate;
                    }

                }
            }
        }
        
        if ((!isHaveStart && !isHaveEnd && !isHaveSelected )|| (!isHaveStart && !isHaveEnd) ) {
            //没有设置开始结束
            returnDaymodel.state = DayModelStateStart;
        }else if ((isHaveStart && isHourHaveStart && isHaveEnd && !isHourHaveEnd)){
            //有开始有结束
            NSInteger ci = [self compareDate:returnDaymodel.dayDate withDate:startDate];
            switch (ci) {
                case 1://startDate > currentSelectDate
                    
                    for (MonthModel *Mo in weakSelf.dataArray) {
                        for (DayModel *mo in Mo.days) {
                            mo.isSelectedStartAndEnd = NO;
                            if (mo.state == DayModelStateStart) {
                                mo.state = DayModelStateStartDayHaveSelected;
                            }else {
                            
                                mo.state = DayModelStateNormal;
                            }
                        }
                    }
                    returnDaymodel.state = DayModelStateStart;
                    break;
                case -1:
                    
                    for (MonthModel *Mo in weakSelf.dataArray) {
                        for (DayModel *mo in Mo.days) {
                            mo.isSelectedStartAndEnd = YES;
                            if (mo.state == DayModelStateSelected || mo.state == DayModelStateEnd) {
                                mo.state = DayModelStateNormal;
                            }
                            NSInteger ci1 = [weakSelf compareDate:mo.dayDate withDate:startDate];
                            NSInteger ci2 = [weakSelf compareDate:mo.dayDate withDate:returnDaymodel.dayDate];
                            if (ci1 == -1 && ci2 == 1 ) {
                                mo.state = DayModelStateSelected;
                            }
                        }
                    }
                    returnDaymodel.state = DayModelStateEnd;
                    break;
                case 0:
                    break;
                default:
                    break;
            }

        }else if(isHaveStart && isHourHaveStart && !isHaveEnd){
            //有开始没有结束
            NSInteger ci = [self compareDate:returnDaymodel.dayDate withDate:haveSelectedStartDate];
            switch (ci) {
                case 1://startDate > currentSelectDate
                    starModel.state = DayModelStateNormal;
                    haveSelectedStartModel.state = DayModelStateStartDayHaveSelected;
                    returnDaymodel.state = DayModelStateStart;
                    break;
                case -1:
                    returnDaymodel.state = DayModelStateEnd;
                    
                    
                    for (MonthModel *Mo in weakSelf.dataArray) {
                        for (DayModel *mo in Mo.days) {
                            mo.isSelectedStartAndEnd = YES;
                            NSInteger ci1 = [weakSelf compareDate:mo.dayDate withDate:haveSelectedStartDate];
                            NSInteger ci2 = [weakSelf compareDate:mo.dayDate withDate:returnDaymodel.dayDate];
                            if (mo.state == DayModelStateStartDayHaveSelected) {
                                starModel.state = DayModelStateNormal;
                                mo.state = DayModelStateStart;
                            }else
                            if (ci1 == -1 && ci2 == 1 ) {
                                mo.state = DayModelStateSelected;
                            }
                            
                        }
                    }
                    break;
                case 0:
                    break;
                default:
                    break;
            }
            
        }else if (isHaveStart && !isHourHaveStart && !isHaveEnd) {
        
                        for (MonthModel *Mo in weakSelf.dataArray) {
                            for (DayModel *mo in Mo.days) {
                                if (mo.state != DayModelStateDayPassed) {
                                    mo.state = DayModelStateNormal;
                                }else{
                                    mo.state = DayModelStateDayPassed;
                                }
                                
                            }
                        }
            returnDaymodel.state = DayModelStateStart;
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.hourCollectionView reloadData];
    };
    return cell;
}

#pragma mark - 懒加载数据源
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSDate *nowdate = [NSDate date];
        NSInteger toYear = [self getDataFromDate:nowdate type:@"year"];
        NSInteger toMonth = [self getDataFromDate:nowdate type:@"month"];
        for (int i = 0; i<addMonth; i++) {
            if (i == 0) {
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = toYear;
                monthModel.month = toMonth;
                NSMutableArray *days = [NSMutableArray array ];
                NSInteger starNum = [self getDataFromDate :nowdate type:@"day"];
                NSLog(@"$$$$%ld",(long)starNum);
                for (NSInteger i = 1 ; i <=[self totaldaysInMonth:nowdate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    if (i<starNum) {
                        dayModel.state = DayModelStateDayPassed;
                    }else {
                    dayModel.state = DayModelStateNormal;
                    }
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    dayModel.dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    dayModel.isToday = i==starNum;
                    
                    dayModel.isSelectedStartAndEnd = NO;
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( weekDay - m.dayOfTheWeek + 1 ) % weekDay;
                if (oneLineCoune == 0) {
                    oneLineCoune = weekDay;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%weekDay==0) {
                    lineCount = lineCount + count/weekDay ;
                }else{
                    lineCount = lineCount + count/weekDay + 1 ;
                    
                }
                monthModel.havePassedNum = starNum-1;
                monthModel.cellNum = lineCount * weekDay;
                monthModel.cellStartNum = weekDay - oneLineCoune ;
                monthModel.cellHight = calendarRowHeight + calendarRowHeight * lineCount;
                
                [_dataArray addObject:monthModel];
                toMonth++;
                
            }else{
                if (toMonth == addMonth) {
                    toMonth = 1;
                    toYear += 1;
                }
                NSDate *toDate = [self dateWithYear:toYear month:toMonth day:1];
                
                MonthModel  * monthModel = [[MonthModel alloc] init];
                monthModel.year = [self getDataFromDate:toDate type:@"year"];
                monthModel.month = [self getDataFromDate:toDate type:@"month"];
                NSMutableArray *days = [NSMutableArray array ];
                for (NSInteger i = 1 ; i <=[self totaldaysInMonth:toDate]; i++) {
                    DayModel *dayModel = [[DayModel alloc]init];
                    dayModel.dayDate = [self dateWithYear:monthModel.year month:monthModel.month day:i];
                    dayModel.day = i;
                    dayModel.month = monthModel.month;
                    dayModel.year = monthModel.year;
                    dayModel.dayOfTheWeek = [self getDataFromDate:dayModel.dayDate type:@"week"];
                    dayModel.isToday = NO;
                    dayModel.state = DayModelStateNormal;
                    dayModel.isSelectedStartAndEnd = NO;
                    [days addObject:dayModel];
                }
                monthModel.days = days;
                DayModel *m = days.firstObject;
                NSInteger lineCount = 1;
                NSInteger oneLineCoune =( weekDay - m.dayOfTheWeek + 1 ) % weekDay;
                if (oneLineCoune == 0) {
                    oneLineCoune = weekDay;
                }
                NSInteger count = days.count - oneLineCoune;
                if (count%weekDay==0) {
                    lineCount = lineCount + count/weekDay ;
                }else{
                    lineCount = lineCount + count/weekDay + 1 ;
                    
                }
                monthModel.havePassedNum = 0;
                monthModel.cellNum = lineCount * weekDay;
                monthModel.cellStartNum = weekDay - oneLineCoune ;
                monthModel.cellHight = calendarRowHeight + calendarRowHeight * lineCount;
                
                [_dataArray addObject:monthModel];
                toMonth++;
            }
        }
    }
    return _dataArray;
}

#pragma mark - 获取年，月，日，星期 注：日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
-(NSInteger )getDataFromDate:(NSDate *)date type:(NSString * )type{
    NSCalendar *calendar = nil;
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }else{
        calendar = [NSCalendar currentCalendar];
    }
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitWeekday) fromDate:date];
    if ([type isEqualToString:@"year"]) {
        return components.year;
    }else if ([type isEqualToString:@"month"]) {
        return components.month;
    }else if ([type isEqualToString:@"day"]) {
        return components.day;
    }else if ([type isEqualToString:@"week"]) {
        return components.weekday;
    }else{
        return 0;
    }
}

#pragma mark -- 获取当前月共有多少天
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}

#pragma mark - 时间字符串转时间
-(NSDate *)dateWithYear:(NSInteger )year month:(NSInteger )month day:(NSInteger )day
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    return [formatter dateFromString:[NSString stringWithFormat:@"%ld%02ld%02ld",(long)year,(long)month,day]];
}
#pragma mark - 时间字符串转时间(加小时)
-(NSDate *)dateWithYear:(NSInteger )year month:(NSInteger )month day:(NSInteger )day hour:(NSInteger )hour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHH"];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: [formatter dateFromString:[NSString stringWithFormat:@"%ld%02ld%02ld%02ld",(long)year,(long)month,day,hour]]];
    NSDate *localeDate = [[formatter dateFromString:[NSString stringWithFormat:@"%ld%02ld%02ld%02ld",(long)year,(long)month,day,hour]]  dateByAddingTimeInterval: interval];
    
    return localeDate;
}

#pragma mark-日期比较
-(NSInteger )compareDate:(NSDate *)date01 withDate:(NSDate *)date02{
    NSInteger ci;
    NSComparisonResult result = [date01 compare:date02];
    switch (result)
    {
            //date02比date01大
        case NSOrderedAscending: ci=1; break;
            //date02比date01小
        case NSOrderedDescending: ci=-1; break;
            //date02=date01
        case NSOrderedSame: ci=0; break;
        default: NSLog(@"erorr dates %@, %@", date02, date01); break;
    }
    return ci;
}

#pragma mark - <#content#> 计算两个日期之间的天数
- (NSInteger) calcDaysFromBegin:(NSDate *)beginDate end:(NSDate *)endDate{
    //创建日期格式化对象
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    //取两个日期对象的时间间隔：
    //这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:typedef double NSTimeInterval;
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int days=((int)time)/(3600*24);
    //int hours=((int)time)%(3600*24)/3600;
    //NSString *dateContent=[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours];
    return days;
}

@end



