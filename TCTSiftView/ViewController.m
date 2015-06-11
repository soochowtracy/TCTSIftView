//
//  ViewController.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "ViewController.h"
#import "TCTSiftView.h"

@interface ViewController ()<TCTSiftViewDatasource, TCTSiftViewDelegate>
@property (weak, nonatomic) IBOutlet TCTSiftView *siftView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.siftView.datasource = self;
    self.siftView.delegate = self;
}



@end
