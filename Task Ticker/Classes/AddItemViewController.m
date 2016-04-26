//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "AddItemViewController.h"
#import "ChecklistItem.h"

@interface AddItemViewController ()

@end

@implementation AddItemViewController {
    NSString *text;
    NSString *notes;
    NSString *priority;
    NSString *priorityToDisplay;
    BOOL shouldRemind;
    NSDate *dueDate;
}


///synthesize properties

@synthesize textField, notesField, doneBarButton;
@synthesize delegate;
@synthesize itemToEdit;
@synthesize switchControl;
@synthesize dueDateLabel, priorityLabel, priorityLabelToDisplay;



///we display current date and time when we present the additemvewcontroller to user
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        text = @"";
        shouldRemind = NO;
        dueDate = [NSDate date];
    }
    return self;
}


/// NSdate formetter to fprmat date and update the label when user picked different date 
- (void)updateDueDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.dueDateLabel.text = [formatter stringFromDate:dueDate];
}



///we enable done bar button only when text field length is more than one character.
- (void)updateDoneBarButton
{
    self.doneBarButton.enabled = ([text length] > 0);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /// custom background view with our own image
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-background.jpg"]];


    
    ///we check whether it is editing mode or adding mode, then set the title and fields appropriately.  

    if (self.itemToEdit != nil) {
        self.title = @"Edit Item";
        
    } else
        
        self.title = @"Add Item";
    self.textField.text = text;
    self.notesField.text = notes;
    self.priorityLabel.text = priority;
    self.priorityLabelToDisplay.text = priorityToDisplay;
    self.switchControl.on = shouldRemind;
    [self updateDoneBarButton];
    [self updateDueDateLabel];
    
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.title != NSLocalizedString(@"Edit Item", nil)) {
        [self.textField becomeFirstResponder];
        self.priorityLabelToDisplay.text = @"None";
        self.priorityLabel.text = @"";
        
    }else
        [self.textField resignFirstResponder];
}





/// method to call addItemViewControllerDidCancel method when cancel button pressed

- (IBAction)cancel
{
    [self.delegate addItemViewControllerDidCancel:self];
}


/// method to call didFinishAddingItem method when Done button pressed


- (IBAction)done
{
    if (self.itemToEdit == nil) {
        ChecklistItem *item = [[ChecklistItem alloc] init];
        item.text = self.textField.text;
        item.notes = self.notesField.text;
        item.checked = NO;
        item.priority = self.priorityLabel.text;
        item.priorityToDisplay = self.priorityLabelToDisplay.text;
        item.checked = NO;
        item.shouldRemind = self.switchControl.on;
        item.dueDate = dueDate;
        [item scheduleNotification];
        [self.delegate addItemViewController:self didFinishAddingItem:item];
    } else {
        self.itemToEdit.text = self.textField.text;
        self.itemToEdit.notes = self.notesField.text;
        self.itemToEdit.priority = self.priorityLabel.text;
        self.itemToEdit.priorityToDisplay = self.priorityLabelToDisplay.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.dueDate = dueDate;
        [self.itemToEdit scheduleNotification];
        [self.delegate addItemViewController:self didFinishEditingItem:self.itemToEdit];
    }
}



///we take not when the user tap on the UISwitch and we create local notification only if it is turned on
- (IBAction)switchChanged:(UISwitch *)sender
{
    shouldRemind = sender.on;
    
    
}



///optionally we can dismiss keyboard if the user starts to scroll the tableview

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
    [self.notesField resignFirstResponder];
    
}




///to prevent the uitableview cell turns blue when user taps on it

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return indexPath;
    } else {
        return nil;
    }
}







- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

///release te memory by setting nil to these fields as we no loner need them

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setNotesField:nil];
    [self setDoneBarButton:nil];
    [self setSwitchControl:nil];
    [self setDueDateLabel:nil];
    [self setPriorityLabel:nil];
    [self setPriorityLabelToDisplay:nil];
    [super viewDidUnload];
}


///we present stored item if the user editing an item

- (void)setItemToEdit:(ChecklistItem *)newItem
{
    if (itemToEdit != newItem) {
        itemToEdit = newItem;
        text = itemToEdit.text;
        notes = itemToEdit.notes;
        priority = itemToEdit.priority;
        priorityToDisplay = itemToEdit.priorityToDisplay;
        shouldRemind = itemToEdit.shouldRemind;
        dueDate = itemToEdit.dueDate;
    }
}





/// method to check whether the text field has any text in it. if user type a text then it enables the Done bar button. otherwise it will disable the done bar button. therefore the user not able to press the button. this ensures that empty text are not delegated to checklistviewcontroller

#pragma mark - Table view data source

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

- (BOOL)notesField:(UITextView *)theNotesField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theNotesField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
}



///we use prepare for segue method to display date picker controller

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickDate"]) {
        DatePickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.date = dueDate;
    }
}



///we use delegate method from date view controller. We don't store any new info if the user press cancel button
- (void)datePickerDidCancel:(DatePickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


///we use delegate method from date view controller. We store the new date when the user press done button

- (void)datePicker:(DatePickerViewController *)picker didPickDate:(NSDate *)date
{
    dueDate = date;
    [self updateDueDateLabel];
    [self dismissViewControllerAnimated:YES completion:nil];
}



///configure what to display in picker action sheet when the user tap on priority label

- (IBAction)priority:(id)sender
{
    
    self.pickerActionSheet = [[UIPickerActionSheet alloc] initForView:self.view];
    self.pickerActionSheet.delegate = self;
    
    NSArray *items = @[@"None", @"Low", @"Medium", @"High"];
    [self.pickerActionSheet show:items];
    
    
    
}



///we don't make any changes if the user didn't select pick any priority

- (void)pickerActionSheetDidCancel:(UIPickerActionSheet*)aPickerActionSheet
{
    // User cancelled
}



///we update the priority labels according user to user selection in picker list

- (void)pickerActionSheet:(UIPickerActionSheet*)aPickerActionSheet didSelectItem:(id)aItem
{
    
    NSString *string = (NSString*)aItem;
    
    if ([string isEqualToString:@"None"]) {
        
        self.priorityLabelToDisplay.text = @"None";
        
        self.priorityLabel.text = @"";
        
    } if ([string isEqualToString:@"Low"]) {
        
        self.priorityLabelToDisplay.text = @"Low";
        
        self.priorityLabel.text = @"!";
        
    } if ([string isEqualToString:@"Medium"]) {
        
        self.priorityLabelToDisplay.text = @"Medium";
        
        self.priorityLabel.text = @"!!";
        
    } if ([string isEqualToString:@"High"]) {
        
        self.priorityLabelToDisplay.text = @"High";
        
        self.priorityLabel.text = @"!!!";
        
    }
    
}




@end
