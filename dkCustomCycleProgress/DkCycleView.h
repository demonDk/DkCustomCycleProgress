//
//  DkCycleView.h
//  dkCustomCycleProgress
//
//  Created by 党坤 on 2017/4/20.
//  Copyright © 2017年 党坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DkCycleView : UIView

/**
 进度
 */
@property (nonatomic, assign)CGFloat progress;

/**
 渐变色的颜色数组 颜色从浅到深
 */
@property (nonatomic, strong)NSArray *colorArray;

@end
