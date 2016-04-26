//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import "ChecklistViewController.h"

@interface ChecklistViewController ()

@end

#import "ChecklistItem.h"


@implementation ChecklistViewController {
    
    NSMutableArray *items;
    
    
}

///synthesize the table view so that we can assign the banner view later where to show

@synthesize TableView;


///synthesize the activitycontroller
@synthesize activityViewController;

///synthesize ilteredtabledata, searchbar and filterstatus
@synthesize filteredTableData;
@synthesize searchBar;
@synthesize isFiltered;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
///title of view controller
    
    self.title = @"Checklist";

///table view background with our own custom image
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-background.jpg"]];
    
 ///initialize pull to refresh control
    
    [self.refreshControl
     addTarget:self
     action:@selector(refresh)
     forControlEvents:UIControlEventValueChanged
     ];

 /// initialize banner view for iAd
    
 //   bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
 //   [bannerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
 //   bannerView.delegate = self;
 
    
/// configure left navigation bar button item as edit button. This edit button has a mechanism of changing its title to "Done" when it pressed
  
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    
    
    ///create add and share buttons to be right bar button of navigation controllers
    
    UIBarButtonItem *addButton         = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(refresh)];
    
    UIBarButtonItem *shareButton         = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                              target:self
                                            action:@selector(shareButtonClicked:)];
    
    
    self.navigationItem.rightBarButtonItems =
    [NSArray arrayWithObjects:addButton, shareButton, nil];
    
}





///Creates a list of path strings for the specified directories in the specified domains. The list is in the order in which you should search the directories. If expandTilde is YES, tildes are expanded as described in stringByExpandingTildeInPath.
///we define the plist shall be saved in our own directory

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

///Returns a new string made by appending to the receiver a given string. Note that this method only works with file paths (not, for example, string representations of URLs).
///we save the plist in the documents director of our application

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Checklists.plist"];
}



///Method to save the data to plist

- (void)saveChecklistItems
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:items forKey:@"ChecklistItems"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
}


///decode the plist
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self loadChecklistItems];
    }
    return self;
}



///we load decoded data to tableview
- (void)loadChecklistItems
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        items = [unarchiver decodeObjectForKey:@"ChecklistItems"];
        [unarchiver finishDecoding];
    }
    else
    {
        items = [[NSMutableArray alloc] initWithCapacity:20];
    }
}





///Tells the data source to return the number of rows in a given section of a table view. (required)
/// Number of rows in tableview. we leave it to count it itself and we don't limit it.
///we check the filter status and then count the rows accordingly

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(                                                                       NSInteger)section
{
    
    int rowCount;
    if(self.isFiltered)
        rowCount = filteredTableData.count;
    else
        rowCount = items.count;
    
    return rowCount;
   // return [items count];
}


///Asks the data source for a cell to insert in a particular location of the table view. (required)
/// here we configure uitableview cell. this will be reused for te whole tableview
///we supply tableview cell for search table as well


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChecklistItem";

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    

    if (cell == nil)
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    ChecklistItem* item;
    
    if(isFiltered)
        item = [filteredTableData objectAtIndex:indexPath.row];
    else
        item = [items objectAtIndex:indexPath.row];
    
    
 //   ChecklistItem *item = [items objectAtIndex:indexPath.row];
    
    [self configureTextForCell:cell withChecklistItem:item];
    [self configureCheckmarkForCell:cell withChecklistItem:item];

    return cell;

}

///We use NSPrediction method to search. this will search in both Text and Notes 

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
        [self.tableView reloadData];

    }
    else
    {
        isFiltered = true;
        filteredTableData = [[NSMutableArray alloc] init];
        
        for (ChecklistItem* item in items)
        {
            NSRange nameRange = [item.text rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [item.notes rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [filteredTableData addObject:item];

            }
        }
    }
    
    [self.tableView reloadData];
  

}



///to dismiss keyboard
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self resignFirstResponder];
}




///we don't show the cancel button of search bar
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.showsCancelButton = NO;
}




///Tells the delegate that the user tapped the accessory (disclosure) view associated with a given row.
/// we declare the touch event of accessory button of uitableview cell. When user tap on the accessory button, it should bring editing mode

- (IBAction)accessoryButtonTapped:(id)sender event:(id)event
{
	NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:self.tableView];
	NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
	if (indexPath != nil)
		
	{
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath: indexPath];
	}
}


/// following method configures uitableviewcell when user taps on it. It also toggles when tap again

