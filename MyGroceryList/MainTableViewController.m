//
//  MainTableViewController.m
//  MyGroceryList
//
//  Created by bloqhed on 12/15/17.
//  Copyright © 2017 cvr. All rights reserved.
//

#import "MainTableViewController.h"
#import "SingleListTableViewController.h"
#import "masterTableViewCell.h"
#import "Lists+CoreDataClass.h"
@interface MainTableViewController (){
    NSString *newListName;
    UITextField   *cellTextField;
}

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    context = appDelegate.persistentContainer.viewContext;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    UIView *navTitleView = [[UIView alloc]initWithFrame:CGRectMake(0,0, 300, 400)];
    UILabel *label = [[UILabel alloc]init];
    [label setTextColor:[UIColor blackColor]];
    [label setFont: [UIFont fontWithName:@"Verdana-Bold" size:36]];
    [label setText:@"Shopping Cart"];
    [label sizeToFit];
    [navTitleView addSubview:label];
    self.navigationItem.titleView = navTitleView;
    
}
-(void)viewDidAppear:(BOOL)animated {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Lists"];
    self.lists = [[context executeFetchRequest:fetchRequest error:nil]mutableCopy];
    if ([self.lists count] == 0){
        Lists *myList = [[Lists alloc]initWithContext:context];
        [self.lists addObject:myList];
    }
    [self.tableView reloadData];
  
    
}

- (IBAction)addNewList:(UIBarButtonItem *)sender {
    Lists *myList = [[Lists alloc]initWithContext:context];
    
    [self.lists addObject:myList];
    [self.tableView reloadData];
    NSLog(@"%@",self.lists);

}
-(void)addNewList{
    Lists *myList = [[Lists alloc]initWithContext:context];
    
    [self.lists addObject:myList];
    [self.tableView reloadData];
}
- (IBAction)cellTextFieldDoneEditing:(UITextField *)sender {
    
    newListName = [[NSString alloc]initWithString:sender.text];
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    Lists *myList = [[Lists alloc]initWithContext:context];
    [myList setValue:newListName forKey:@"listName"];
    [self.lists replaceObjectAtIndex:path.row withObject:myList];
   
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
    [self.tableView reloadData];
    NSLog(@"%@",myList);
    
}
-(IBAction)dismissKeyboard:(id)sender{
    [self resignFirstResponder];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.lists count] == 0){
        return 1;
    }
    return [self.lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    masterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"masterTableViewCell" forIndexPath:indexPath];
    
        NSManagedObjectModel *list = [self.lists objectAtIndex:indexPath.row];
        [cell.listTextField setText:[list valueForKey:@"listName"]];
    cell.layer.borderWidth = 2;
    cell.layer.borderColor = [[UIColor blackColor]CGColor];
    cell.listTextField.font = [UIFont fontWithName:@"Verdana" size:17];
    cell.listTextField.layer.borderColor = [[UIColor blackColor]CGColor];
    cell.listTextField.layer.borderWidth = 2;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.lists count] > 1 )
            return YES;
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
        
    
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            // Delete the row from the data source
            [context deleteObject:[self.lists objectAtIndex:indexPath.row]];
        
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"%@ %@", error, [error localizedDescription]);
        }
    
    //delete row from memory object
        [self.lists removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSManagedObjectModel *listName = [self.lists objectAtIndex:path.row];
    NSLog(@"%ld",path.row);
     NSLog(@"%@",listName);
    if ([[segue identifier] isEqualToString:@"editList"]){
        
        SingleListTableViewController *destination = [segue destinationViewController];
        
        destination.listName = listName;
        
    }
}
-(void)unWindSegue:(UIStoryboardSegue *)seg {
    
    NSError *error = nil;
    if (![context save:&error]){
        NSLog(@"%@ %@",error,[error localizedDescription]);
    }
}

@end
