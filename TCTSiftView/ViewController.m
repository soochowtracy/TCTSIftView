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

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *iconsd;
@property (nonatomic, strong) NSMutableArray *iconss;

@property (nonatomic, strong) NSMutableArray *siftViewTabItems;

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
    TCTSiftViewTabItem *temp = self.siftViewTabItems[0];
    [temp setTitle:@"selcted"];
    [temp setSelected:![temp isSelected]];
    [self.siftView reloadData];
    
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
    
    return self.siftViewTabItems[index];

}

- (CGFloat)siftView:(TCTSiftView *)siftView heightOfContentAtIndex:(NSInteger)index{
    if (index == 0) {
        return 300;
    }
    
    return 200;
}

- (void)siftView:(TCTSiftView *)siftView didClickTabAtIndex:(NSInteger)index{
    if (!_one && index == 1) {
        TCTSiftViewTabItem *temp = self.siftViewTabItems[index];
        [temp setTitle:@"selcted"];
        [temp setSelected:![temp isSelected]];
        [self.siftView reloadData];

    }else if (index == 1){
        TCTSiftViewTabItem *temp = self.siftViewTabItems[index];
        [temp setTitle:@"temp1"];
        [temp setSelected:![temp isSelected]];
        [self.siftView reloadData];

    }
    
    _one = !_one;
}

#pragma mark - accessor

- (NSMutableArray *)siftViewTabItems{
    if (!_siftViewTabItems) {
        _siftViewTabItems = [[NSMutableArray alloc] init];
        
        [self.titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TCTSiftViewTabItem *item = [[TCTSiftViewTabItem alloc] initWithTitle:self.titles[idx] defaultTitleColor:[UIColor whiteColor] selectedTitleColor:[UIColor greenColor] defaultImage:[UIImage imageNamed:self.iconsd[idx]] selectedImage:[UIImage imageNamed:self.iconss[idx]] selected:NO];
            [_siftViewTabItems addObject:item];
        }];
    }
    
    return _siftViewTabItems;
}

- (NSMutableArray *)titles{
    if (!_titles) {
        _titles = [@[@"item1",@"item2",@"item3",@"item4",@"item5"] mutableCopy];
    }
    return _titles;
}

- (NSMutableArray *)iconsd{
    if (!_iconsd) {
        _iconsd = [@[@"icon_aa",@"icon_ab",@"icon_ac",@"icon_ae",@"icon_ae"] mutableCopy];
    }
    
    return _iconsd;
}

- (NSMutableArray *)iconss{
    if (!_iconss) {
        _iconss = [@[@"icon_af",@"icon_af",@"icon_af",@"icon_af",@"icon_af"] mutableCopy];
    }
    
    return _iconss;
}
@end
