//
//  ViewController.m
//  tangoCarousel
//
//  Created by Quoc Le on 2/10/14.
//  Copyright (c) 2014 Quoc Le. All rights reserved.
//

#import "ViewController.h"
#import "Carousel3D.h"

@interface ViewController ()
@property (strong) Carousel3D *carousel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

  self.carousel = [[Carousel3D alloc] initWithFrame: CGRectMake(0,100,320,240)];
  [self.view addSubview: self.carousel];
  NSArray *images = @[
                    [UIImage imageNamed:@"img_1.jpg"],
                    [UIImage imageNamed:@"img_2.jpg"],
                    [UIImage imageNamed:@"img_3.jpg"],
                    [UIImage imageNamed:@"img_4.jpg"],
                    [UIImage imageNamed:@"img_5.jpg"],
                   ];
  self.view.backgroundColor = [UIColor colorWithWhite: 0.97 alpha: 1.0];
  
  [self.carousel setImages: images];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
