//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "DatePickerViewController.h"
#import "UIPickerActionSheet.h"

///declare delagate methods

@class AddItemViewController;
@class ChecklistItem;

/// We pass the creted information to checkviewcontroller using delegate method.
@protocol AddItemViewControllerDelegate <NSObject>

///This method declares when user tap on the cancel button, it will dismiss the additem view controller presenting without saving the data
- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller;



///This method pass the relevant "added" information such as task, notes, whether to remind to checklistview controller
- (void)addItemViewController:(AddItemViewController *)controller didFinishAddingItem:(ChecklistItem *)item;




///This method pass the relevant "edited" information such as task, notes, whether to remind to checklistview controller
- (void)addItemViewController:(AddItemViewController *)controller didFinishEditingItem:(ChecklistItem *)item;
@end


/// confirm that textfield, datpicker and actionsheet delegates to self
@interface AddItemViewController : UITableViewController <UITextFieldDelegate, DatePickerViewControllerDelegate, UIPickerActionSheetDelegate>


/// textField is a field where user key in the task information. 
@property (strong, nonatomic) IBOutlet UITextField *textField;

/// notesField is a field where user key in the additional information.
@property (strong, nonatomic) IBOutlet UITextView *notesField;

/// We create doneBarButton as IBOutlet so that we can disable the done button if the text field is empty.
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;

///confirms delegate method
@property (nonatomic, weak) id <AddItemViewControllerDelegate> delegate;

///We declare itemtoedit method to display information for user to edit 
@property (nonatomic, strong) ChecklistItem *itemToEdit;


///we need a switch control for user to toggle whether notification is required
@property (nonatomic, strong) IBOutlet UISwitch *switchControl;

///this is the notification time which user selects
@property (nonatomic, strong) IBOutlet UILabel *dueDateLabel;

///We display the periority as per user selection
@property (nonatomic, strong) IBOutlet UILabel *priorityLabel;

///the we present to user whether the priority is low, high or medium but we update  as !, !! !!!. therefore we need another label
@property (nonatomic, strong) IBOutlet UILabel *priorityLabelToDisplay;

///we use picker action sheet to display priority options. User can choose one of them. If the user didn't select any, priority will be set to none
@property (nonatomic, strong) UIPickerActionSheet *pickerActionSheet;


///create IBActions

///We create cancel IBAction. when user tap on cancel button, we dismiss the presenting view controller by calling AddItemViewControllerDelegate using delegate method
- (IBAction)cancel;

///We create done IBAction. when user tap done button, we dismiss the presenting view controller by calling didFinishAddingItem using delegate method which will pass the added/edited information to checklistviewcontroller
- (IBAction)done;

///We record when the user change the switch
- (IBAction)switchChanged:(UISwitch *)sender;

///When user tab on the priority label, we call this method and present uipicker action sheeet with priority options
- (IBAction)priority:(id)sender;

@end