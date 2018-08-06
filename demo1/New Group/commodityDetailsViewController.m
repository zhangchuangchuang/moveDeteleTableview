//
//  commodityDetailsViewController.m
//  yijiayi
//
//  Created by 张闯闯 on 2018/7/16.
//  Copyright © 2018年 yijiayiapp. All rights reserved.
//

#import "commodityDetailsViewController.h"
#import "commdityTableViewCell.h"
@interface commodityDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{
    __weak IBOutlet UIView *addConentView;//添加内容view
    __weak IBOutlet UIView *shareBGView;//弹出视图
    __weak IBOutlet UIView *shareItemBGView;//弹出视图子视图
    __weak IBOutlet UITableView *comTableView;//内容tableview
    __weak IBOutlet UIView *tableFoot;//底部view
    NSIndexPath *index;
    BOOL isFirstBG;
    BOOL isUploadFirstBG;
    BOOL isChangeImage;
    NSIndexPath  *sourceIndexPath;
}
@property (nonatomic,strong)  NSMutableArray *dataSouce;
@property (nonatomic,strong)  NSMutableArray *touchPoints;
@property (nonatomic,strong)  commdityTableViewCell * cell;
@end
#define SCREEN_HEIGHT [ UIScreen mainScreen ].bounds.size.height
#define SCREEN_WIDTH  [ UIScreen mainScreen ].bounds.size.width
#define HEIGHT(v)               (v).frame.size.height
@implementation commodityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sourceIndexPath = nil;
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}
-(void)setUI{
    
    shareBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    shareBGView.hidden = YES;
    [self.view addSubview:shareBGView];
    
     shareItemBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HEIGHT(shareItemBGView));

    comTableView.tableFooterView = tableFoot;
    comTableView.dataSource = self;
    comTableView.delegate = self;
     UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [comTableView addGestureRecognizer:longPress];
}

#pragma mark ---tableviewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSouce.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    index = indexPath;
   
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
   NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row]
    ;
    self.cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.cell == nil) {
        self.cell = [[commdityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
 
    NSDictionary *dict = self.dataSouce[indexPath.row];
    if ([dict[@"type"]isEqualToString:@"0"]) {
            self.cell.comImage.hidden = YES;
//        CreateWeakSelf;
        __weak __typeof(self) weakSelf = self;
        self.cell.textViewInputCompletion = ^(NSString *text){
            
                NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
                [temp setObject:@"0" forKey:@"type"];
                [temp setObject:text forKey:@"str"];
            
                [weakSelf.dataSouce replaceObjectAtIndex:indexPath.row withObject:temp];
            
            };
        
       self.cell.comTextView.text =[dict objectForKey:@"str"];
        
    }else{
        self.cell.comTextView.hidden = YES;
        self.cell.comImage.image = [dict objectForKey:@"str"];
    }
    
    
    [self.cell.deleageBtn addTarget:self action:@selector(delegateAction) forControlEvents:UIControlEventTouchUpInside];
    return self.cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary *d = self.dataSouce[indexPath.row];
     if ([d[@"type"]isEqualToString:@"1"]) {
             UIImage *image =  [self imageCompressForWidth:[d objectForKey:@"str"] targetWidth:SCREEN_WIDTH];
             CGSize size =image.size;
             
             return size.height;
     }else{
         return 200;
     }
}
#pragma mark -添加商品按钮点击事件

- (IBAction)addConentAction:(UIButton *)sender {
    [self showShareBGView];
    
}
-(IBAction)hidenBgView:(UIButton *)sender{
    [self hideShareBGView];
}
-(IBAction)itemBgViewAction:(UIButton *)sender{
    NSLog(@"点击按钮时self.data的值%@",self.dataSouce);
    addConentView.hidden = YES;
    comTableView.hidden = NO;
    [self hideShareBGView];
    if (sender.tag==501) {
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setObject:@"0" forKey:@"type"];
        [self.dataSouce addObject:tempDict];
        [comTableView reloadData];
        NSLog(@"昂起值%@",self.dataSouce);
    }else if(sender.tag ==502){
        
   
    }else{
        
      
        
    }
}

-(void)delegateAction{

    [self.dataSouce removeObjectAtIndex:index.row];
    
    [comTableView reloadData];
}
#pragma mark - 姓名 textField

#pragma mark ----基本资料textfile

//显示视图
-(void)showShareBGView
{
     [self.view endEditing:YES];
    shareBGView.hidden = NO;
    [UIView animateWithDuration:0.35 animations:^{
        
        self->shareItemBGView.frame = CGRectMake(0, SCREEN_HEIGHT-HEIGHT(shareItemBGView)-64, SCREEN_WIDTH, HEIGHT(shareItemBGView));
    }];
    
}
//隐藏视图
-(void)hideShareBGView
{
    [UIView animateWithDuration:0.35 animations:^{
        shareItemBGView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, HEIGHT(shareItemBGView));
    } completion:^(BOOL finished) {
       shareBGView.hidden = YES;
    }];
}
//点击屏幕隐藏视图
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideShareBGView];
    [self.view endEditing:YES];
}
//图片等比缩放
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
        
    }
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}
#pragma mark 创建cell的快照
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    return snapshot;
}
#pragma mark 长按手势方法
- (void)longPressGestureRecognized:(id)sender {
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:comTableView];
    NSIndexPath *indexPath = [comTableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [comTableView cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:cell];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [comTableView addSubview:snapshot];
                // 按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标
            [self.touchPoints addObject:[NSValue valueWithCGPoint:location]];
            if (self.touchPoints.count > 2) {
                [self.touchPoints removeObjectAtIndex:0];
            }
            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;
            // 快照随触摸点x值改变量移动
            CGPoint Ppoint = [[self.touchPoints firstObject] CGPointValue];
            CGPoint Npoint = [[self.touchPoints lastObject] CGPointValue];
            CGFloat moveX = Npoint.x - Ppoint.x;
            center.x += moveX;
            snapshot.center = center;
            NSLog(@"%@---%f----%@", self.touchPoints, moveX, NSStringFromCGPoint(center));
            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            // 是否移动了
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 更新数组中的内容
                [self.dataSouce exchangeObjectAtIndex:
                 indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // 把cell移动至指定行
                [comTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // 存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
            }
            break;
        }
            // 长按手势取消状态
        default: {
            // 清除操作
            // 清空数组，非常重要，不然会发生坐标突变！
            [self.touchPoints removeAllObjects];
            [comTableView reloadData];
            UITableViewCell *cell = [comTableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                 [comTableView reloadData];
                
            }];
            break;
        }
    }
   
}
#pragma mark -- 懒加载实现
- (NSMutableArray *)dataSouce {
    if (!_dataSouce) {
        _dataSouce = [[NSMutableArray alloc]init];
        if (self.saveDataArray) {
            [_dataSouce addObjectsFromArray:self.saveDataArray];
            addConentView.hidden = YES;
            comTableView.hidden = NO;
            NSLog(@"传进的数组为%@",_dataSouce);
        }
    }
    return _dataSouce;
}
- (NSMutableArray *)touchPoints {
    if (!_touchPoints) {
        _touchPoints = [[NSMutableArray alloc]init];
    }
    return _touchPoints;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

