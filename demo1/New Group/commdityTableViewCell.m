//
//  commdityTableViewCell.m
//  yijiayi
//
//  Created by 张闯闯 on 2018/7/17.
//  Copyright © 2018年 yijiayiapp. All rights reserved.
//

#import "commdityTableViewCell.h"

@interface commdityTableViewCell()<UITextViewDelegate>
@end
#define ViewBorderRadius(View, Radius, Width, Color)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
@implementation commdityTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"commdityTableViewCell" owner:self options:nil] objectAtIndex:0];
        
//        self.comTextView.placeholder = @"说点什么...";
        [self setUI];
    }
    return self;
}
-(void)setUI{
    ViewBorderRadius(self.bgView, 10, 1, RGBCOLOR(239,239,239));
    
//    self.comTextView.placeholder = @"说点什么...";
    self.comTextView.delegate=self;
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (self.textViewInputCompletion) {
        self.textViewInputCompletion(textView.text);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
