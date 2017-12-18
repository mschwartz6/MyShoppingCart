//
//  MainTableViewController.h
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MainTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>
{
    AppDelegate *appDelegate;
    NSManagedObjectContext *context;
}
@property (strong) NSMutableArray *lists;
@property (strong,nonatomic)NSFetchedResultsController *fetchedResultsController;
@end
