//
//  commdityTableViewCell.h
//  yijiayi
//
//  Created by 张闯闯 on 2018/7/17.
//  Copyright © 2018年 yijiayiapp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWFormItem;

typedef void(^SWTextViewInputCompletion)(NSString *text);

@interface commdityTableViewCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UITextView *comTextView;
@property (nonatomic,strong)IBOutlet UIImageView *comImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic,strong)IBOutlet UIButton *deleageBtn;

@property (nonatomic, copy) SWTextViewInputCompletion textViewInputCompletion;
@end