- (void)configureCheckmarkForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{

    
    {
    if (item.checked) {
        
        UIButton *checkBox = (UIButton *)[cell viewWithTag:1503];
        checkBox.hidden=FALSE;
        
  
        
        UILabel *label = (UILabel *)[cell viewWithTag:1000];
        label.alpha = 0.4;
        
        UILabel *notesLabel = (UILabel *)[cell viewWithTag:1500];
        notesLabel.alpha = 0.2;
        
        UIButton *accesoorybutton = (UIButton *)[cell viewWithTag:1005];
        accesoorybutton.hidden=TRUE;
        
        
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1600];
        dueDateLabel.alpha = 0.4;
        
        UILabel *priorityLabel = (UILabel *)[cell viewWithTag:1200];
        priorityLabel.alpha = 0.4;

        
        
        
    } else {
 
        
        UIButton *checkBox = (UIButton *)[cell viewWithTag:1503];
        checkBox.hidden=TRUE;
        
        
        UILabel *label = (UILabel *)[cell viewWithTag:1000];
        label.alpha = 1.0;

        
        UILabel *notesLabel = (UILabel *)[cell viewWithTag:1500];
        notesLabel.alpha = 1.0;
        
        UIButton *accesoorybutton = (UIButton *)[cell viewWithTag:1005];
        accesoorybutton.hidden=FALSE;
        
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1600];
        dueDateLabel.alpha = 1.0;
        
        UILabel *priorityLabel = (UILabel *)[cell viewWithTag:1200];
        priorityLabel.alpha = 1.0;

        }
    
    }
    
    
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:1500];
    notesLabel.text = item.notes;

    
    if (notesLabel.text == nil) {
        
   
        
        
    }
}



///Set background of uitable view cell with our own custom image. we also set the seperator style between cell to none

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
        
    cell.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item-bg.png"]];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

///The method allows the delegate to specify rows with varying heights. If this method is implemented, the value it returns overrides the value specified for the rowHeight property of UITableView for the given row.
/// height of uitable view cell which overrides interface builder

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 53;
}



/// following method configures uitableviewcell text when user adds a new item

- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{
    
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    label.text = item.text;
    
    UILabel *labelwithoutnotes = (UILabel *)[cell viewWithTag:999];
    labelwithoutnotes.text = item.text;
    
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:1500];
    notesLabel.text = item.notes;
    
    
    UILabel *priorityLabel = (UILabel *)[cell viewWithTag:1200];
    priorityLabel.text = item.priority;
    
    
    if (item.shouldRemind == YES) {
        
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1600];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        dueDateLabel.text = [formatter stringFromDate:item.dueDate];
        
    } else
    {
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1600];
        dueDateLabel.text = nil;
        
    }

}

///The delegate handles selections in this method. One of the things it can do is exclusively assign the check-mark image (UITableViewCellAccessoryCheckmark) to one row in a section (radio-list style). This method isn’t called when the editing property of the table is set to YES (that is, the table view is in editing mode)
///when the user tap on the particular cell, we treat it as the item is completed and we call cofigurecheckmarkforcell method to display checkmark and update plist.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    ChecklistItem* item;
    
    if(isFiltered)
    {
        item = [filteredTableData objectAtIndex:indexPath.row];
    }
    else
    {
        item = [items objectAtIndex:indexPath.row];
    }
    
      //  ChecklistItem *item = [items objectAtIndex:indexPath.row];
        [item toggleChecked];
        [self configureCheckmarkForCell:cell withChecklistItem:item];
        [self saveChecklistItems];
        
}

///A swipe motion across a cell does not cause the display of a Delete button unless the table view's data source implements the tableView:commitEditingStyle:forRowAtIndexPath: method.
///When users tap the insertion (green plus) control or Delete button associated with a UITableViewCell object in the table view, the table view sends this message to the data source, asking it to commit the change. (If the user taps the deletion (red minus) control, the table view then displays the Delete button to get confirmation.) The data source commits the insertion or deletion by invoking the UITableView methods insertRowsAtIndexPaths:withRowAnimation: or deleteRowsAtIndexPaths:withRowAnimation:, as appropriate.

///when user swip left to right or right to left, table view enters into editing mode and prepares to delete the data from table view. once user deleted, we remove that particular item from plist.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [items removeObjectAtIndex:indexPath.row];
    [self saveChecklistItems];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
}




///The presenting view controller is responsible for dismissing the view controller it presented. If you call this method on the presented view controller itself, it automatically forwards the message to the presenting view controller.
///dismiss view controller presented

- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


///Save the added item and dismiss view controller presented

- (void)addItemViewController:(AddItemViewController *)controller didFinishAddingItem:(ChecklistItem *)item
{
    int newRowIndex = [items count];
    [items addObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];}



