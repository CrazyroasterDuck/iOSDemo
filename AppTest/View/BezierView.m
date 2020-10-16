//
//  BezierView.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/15.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "BezierView.h"

@implementation BezierView

- (void)drawRect:(CGRect)rect{
    //设置线条颜色
    [[UIColor blueColor] set];
    //创建UIBezierPath对象
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 5, 50, 50) byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
    maskPath.lineWidth = 2.f;
    maskPath.lineJoinStyle = kCGLineJoinBevel; //设置拐角样式
    [maskPath stroke];
    
    UIBezierPath* maskFillPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 5, 50, 50) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(15, 15)];
    maskFillPath.lineWidth = 2.f;
    maskFillPath.lineJoinStyle = kCGLineJoinBevel;
    [maskFillPath fill];
    [maskFillPath stroke];
    
    
    UIBezierPath *maskLinePath = [UIBezierPath bezierPath];
    maskLinePath.lineWidth     = 2.f;
    maskLinePath.lineCapStyle  = kCGLineCapRound;//端点样式
    [maskLinePath moveToPoint:CGPointMake(115, 5)];
    [maskLinePath addLineToPoint:CGPointMake(300, 5)];
    [maskLinePath stroke];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[self pointAtIndex:0]];
    CGPoint PrePonit;
    for (NSInteger i = 0; i < 5; i++) {
        CGPoint NowPoint = [self pointAtIndex:i];
        if(i == 0) {
            PrePonit = NowPoint;
        } else {
              // 利用三次曲线 形成波浪曲线
            [path addCurveToPoint:PrePonit controlPoint1:CGPointMake((PrePonit.x + NowPoint.x) / 2 , PrePonit.y) controlPoint2:CGPointMake((PrePonit.x + NowPoint.x)  / 2, NowPoint.y)];
            PrePonit = NowPoint;
        }
    }
    path.lineWidth = 2.f;
    [path stroke];
    
}

- (CGPoint)pointAtIndex:(NSInteger)index{
    return CGPointMake(120 + index * 40, 30 + 40 * index);
}

@end
