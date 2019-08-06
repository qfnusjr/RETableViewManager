//
// RETableViewNumberCell.m
// RETableViewManager
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RETableViewNumberCell.h"
#import "RETableViewManager.h"

@interface RETableViewNumberCell ()

@property (strong, readwrite, nonatomic) REFormattedNumberField *textField;

@property (assign, readwrite, nonatomic) BOOL enabled;

@end

@implementation RETableViewNumberCell

@synthesize item = _item;
@synthesize textField = _textField;

+ (BOOL)canFocusWithItem:(RETableViewItem *)item
{
    return YES;
}

#pragma mark -
#pragma mark Lifecycle

- (void)dealloc {
    if (_item != nil) {
        [_item removeObserver:self forKeyPath:@"enabled"];
    }
}

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.backgroundColor = [UIColor clearColor];

    self.textField = [[REFormattedNumberField alloc] initWithFrame:CGRectZero];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textField];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.textLabel.text = self.item.title.length == 0 ? @" " : self.item.title;
    self.textField.text = [self.item.value re_stringWithNumberFormat:self.item.format];
    self.textField.placeholder = self.item.placeholder;
    self.textField.format = self.item.format;
    self.textField.keyboardAppearance = self.item.keyboardAppearance;
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    self.textField.inputAccessoryView = self.item.showBarView? self.actionBar: nil;
    self.enabled = self.item.enabled;

    if (self.item.textBackgroundColor) {
        self.textField.backgroundColor = self.item.textBackgroundColor;
    }

    if (self.item.textFont) {
        self.textField.font = self.item.textFont;
    } else {
        self.textField.font = [UIFont systemFontOfSize:17];
    }
}

#pragma mark -
#pragma mark Handle events

- (void)textFieldDidChange:(REFormattedNumberField *)textField
{
    self.item.value = textField.unformattedText;
    if (self.item.onChange)
        self.item.onChange(self.item);
}

@end
