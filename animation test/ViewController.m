//
//  ViewController.m
//  animation test
//
//  Created by Martin Michelini on 6/5/16.
//  Copyright © 2016 Martin Michelini. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableArray *colors;
@property int x;
@property (weak, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //int used to add x amount off points on the screen
    self.x = 0;
    
    //Create an array of colors
    self.colors = [NSMutableArray array];
    float INCREMENT = 0.05;
    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [self.colors addObject:color];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)topButtonPressed:(id)sender {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    } else {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                      target:self
                                                    selector:@selector(createObject)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)createObject {
    //Create a dot on the screen and add a sonar like animation
    //Change radius to modify the size of the
    int radius = 20;
    CGPoint screenPoint = [self getRandomPoint];
    UIView * shadowView = [[UIView alloc] init];
    //Change the initial alpha value to desired intensity
    shadowView.backgroundColor = [[self getRandomColor] colorWithAlphaComponent:0.3];
    shadowView.frame = CGRectMake(screenPoint.x, screenPoint.y, radius*2, radius*2);
    shadowView.layer.cornerRadius = radius;
    [self.view addSubview:shadowView];
    
    [self drawRoundedViewWithFrame:shadowView.frame];
    
    [UIView animateWithDuration:1.5f
                          delay:0.0f
                        options:UIViewAnimationOptionRepeat
                     animations:^{
                         //Change the scale for a bigger or smaller sonar effect
                         shadowView.transform = CGAffineTransformMakeScale(3, 3);
                         shadowView.alpha = 0;
                     } completion:^(BOOL finished) {
                         // Do nothing
                     }];
    self.x++;
    if (self.x > 100) {
        [self.timer invalidate];
        self.x = 0;
    }
    //Bring the start button to the top
    [self.view bringSubviewToFront:self.startButton];
}

- (void)drawRoundedViewWithFrame:(CGRect)frame {
    //Draw the center dot
    CAShapeLayer *circle = [CAShapeLayer layer];
    circle.path = [UIBezierPath bezierPathWithOvalInRect:frame].CGPath;
    circle.fillColor = [self getRandomColor].CGColor;
    circle.lineWidth = 5;
    circle.strokeColor = [UIColor whiteColor].CGColor;
    
    [self.view.layer addSublayer:circle];
}

- (CGPoint)getRandomPoint {
    //Generate a random point on the screen
    int pointWidth = arc4random_uniform(self.view.bounds.size.width);
    int pointHeight = arc4random_uniform(self.view.bounds.size.height);
    return CGPointMake(pointWidth, pointHeight);
}

- (UIColor *)getRandomColor {
    //Get a random color for the animation
    return [self.colors objectAtIndex:arc4random()% self.colors.count];
}

@end
