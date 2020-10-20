//
//  AnimationViewController.m
//  AppTest
//
//  Created by 疯狂的盐水吖 on 2020/10/15.
//  Copyright © 2020 疯狂的盐水吖. All rights reserved.
//

#import "AnimationViewController.h"
#import "CustomButton.h"
#import "BezierView.h"

@interface AnimationViewController ()<CAAnimationDelegate>
{
    UIView *demoView;
    BezierView *bView;
    bool selected;
    UIImageView *imagView1;
    UIImageView *imagView2;
    CAShapeLayer *myShapeLayer;
}
@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBezierView];
    //self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *titles = @[@"淡入淡出",@"缩放",@"旋转",@"平移"];
    for (unsigned int i = 0; i < titles.count; i++) {
        UIButton * ins = [[UIButton alloc] init];
        [self.view addSubview:ins];
        ins.backgroundColor = [UIColor brownColor];
        ins.tag = i;
        ins.frame = CGRectMake(10, 10 + 50 * i, 80, 40);
        [ins setTitle:titles[i] forState:UIControlStateNormal];
        [ins addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CustomButton *bezierBtn = [[CustomButton alloc] init];
    [self.view addSubview:bezierBtn];
    bezierBtn.frame = CGRectMake(self.view.frame.size.width - 130, 10, 120, 40);
    [bezierBtn setTitle:@"贝塞尔动画" forState:UIControlStateNormal];
    [bezierBtn addTarget:self action:@selector(bezierBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *springBtn = [[CustomButton alloc] init];
    [self.view addSubview:springBtn];
    springBtn.frame = CGRectMake(10, 220, 80, 40);
    [springBtn setTitle:@"弹簧效果" forState:UIControlStateNormal];
    [springBtn addTarget:self action:@selector(springBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *groupBtn = [[CustomButton alloc] init];
    [self.view addSubview:groupBtn];
    groupBtn.frame = CGRectMake(10, 270, 80, 40);
    [groupBtn setTitle:@"组动画" forState:UIControlStateNormal];
    [groupBtn addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    demoView = [[UIView alloc]init];
    [self.view addSubview:demoView];
    demoView.frame = CGRectMake(0, 0, 100, 100);
    demoView.backgroundColor = [UIColor redColor];
    demoView.center = self.view.center;
    
    NSArray *titles2 = @[@"单视图转场",@"双视图转场",@"CATransition转场"];
    for (unsigned int i = 0; i < titles2.count; i++) {
        UIButton *ins = [[UIButton alloc] init];
        [self.view addSubview:ins];
        ins.backgroundColor = [UIColor brownColor];
        ins.tag = i;
        ins.frame = CGRectMake(10, 320 + 70 * i, 100, 60);
        ins.titleLabel.adjustsFontSizeToFitWidth = YES;
        [ins setTitle:titles2[i] forState:UIControlStateNormal];
        [ins addTarget:self action:@selector(transAnimationBegin:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    imagView1 = [[UIImageView alloc] init];
    [self.view addSubview:imagView1];
    imagView1.frame = CGRectMake(0, 0, 100, 100);
    imagView1.center = CGPointMake(self.view.center.x , self.view.center.y - 300);
    imagView1.backgroundColor = [UIColor clearColor];
    imagView1.userInteractionEnabled = YES;
    imagView1.image = [UIImage imageNamed:@"instance"];
    
    imagView2 = [[UIImageView alloc] init];
    [self.view addSubview:imagView2];
    imagView2.frame = CGRectMake(0, 0, 100, 100);
    imagView2.center = CGPointMake(self.view.center.x, self.view.center.y - 150);
    imagView2.backgroundColor = [UIColor clearColor];
    imagView2.userInteractionEnabled = YES;
    imagView2.image = [UIImage imageNamed:@"instance"];
     
}

-(void)animationBegin:(UIButton *)btn{
    CABasicAnimation *animation = nil;
    switch (btn.tag) {
        case 0:{
            //淡如淡出
            animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            [animation setFromValue:@1.0];
            [animation setToValue:@0.1];
        }break;
        case 1:{
            //缩放
            animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            [animation setFromValue:@1.0];//设置起始值
            [animation setToValue:@0.1];//设置目标值
        }break;
        case 2:{
            //旋转
            animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
            //setFromValue不设置,默认以当前状态为准
            [animation setToValue:@(M_PI)];
        }break;
        case 3:{
            //平移
            animation = [CABasicAnimation animationWithKeyPath:@"position"];
            //setFromValue不设置,默认以当前状态为准
            [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y + 200)]];
        }break;
        default:break;
    }
    [animation setDelegate:self];//代理回调
    [animation setDuration:0.25];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    /**
     *设置时间函数CAMediaTimingFunction
     *kCAMediaTimingFunctionLinear 匀速
     *kCAMediaTimingFunctionEaseIn 开始速度慢，后来速度快
     *kCAMediaTimingFunctionEaseOut 开始速度快 后来速度慢
     *kCAMediaTimingFunctionEaseInEaseOut = kCAMediaTimingFunctionDefault 中间速度快，两头速度慢
     */
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    //设置自动翻转
    //设置自动翻转以后单次动画时间不变，总动画时间增加一倍，它会让你前半部分的动画以相反的方式动画过来
    //比如说你设置执行一次动画，从a到b时间为1秒，设置自动翻转以后动画的执行方式为，先从a到b执行一秒，然后从b到a再执行一下动画结束
    [animation setAutoreverses:YES];
    //kCAFillModeForwards//动画结束后回到准备状态
    //kCAFillModeBackwards//动画结束后保持最后状态
    //kCAFillModeBoth//动画结束后回到准备状态,并保持最后状态
    //kCAFillModeRemoved//执行完成移除动画
    [animation setFillMode:kCAFillModeBoth];
    //将动画添加到layer,添加到图层开始执行动画，
    //注意:key值的设置与否会影响动画的效果
    //如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
    //如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
    //你可以通过key值获取或者删除一个动画:
    //[self.demoView.layer animationForKey:@""];
    //[self.demoView.layer removeAnimationForKey:@""]
    [demoView.layer addAnimation:animation forKey:@"baseanimation"];
}

- (void)springBtnClicked:(UIButton *)btn{
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
    //设置质量
    spring.mass = 1;
    //设置刚度系数,和运动速度相关
    spring.stiffness = 100.0;
    //设置阻尼系数，和停止速度相关
    spring.damping = 1.0;
    //设置初始速度
    spring.initialVelocity = 0;
    //设置时间
    spring.duration = spring.settlingDuration;
    spring.fromValue = @(demoView.center.y);
    spring.toValue = @(demoView.center.y + (selected? + 200 : -200));
    spring.fillMode = kCAFillModeForwards;
    [demoView.layer addAnimation:spring forKey:nil];
    selected = !selected;
    imagView1.hidden = YES;
    imagView2.hidden = YES;
    dispatch_after(dispatch_time( DISPATCH_TIME_NOW,(int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->imagView1.hidden = NO;
        self->imagView2.hidden = NO;
    });

}

- (void)groupBtnClicked:(UIButton *)btn{
    [self groupAnimation:nil];
}

- (void)transAnimationBegin:(UIButton *)btn{
    switch (btn.tag) {
            case 0:[self animationSingleView:YES]; break;
            case 1:[self animationSingleView:NO]; break;
            case 2:[self chang3]; break;
            default:break;
        }
}

- (void)bezierBtnClicked:(UIButton *)btn{
    [self drawLove:0 isSameDirect:YES];
    [self drawLove:100 isSameDirect:NO];
}

- (void)drawLove:(CGFloat)offset isSameDirect:(BOOL)isSame{
    //预先定义一个实现爱心的贝塞尔曲线
    UIBezierPath *lovePath = [UIBezierPath bezierPath];
    //设置第一个起点
    CGPoint startPoint = CGPointMake(bView.bounds.size.width / 2 - 50 + offset, 20);
    CGPoint endPoint = CGPointMake(bView.bounds.size.width / 2 - 50 + offset, bView.bounds.size.height - 140);
    CGPoint controlPoint1 = CGPointMake(50 + offset,-80);
    CGPoint controlPoint2 = CGPointMake(-50 + offset, 80);
    // 设置第三个控制点
    CGPoint controlPoint3 = CGPointMake(bView.bounds.size.width- 150 + offset, -80);
    // 设置第四个控制点
    CGPoint controlPoint4 = CGPointMake(bView.bounds.size.width - 50 + offset, 80);
    [lovePath moveToPoint:startPoint];
    if(isSame){
        //设置终点和两个控制点
        [lovePath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];// 设置另一个起始点
        [lovePath moveToPoint:endPoint];
        // 添加三次贝塞尔曲线
        [lovePath addCurveToPoint:startPoint controlPoint1:controlPoint4 controlPoint2:controlPoint3];
    } else{
        //设置终点和两个控制点
        [lovePath addCurveToPoint:endPoint controlPoint1:controlPoint3 controlPoint2:controlPoint4];// 设置另一个起始点
        [lovePath moveToPoint:endPoint];
        // 添加三次贝塞尔曲线
        [lovePath addCurveToPoint:startPoint controlPoint1:controlPoint2 controlPoint2:controlPoint1];
    }
    
    CGPoint lineSP = CGPointMake(10, 60);
    CGPoint lineEP = CGPointMake(bView.bounds.size.width - 10, 60);
    CGPoint startP1 = CGPointMake(bView.bounds.size.width - 30, 40);
    CGPoint startP2 = CGPointMake(bView.bounds.size.width - 30, 80);
    [lovePath moveToPoint:lineSP];
    [lovePath addLineToPoint:lineEP];
    if(isSame){
        [lovePath moveToPoint:startP1];
        [lovePath addLineToPoint:lineEP];
    } else {
        [lovePath moveToPoint:startP2];
        [lovePath addLineToPoint:lineEP];
    }
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = bView.bounds;
    shapeLayer.path = lovePath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [bView.layer addSublayer:shapeLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 5.0f;
    animation.repeatCount = 1;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shapeLayer removeFromSuperlayer];//从父视图层删除
    });
}

-(void)initBezierView{
    bView = [[BezierView alloc] initWithFrame:CGRectMake(self.view.center.x - 200, self.view.center.y + 80, 400, 400)];
    [bView drawRect:CGRectMake(self.view.center.x - 200, self.view.center.y + 80, 400, 200)];
    bView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bView];
}

//ShapeLayer
-(void)layerAnimation
{
    //贝塞尔画圆
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:100 startAngle:0 endAngle:M_PI clockwise:NO];
      
    //初始化shapeLayer
    myShapeLayer = [CAShapeLayer layer];
    myShapeLayer.frame = self.view.bounds;
  
    myShapeLayer.strokeColor = [UIColor greenColor].CGColor;//边沿线色
    myShapeLayer.fillColor = [UIColor grayColor].CGColor;//填充色
      
    myShapeLayer.lineJoin = kCALineJoinMiter;//线拐点的类型
    myShapeLayer.lineCap = kCALineCapSquare;//线终点
            
    //从贝塞尔曲线获得形状
    myShapeLayer.path = path.CGPath;
      
    //线条宽度
    myShapeLayer.lineWidth = 10;
      
    //起始和终止
    myShapeLayer.strokeStart = 0.0;
    myShapeLayer.strokeEnd = 1.0;
            
    //将layer添加进图层
    [self.view.layer addSublayer:myShapeLayer];
}


/**
 *  转场动画在执行过程中不可以被停止，
 *  转场动画在执行过程中不可以用户交互
 *  转场动画在执行过程中不可以控制动画执行进度
 */
/**
 *  基于UIView的单视图转场动画
 */
static NSUInteger change1_0Index = 0;
static NSUInteger change1_1Index = 0;
static NSUInteger change1_2Index = 0;

- (void)animationSingleView:(BOOL)single{
    /**
         *  第一部分
         */
        NSArray *array0 = @[
                            @(UIViewAnimationOptionTransitionNone),
                            @(UIViewAnimationOptionTransitionFlipFromLeft),//从左水平翻转
                            @(UIViewAnimationOptionTransitionFlipFromRight),//从右水平翻转
                            @(UIViewAnimationOptionTransitionCurlUp),//翻书上掀
                            @(UIViewAnimationOptionTransitionCurlDown),//翻书下盖
                            @(UIViewAnimationOptionTransitionCrossDissolve),//融合
                            @(UIViewAnimationOptionTransitionFlipFromTop),//从上垂直翻转
                            @(UIViewAnimationOptionTransitionFlipFromBottom),//从下垂直翻转
                            ];
    /**
     *  第二部分
     */
    NSArray *array1 = @[
                        @(UIViewAnimationOptionCurveEaseInOut),////开始慢，加速到中间，然后减慢到结束
                        @(UIViewAnimationOptionCurveEaseIn),//开始慢，加速到结束
                        @(UIViewAnimationOptionCurveEaseOut),//开始快，减速到结束
                        @(UIViewAnimationOptionCurveLinear),//线性运动
                        ];
    /**
        *  第三部分
        */
       NSArray *array2 = @[
                           @(UIViewAnimationOptionLayoutSubviews),//默认，跟父类作为一个整体
                           @(UIViewAnimationOptionAllowUserInteraction),//设置了这个，主线程可以接收点击事件
                           @(UIViewAnimationOptionBeginFromCurrentState),//从当前状态开始动画，父层动画运动期间，开始子层动画。
                           @(UIViewAnimationOptionRepeat),//重复执行动画，从开始到结束， 结束后直接跳到开始态
                           @(UIViewAnimationOptionAutoreverse),//反向执行动画，结束后会再从结束态->开始态
                           @(UIViewAnimationOptionOverrideInheritedDuration),//忽略继承自父层持续时间，使用自己持续时间（如果存在）
                           @(UIViewAnimationOptionOverrideInheritedCurve),//忽略继承自父层的线性效果，使用自己的线性效果（如果存在）
                           @(UIViewAnimationOptionAllowAnimatedContent),//允许同一个view的多个动画同时进行
                           @(UIViewAnimationOptionShowHideTransitionViews),//视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）
                           @(UIViewAnimationOptionOverrideInheritedOptions),//不继承父动画设置或动画类型。
                           ];
    
    if (single) {
           [UIView transitionWithView:imagView1
                             duration:1
                              options:
            ((NSNumber *)array0[change1_0Index]).integerValue|
            ((NSNumber *)array1[change1_1Index]).integerValue|
            ((NSNumber *)array2[change1_2Index]).integerValue
                           animations:^{
                               /**
                                *  单视图的转场动画需要在动画块中设置视图转场前的内容和视图转场后的内容
                                */
                               if (self->imagView1.tag == 0) {
                                   self->imagView1.image = [UIImage imageNamed:@"smile"];
                                   self->imagView1.tag = 1;
                               }else{
                                   self->imagView1.image = [UIImage imageNamed:@"instance"];
                                   self->imagView1.tag = 0;
                               }
                           } completion:nil];
           NSLog(@"动画:%s:%@:%@:%@",__func__,@(change1_0Index),@(change1_1Index),@(change1_2Index));
       }else{
       
           /**
            *  双视图的转场动画
            *  注意：双视图的转场动画实际上是操作视图移除和添加到父视图的一个过程，from视图必须要有父视图，to视图必须不能有父视图，否则会出问题
            *  比如动画不准等
            */
           
           UIImageView *fromView = nil;
           UIImageView *toView = nil;
           
           if (imagView1.tag == 0) {
               fromView = imagView1;
               toView = imagView2;
               imagView1.tag = 1;
           }else{
               fromView = imagView2;
               toView = imagView1;
               imagView1.tag = 0;
           }
           
           
           [UIView transitionFromView:fromView
                               toView:toView duration:1.0
                              options:
            ((NSNumber *)array0[change1_0Index]).integerValue|
            ((NSNumber *)array1[change1_1Index]).integerValue|
            ((NSNumber *)array2[change1_2Index]).integerValue
                           completion:^(BOOL finished) {
                               
                           }];
           
           
       }
           change1_0Index += 1;
       if (change1_0Index > array0.count - 1) {
           change1_0Index = 0;
           change1_1Index += 1;
       }
       if (change1_1Index > array1.count - 1) {
           change1_1Index = 0;
           change1_2Index += 1;
       }
       if (change1_2Index > array2.count - 1) {
           change1_2Index = 0;
           
           change1_0Index = 0;
           change1_2Index = 0;
           
       }
}

/**
 *  基于CATransition的视图转场动画
 */
static NSUInteger change3_0Index = 0;
static NSUInteger change3_1Index = 0;
-(void)chang3{
    
    /**
     *创建转场动画：注意：CATransaction和CATransition 不一样
     */
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.25;
    
    NSArray *type_array = @[
                        //系统提供的动画
                       kCATransitionFade,
                       kCATransitionMoveIn,
                       kCATransitionPush,
                       kCATransitionReveal,
                       
                       //以下是私有api,只能字符串访问
                       @"cube",//立方体翻转效果
                       @"oglFlip",//翻转效果
                       @"suckEffect",//收缩效果,动画方向不可控
                       @"rippleEffect",//水滴波纹效果,动画方向不可控
                       @"pageCurl",//向上翻页效果
                       @"pageUnCurl",//向下翻页效果
                       @"cameralIrisHollowOpen",//摄像头打开效果,动画方向不可控
                       @"cameraIrisHollowClose",//摄像头关闭效果,动画方向不可控
                       ];
    //转场类型
    transition.type = type_array[change3_0Index];

    NSArray *subtype_array = @[
                            kCATransitionFromRight,
                            kCATransitionFromLeft,
                            kCATransitionFromTop,
                            kCATransitionFromBottom
                            ];
    //转场方向
    transition.subtype = subtype_array[change3_1Index];

    /**
     *  设置转场动画的开始和结束百分比
     */
    transition.startProgress = 0.0;
    transition.endProgress = 1.0;
    
    
    if (imagView1.tag == 0) {
        imagView1.tag = 1;
        imagView1.image = [UIImage imageNamed:@"smile"];
        imagView2.image = [UIImage imageNamed:@"smile"];
    }else{
        imagView1.tag = 0;
        
        imagView1.image = [UIImage imageNamed:@"instance"];
        imagView2.image = [UIImage imageNamed:@"instance"];
    }
    [imagView1.layer addAnimation:transition forKey:nil];
    [imagView2.layer addAnimation:transition forKey:nil];

    NSLog(@"动画:%s:%@:%@",__func__,@(change3_0Index),@(change3_1Index));
    
    change3_1Index += 1;
    if (change3_1Index > subtype_array.count - 1) {
        change3_1Index = 0;
        change3_0Index += 1;
    }
    if (change3_0Index > type_array.count - 1) {
        change3_0Index = 0;
    }
    
}

#pragma mark -- CAKeyframeAnimation - 指定点平移动画
-(void)groupAnimation:(NSSet<UITouch *> *)touches{
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    /**
     *  移动动画
     */
    CAKeyframeAnimation *position = [self moveAnimation:touches];
    /**
     *  摇晃动画
     */
    CAKeyframeAnimation *shake = [self shakeAnimation:touches];
    /**
     *  透明度动画
     */
    CABasicAnimation *alpha = [self alphaAnimation:touches];
    
    /**
     *  设置动画组的时间,这个时间表示动画组的总时间，它的子动画的时间和这个时间没有关系
     */
    [group setDuration:3.0];
    [group setAnimations:@[position,shake,alpha]];
    
    
    [demoView.layer addAnimation:group forKey:nil];
}

#pragma mark -- CAKeyframeAnimation - 路径平移动画
-(CAKeyframeAnimation *)moveAnimation:(NSSet<UITouch *> *)touches{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /**
     *  设置路径，按圆运动
     */
    CGMutablePathRef path = CGPathCreateMutable();//CG是C语言的框架，需要直接写语法
    CGPathAddEllipseInRect(path, NULL, CGRectMake(demoView.center.x - 160, demoView.center.y - 160,320, 320));
    [animation setPath:path];//把路径给动画
    CGPathRelease(path);//释放路径
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:3];
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    return animation;
}

#pragma mark -- CAKeyframeAnimation - 摇晃动画
-(CAKeyframeAnimation *)shakeAnimation:(NSSet<UITouch *> *)touches{

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    /**
     *  设置路径，贝塞尔路径
     */
    CGFloat angle = M_PI;
    NSArray *values = @[@(angle),@(-angle),@(angle)];
    [animation setValues:values];
    [animation setRepeatCount:9];
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:.3];
    return animation;
}

#pragma mark -- CABasicAnimation - 淡如淡出动画
-(CABasicAnimation *)alphaAnimation:(NSSet<UITouch *> *)touches{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setDuration:1.0];
    /**
     * 设置重复次数
     */
    [animation setRepeatCount:3];
    /**
     * 设置自动翻转
     * 设置自动翻转以后单次动画时间不变，总动画时间延迟一倍，它会让你前半部分的动画以相反的方式动画过来
     * 比如说你设置执行一次动画，从a到b时间为1秒，设置自动翻转以后动画的执行方式为，先从a到b执行一秒，然后从b到a再执行一下动画结束
     */
    [animation setAutoreverses:YES];
    /**
     * 设置起始值
     */
    [animation setFromValue:@1.0];
    
    [animation setDelegate:self];
    
    /**
     * 设置目标值
     */
    [animation setToValue:@0.1];
    /**
     * 将动画添加到layer 添加到图层开始执行动画，
     * 注意：key值的设置与否会影响动画的效果
     * 如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
     * 如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
     * 你可以通过key值获取或者删除一个动画
     */
    return animation;
}

/**
 *  动画开始和动画结束时 self.demoView.center 是一直不变的，说明动画并没有改变视图本身的位置
 */
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始------：%@",    NSStringFromCGPoint(demoView.center));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画结束------：%@",    NSStringFromCGPoint(demoView.center));
}

@end
/*
 动画的继承结构
 CAAnimation{
      CAPropertyAnimation{
             CABasicAnimation{
                     CASpringAnimation
             }
             CAKeyframeAnimation
      }
      CATransition
      CAAnimationGroup
 }
 设置属性动画的属性归总
 CATransform3D{
     rotation旋转
     transform.rotation.x
     transform.rotation.y
     transform.rotation.z

     scale缩放
     transform.scale.x
     transform.scale.y
     transform.scale.z

     translation平移
     transform.translation.x
     transform.translation.y
     transform.translation.z
 }

 CGPoint{
     position
     position.x
     position.y
 }

 CGRect{
     bounds
     bounds.size
     bounds.size.width
     bounds.size.height

     bounds.origin
     bounds.origin.x
     bounds.origin.y
 }

 property{
     opacity
     backgroundColor
     cornerRadius
     borderWidth
     contents
     
     Shadow{
         shadowColor
         shadowOffset
         shadowOpacity
         shadowRadius
     }
 }
 */
