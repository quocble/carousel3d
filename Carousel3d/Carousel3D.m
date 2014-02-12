//
//  Carousel3D.m
//  tangoCarousel
//
//  Created by Quoc Le on 2/10/14.
//  Copyright (c) 2014 Quoc Le. All rights reserved.
//

#import "Carousel3D.h"

CGFloat DefaultWidth = 0.40f; // 40%
CGFloat MinZoom = 0.40;     // 40%
int DefaultSize = 5;
int Theta = 360 / 5; // 0 120 240

double radians (double d) { 
  return d * M_PI / 180;
} 
double degrees (double r) { 
  return r * 180/ M_PI;
}

@interface Carousel3D() {
  int angle;
}
@property (strong,nonatomic) NSArray *images;
@property (strong,nonatomic) NSArray *imageViews;
@property (assign) int viewIndex;
@property (assign) int dataIndex;
- (void) setImages: (NSArray*) images;
@end

@implementation Carousel3D

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self buildCarousel];
      
      UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(panGesture:)];
      [self addGestureRecognizer: panGesture];
    }
    return self;
}

- (void) setImages: (NSArray*) images {
  _images = images;
  _dataIndex = 0;
  _viewIndex = 0;
  
  [self setImages];
  [self setForAngle];
  [self spinToAngle: ((int)images.count-1) * Theta time: 1.0];
}

- (void) spinToAngle: (int) targetAngle time: (float) time {
    angle = targetAngle;
    [UIView animateWithDuration: time * 0.25f delay: 0 options: UIViewAnimationOptionCurveEaseIn
    animations:^{
      [self setForAngle];
    } completion:^(BOOL finished) {
    }];
}

- (void) panGesture:(UIPanGestureRecognizer*) gesture {

  if(gesture.state == UIGestureRecognizerStateBegan) {
  
  }
  if(gesture.state == UIGestureRecognizerStateChanged)
  {
    CGPoint translation = [gesture translationInView:self];
    angle -= translation.x;
    angle %= 360;
    [gesture setTranslation:CGPointZero inView:self];
    [self setForAngle];
  }
  if(gesture.state == UIGestureRecognizerStateEnded) {
    int page = angle / Theta;
    int remainder = angle % Theta;
    CGPoint velocity = [gesture velocityInView:self];

    int nextPage = 0;
    if(velocity.x < 0) {
      nextPage = (page+1) % DefaultSize;
      angle = (nextPage * Theta) %360;
    }else {
      nextPage = remainder < 0 ? DefaultSize - 1 : page;
      angle =  (nextPage * Theta) %360;
    }
    float time = 1 - fabsf(remainder / Theta);
    NSLog(@"+Page %d (%d) -> %d vX=%f time =%f ", page, remainder, nextPage, velocity.x, time);
    
    [self spinToAngle: angle time: time];
  }
}

- (void) buildCarousel {

  NSMutableArray *imageViews = [NSMutableArray array];
  float width = (DefaultWidth * self.frame.size.width);
  int x = (self.frame.size.width - width)/2;

  for(int i=0; i< DefaultSize; i++) {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview: imageView];
    imageView.frame = CGRectMake(x, (self.frame.size.height - width)/2, width, width);
    imageView.layer.cornerRadius = width / 2;
    imageView.layer.borderWidth = 4;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.masksToBounds = YES;
  
    [imageViews addObject: imageView];
  }
  
  self.imageViews = imageViews;
}

- (void) layoutSubviews {
  [super layoutSubviews];

  float width = (DefaultWidth * self.frame.size.width);
  int x = (self.frame.size.width - width)/2;
  for( UIView *view in self.imageViews) {
    view.frame = CGRectMake(x, (self.frame.size.height - width)/2, width, width);
  }
}

+ (CATransform3D) getTransformFor: (float) angle {
  float radius = 110;
  float z = radius * sin(angle);
  float x = radius * cos(angle);
  float zoom = MinZoom + (1-MinZoom) * (  ((z / radius)+1)/2.0f ) ;
  //NSLog(@"ZOOM at z=%f   %f", z, zoom);
  CATransform3D t1 = CATransform3DMakeTranslation(x, 0, z);
  t1 = CATransform3DScale(t1, zoom, zoom, 1);
  return t1;
}

- (void) setForAngle {

  for(int i=0; i< self.imageViews.count; i++ ) {
    int targetAngle = angle + (i*Theta);
    CATransform3D transform = [Carousel3D getTransformFor: radians(targetAngle + 15) ];
    UIImageView *view = _imageViews[i];
    view.layer.transform = transform;
  
    //NSLog(@"## %d ANGLE %d TARGET %d ", i, angle, targetAngle);
    
    if(targetAngle % 360 == Theta)
      view.alpha = 1.0;
    else
      view.alpha = 0.70;
  }
}

- (void) setImages
{
    for(int i=0; i< self.imageViews.count; i++ ) {
      UIImageView *view = _imageViews[i];
      if(i < _images.count) {
        view.image = _images[i];
      }
    }
}


@end
