//
//  SingleListTableViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "SingleListTableViewController.h"
#import "AddItemViewController.h"
#import "Item+CoreDataClass.h"
@interface SingleListTableViewController ()

@end

@implementation SingleListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.prefersLargeTitles = NO;
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    if ([[self.listName valueForKey:@"listName"]isEqualToString:@"nil"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self initializeFetchedResultsController];
    [[self tableView]reloadData];
}
-(void) initializeFetchedResultsController {
    NSFetchRequest  *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    NSSortDescriptor *listNameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"itemCategory" ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listName = %@",[self.listName valueForKey:@"listName"]];
    [request setSortDescriptors:@[listNameDescriptor]];
    [request setPredicate:predicate];
   // [self setFetchedResultsController:self.fetchedResultsController  initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    [self setFetchedResultsController:self.fetchedResultsController];
    NSError *errpr = nil;
    if (![self.fetchedResultsController   performFetch:&errpr]){
        NSLog(@"Failed to init FRS: %@\n%@",[errpr localizedDescription], [errpr userInfo]);
        abort();
    }
}
- (IBAction)saveAndGoBack:(UIBarButtonItem *)sender {
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   /* return 1;*/
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController]sections][section];
    return [sectionInfo numberOfObjects];
  /*  int displayCount = 0;
    //[[self.items valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]
    for(int i=0; i < [self.items count]; i++) {
        if ([[self.items[i] valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {
        displayCount++;}
        NSLog(@"items in list: %d",displayCount);}
    return displayCount;*/
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SingleListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    /*
    NSManagedObjectModel *anItem = [self.items objectAtIndex:indexPath.row];
   // NSString * itemListName = [NSString stringWithFormat:@"%@",self.listName];
  //  NSLog(@"The list name is: %@",[self.listName valueForKey:@"listName"]);
     if ([[anItem valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {*/
    
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //if ([[object valueForKey:@"listName"] isEqualToString:[self.listName valueForKey:@"listName"]]) {
    [cell.textLabel setText:[object valueForKey:@"itemName"]];
    [cell.detailTextLabel setText:[object valueForKey:@"itemCategory"]];
    //}
  //  NSLog(@"%@ - %@ - %@",[anItem valueForKey:@"itemName"],[anItem valueForKey:@"itemCategory"],[anItem valueForKey:@"listName"]);
    // Configure the cell...
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [[UIColor blackColor]CGColor];
    UIFont *cellFont = [UIFont fontWithName:@"Verdana" size:17];
    cell.textLabel.font =cellFont;
    cell.detailTextLabel.font = cellFont;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
        return YES;
    
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [context deleteObject: [self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"%@ %@", error, [error localizedDescription]);
    }
    
    //delete row from memory object
   // [self.items removeObjectAtIndex:indexPath.row];
   // [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}


#pragma mark - fetched results delegate
-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [[self tableView] beginUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeSection:(nonnull id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type{
    switch(type){
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
        case NSFetchedResultsChangeDelete:
            [[self tableView]deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
        
            break;
    }
}
-(void)controller: (NSFetchedResultsController*)controller didChangeObject:(nonnull id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{
    switch(type){
        case NSFetchedResultsChangeInsert:
            [[self tableView]insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView]insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [[self tableView] endUpdates];
}
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AddItemViewController *updateItemView = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"editItemInfo"]) {
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        NSManagedObjectModel *selectedItem = [self.fetchedResultsController objectAtIndexPath:path];
        updateItemView.anItem = selectedItem;
        updateItemView.listName = self.listName;
        NSLog(@"%@",self.listName);
    } else if ([[segue identifier] isEqualToString:@"addItemInfo"])   {
        updateItemView.listName = self.listName;
    }
}



@end
