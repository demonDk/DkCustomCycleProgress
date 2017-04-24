//
//  ViewController.m
//  dkCustomCycleProgress
//
//  Created by 党坤 on 2017/4/20.
//  Copyright © 2017年 党坤. All rights reserved.
//

#import "ViewController.h"
#import "DkCycleView.h"

@interface ViewController ()
@property (nonatomic,strong)DkCycleView *cycleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self.view addSubview:self.cycleView];
    
    UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickButton setTitle:@"重新运行" forState:UIControlStateNormal];
    [clickButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [clickButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    clickButton.frame = CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height-200, 100, 44);
    [self.view addSubview:clickButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick
{
    NSLog(@"1111111");
    for (UIView *childView in self.view.subviews) {
        if([childView isKindOfClass:[DkCycleView class]])
        {
            [childView removeFromSuperview];
            [self.view addSubview:self.cycleView];
        }
    }
}

- (DkCycleView *)cycleView
{
    _cycleView = [[DkCycleView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    _cycleView.colorArray = [NSArray arrayWithObjects:[UIColor redColor],[UIColor blueColor],[UIColor blueColor],[UIColor blackColor],nil];
    _cycleView.progress = 0.8;
    return _cycleView;
}

@end
