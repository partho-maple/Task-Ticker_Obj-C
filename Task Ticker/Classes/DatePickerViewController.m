//
//  DatePickerViewController.m
//  Task List
//
//  Created by Partho Biswas on 12/9/12.
//  Copyright (c) 2012 Partho Biswas. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController {
    UILabel *dateLabel;
}

@synthesize tableView;
@synthesize datePicker;
@synthesize delegate;
@synthesize date;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"backgroundfordatepicker.png"]];
    
    self.title = NSLocalizedString(@"Choosedate", nil);

    datePicker.minimumDate = [NSDate date];

}




- (void)viewDidUnload
{
    [super viewDidUnload];
    self.tableView = nil;
    self.datePicker = nil;
    dateLabel = nil;
    
    
}


- (IBAction)cancel
{
    [self.delegate datePickerDidCancel:self];
}
- (IBAction)done
{
    [self.delegate datePicker:self didPickDate:self.date];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.datePicker setDate:self.date animated:YES];
}



- (void)updateDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    dateLabel.text = [formatter stringFromDate:date];
}


- (IBAction)dateChanged
{
    self.date = [self.datePicker date];
    [self updateDateLabel];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:@"DateCell"];
                             dateLabel = (UILabel *)[cell viewWithTag:1000];
                             [self updateDateLabel];
                             return cell;
                             }
                             - (NSIndexPath *)tableView:(UITableView *)theTableView willSelectRowAtIndexPath
                                                                           :(NSIndexPath *)indexPath
    {
        return nil;
    }



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(
                                                                        NSInteger)section
{
    return 77;
}
                             
@end
