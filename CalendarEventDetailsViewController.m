//
//  CalendarEventDetailsViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 01/03/14.
//  Copyright (c) 2014 Ritwik Desai. All rights reserved.
//

#import "CalendarEventDetailsViewController.h"
#import "RDUtility.h"
#import "RDDatabaseHelper.h"
@interface CalendarEventDetailsViewController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray * events;

@end

@implementation CalendarEventDetailsViewController

 
- (IBAction)finish:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) didPopulateData:(id) data
{
    self.events = [data objectForKey:@"events"];
    
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 20+self.navigationBar.frame.size.height, self.navigationBar.frame.size.width, 0.25)];
    
    view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
   
    
    __weak CalendarEventDetailsViewController * weakSelf = self;
    
    [RDUtility executeBlock:^NSDictionary *{
        
        NSDictionary * dic = nil;
        
        NSArray * array = [RDDatabaseHelper getEventsForDate:weakSelf.date];
        
        dic = [[NSDictionary alloc] initWithObjects:@[array] forKeys:@[@"events"]];
        return dic;
        
    } target:self selector:@selector(didPopulateData:)];
    
              // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(finish)];

}

 
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.events count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [self.events objectAtIndex:indexPath.row];
//    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Helvetica" size:17] constrainedToSize:CGSizeMake(280, 111111) lineBreakMode:NSLineBreakByWordWrapping];
   
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(280, 999)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:17]}
                                         context:nil];
    
    CGSize size = textRect.size;
     
    
    NSLog(@"%f",size.height);
    return size.height + 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Event Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text =[self.events objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentJustified;
    cell.textLabel.numberOfLines = 5;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
