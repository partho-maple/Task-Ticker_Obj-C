//
//  AppDelegate.h
//  Checklist
//
//  Created by Partho Biswas on 8/7/13.
//  Copyright (c) 2013 Partho Biswas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemViewController.h"
#import <iAd/iAd.h>
#import <MessageUI/MFMailComposeViewController.h>



@interface ChecklistViewController : UITableViewController <AddItemViewControllerDelegate, ADBannerViewDelegate, MFMailComposeViewControllerDelegate, UISearchBarDelegate>
{
    ///declare tableview and banner view for iAd banner
    
    UITableView *TableView;

    ADBannerView *bannerView;
}


//declare property of tableview. So that we can define whether the iAd panel shall be shown as header of table view or footer of table view.

@property (nonatomic, retain) IBOutlet UITableView *TableView;



///declare property for activitycontroller to show whenuser tap on search button
@property (nonatomic, strong) UIActivityViewController *activityViewController;

///create a property for action to be called when user tap on sharebutton
-(IBAction) shareButtonClicked:(id)sender;



///declare NSMutableArray property for filtered table data
@property (strong, nonatomic) NSMutableArray* filteredTableData;

///declare property for searchbar
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

///create a property to check the status
@property (nonatomic, assign) bool isFiltered;




@end
