//
//  ViewController.m
//  Matrix
//
//  Created by ruibin.chow on 2023/6/22.
//

#import "ViewController.h"
#import "MGLRenderView.h"

@interface ViewController ()

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) MGLRenderView *renderView;

@end

@implementation ViewController

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super init]) {
        _frame = frame;
    }
    return self;
}

- (void)loadView {
    /*
     Mac 中创建 NSViewController 不会自动创建 view，就像是 创建view 不会自动创建 layer 一样。
     */
    NSView *view = [[NSView alloc] initWithFrame:_frame];
    view.wantsLayer = YES;
    view.layer.backgroundColor = [NSColor yellowColor].CGColor;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.renderView = [[MGLRenderView alloc] init];
    self.renderView.frame = self.view.bounds;
    [self.view addSubview:self.renderView];
}


- (void)viewDidLayout {
    [super viewDidLayout];
    NSLog(@"viewDidLayout");
    self.renderView.frame = self.view.bounds;
}


@end