/// A UIStoryboardSegue object is responsible for performing the visual transition between two view controllers. In addition, segue objects are used to prepare for the transition from one view controller to another. Segue objects contain information about the view controllers involved in a transition. When a segue is triggered, but before the visual transition occurs, the storyboard runtime calls the current view controller’s prepareForSegue:sender: method so that it can pass any needed data to the view controller that is about to be displayed. The UIStoryboardSegue class supports the standard visual transitions available in UIKit. You can also subclass to define custom transitions between the view controllers in your storyboard file. You do not create segue objects directly. Instead, the storyboard runtime creates them when it must perform a segue between two view controllers. You can still initiate a segue programmatically using the performSegueWithIdentifier:sender: method of UIViewController if you want. You might do so to initiate a segue from a source that was added programmatically and therefore not available in Interface Builder.

/// When the user taps on "Add" button, "additem" segue is triggered and add new item view controller is presented. wen user tap on accessory button, "edititem" is triggered and item view controller is presented in editing mode.

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemViewController *controller = (AddItemViewController *)navigationController.topViewController;
        controller.delegate = self;
    }else if ([segue.identifier isEqualToString:@"EditItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        AddItemViewController *controller = (AddItemViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.itemToEdit = sender;
    }
}

///The delegate usually responds to the tap on the disclosure button (the accessory view) by displaying a new view related to the selected row. This method is not called when an accessory view is set for the row at indexPath.
///When accessory item is tapped, edit item will be presented of the selected item

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    ChecklistItem *item = [items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditItem" sender:item];
    
}



///Save the edited item and dismiss view controller presented

- (void)addItemViewController:(AddItemViewController *)controller didFinishEditingItem:(ChecklistItem *)item
{
    int index = [items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    [self saveChecklistItems];
    [self dismissViewControllerAnimated:YES completion:nil];
}

///A UIRefreshControl object provides a standard control that can be used to initiate the refreshing of a table view’s contents. You link a refresh control to a table through an associated table view controller object. The table view controller handles the work of adding the control to the table’s visual appearance and managing the display of that control in response to appropriate user gestures. In addition to assigning a refresh control to a table view controller’s refreshControl property, you must configure the target and action of the control itself. The control does not initiate the refresh operation directly. Instead, it sends the UIControlEventValueChanged event when a refresh operation should occur. You must assign an action method to this event and use it to perform whatever actions are needed. The UITableViewController object that owns a refresh control is also responsible for setting that control’s frame rectangle. Thus, you do not need to manage the size or position of a refresh control directly in your view hierarchy.

///refresh (aka pulltorefresh activated additem identifier. Upon activation, we stop refreshing.

- (void)refresh
{
    [self performSegueWithIdentifier:@"AddItem" sender:self];
    
    [self.refreshControl endRefreshing];
    
}


///Define whether reorder is allowed. Set to NO if reorder is not allowed

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



/// Identfy which row is reordered and update the table view and save the plist file.

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id objectToMove = [items objectAtIndex:fromIndexPath.row];
    [items removeObjectAtIndex:fromIndexPath.row];
    [items insertObject:objectToMove atIndex:toIndexPath.row];
    [tableView reloadData];
    [self saveChecklistItems];
}



///whent the user tap on the share button, we prepare the list and supply to activitycontroller. activity controller is responsible when user tap on the reletive share option

-(IBAction) shareButtonClicked:(id)sender
{
     NSMutableString *emailBody = [NSMutableString stringWithCapacity:1000];
     
     for (ChecklistItem *item in self->items)
     {
     [emailBody appendString:item.text];
     [emailBody appendString:@"\r\n"];
     }
     
     
     
    
    self.activityViewController = [[UIActivityViewController alloc]
                                   
                                   initWithActivityItems:@[emailBody] applicationActivities:nil];
    
    [self presentViewController:self.activityViewController animated:YES completion:nil];
    
    
}



/*


///iAd Implementation
// Comment below code to deactivate iAd in the project

//=========================================================================================================



/// We set iAd banner to top of table view

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    TableView.tableHeaderView = bannerView;
    
    
}


/// The iAd banner should rotate when device change orientation

 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
        bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierLandscape;
    else
        bannerView.currentContentSizeIdentifier =
        ADBannerContentSizeIdentifierPortrait;
    
    return YES;
}


 
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}


- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}


///In the case when iAd fails to load, we remove the empty ad banner from tableview header

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    TableView.tableHeaderView = nil;
    
}


/// release banner view as no longer need to retain in the memory

-(void)viewDidUnload
{
    bannerView = nil;


}

//=========================================================================================================


*/





@end
