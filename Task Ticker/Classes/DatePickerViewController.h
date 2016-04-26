//
//  DatePickerViewController.h
//  Task List
//
//  Created by Partho Biswas on 12/9/12.
//  Copyright (c) 2012 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DatePickerViewController;

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)datePickerDidCancel:(DatePickerViewController *)picker;
- (void)datePicker:(DatePickerViewController *)picker didPickDate:(NSDate *)date;

@end

@interface DatePickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) id <DatePickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDate *date;

- (IBAction)cancel;
- (IBAction)done;
- (IBAction)dateChanged;

@end
