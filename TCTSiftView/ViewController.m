//
//  ViewController.m
//  TCTSiftView
//
//  Created by Tracyone on 15/6/9.
//  Copyright (c) 2015年 tracyone. All rights reserved.
//

#import "ViewController.h"
#import "TCTSiftView.h"

#import "TCTSiftViewTabItem.h"

@interface ViewController ()<TCTSiftViewDatasource, TCTSiftViewDelegate>
@property (weak, nonatomic) IBOutlet TCTSiftView *siftView;

@property (nonatomic, assign, getter=isReloaded) BOOL reloaded;
@end

@implementation ViewController
{
    BOOL _one,_two;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.siftView.datasource = self;
    self.siftView.delegate = self;
}
- (IBAction)didPressedReload:(id)sender {
    self.reloaded = !self.reloaded;
    
    [self.siftView reloadData];
}
- (IBAction)didPressedOne:(id)sender {
    _one = !_one;
    if (_one) {
        [self.siftView selectTabAtIndex:0];
    }else{
        [self.siftView deselectTabAtIndex:0];
    }
    
}
- (IBAction)didPressedShow:(id)sender {
    _two = !_two;
    if (_two) {
        [self.siftView showContentViewAtIndex:2];
    }else{
        [self.siftView showContentViewAtIndex:0];
    }
}

- (NSInteger)numberOfTabsInSiftView:(TCTSiftView *)siftView{
    if (self.isReloaded) {
        return 5;
    }
    return 3;
}

- (UIView *)siftView:(TCTSiftView *)siftView viewForContentAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            return ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor greenColor];
                view;
            });
            break;
        case 1:
            return ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor grayColor];
                view;
            });
            break;
        case 2:
            return ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor blueColor];
                view;
            });
            break;
        default:
            return ({
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor yellowColor];
                view;
            });
            break;
    }
}

- (BOOL)siftView:(TCTSiftView *)siftView shouldShowContentAtIndex:(NSInteger)index{
    if (index == 1) {
        return NO;
    }
    
    return YES;
}

- (id<TCTSiftViewTabItem>)siftView:(TCTSiftView *)siftView itemForTabAtIndex:(NSInteger)index{
    NSArray *titles = @[@"item1",@"item2",@"item3",@"item4",@"item5"];
    NSArray *iconsd = @[@"icon_aa",@"icon_ab",@"icon_ac",@"icon_ae",@"icon_ae"];
    NSArray *iconss = @[@"icon_af",@"icon_af",@"icon_af",@"icon_af",@"icon_af"];
    
    return [[TCTSiftViewTabItem alloc] initWithTitle:titles[index] defaultImage:[UIImage imageNamed:iconsd[index]] selectedImage:[UIImage imageNamed:iconss[index]] selected:NO];
    
    
}

- (CGFloat)siftView:(TCTSiftView *)siftView heightOfContentAtIndex:(NSInteger)index{
    if (index == 0) {
        return 300;
    }
    
    return 200;
}
@end
