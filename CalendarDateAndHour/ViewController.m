//
//  ViewController.m
//  CalendarDateAndHour
//
//  Created by anyifei’s Mac on 2017/6/23.
//  Copyright © 2017年 esteel. All rights reserved.
//

#import "ViewController.h"
#import "HotelCalendarViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailsLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)chooseDateAndHour:(id)sender {
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc] init];
    vc.titleStr = @"时间段选择";
    vc.hidesBottomBarWhenPushed = YES;
    [vc setSelectCheckDateBlock:^(NSString *startDateStr, NSString *endDateStr) {
        _detailsLable.text = [NSString stringWithFormat:@"%@————————%@",startDateStr,endDateStr];

    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
