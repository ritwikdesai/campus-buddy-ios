//
//  TTSettingsViewController.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 15/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "TTSettingsViewController.h"
#import "SubjectListViewController.h"
#import "RDUtility.h"
#import "NZAlertView.h"
@interface TTSettingsViewController ()

@property NSArray * settingsArray;

-(void) didSavedCSVTimeTable;

@end

@implementation TTSettingsViewController

@synthesize settingsArray = _settingsArray;
@synthesize dataSource = _dataSource;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Settings";
    self.settingsArray = @[@"Subject List",@"Reset Time Table",@"Reset Subject List",@"Import Time Table"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)]];

     
  
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
    return self.settingsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.settingsArray objectAtIndex:indexPath.row];
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectSubjects"]) {
        [segue.destinationViewController setSegueTag:1];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)[ self performSegueWithIdentifier:@"selectSubjects" sender:self];
    else if(indexPath.row ==1) {
        [RDUtility removeDictionaryWithKey:@"TT"];
    [self.dataSource reloadTimeTable];
        
        NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                          title:@"Done"
                                                        message:@"Time Table Reset."
                                                       delegate:nil];
        
    //    [alert setTextAlignment:NSTextAlignmentCenter];
        
        [alert show];
    //[self.navigationController popViewControllerAnimated:YES];
        
    }
    else if(indexPath.row ==2)
    {
        [RDUtility removeObjectForKey:@"subjectlist"];
        
        NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                          title:@"Done"
                                                        message:@"Subject List Removed."
                                                       delegate:nil];
        
        //[alert setTextAlignment:NSTextAlignmentCenter];
        
        [alert show];
    }
    
    
    if(indexPath.row ==3)
    {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"tt" ofType:@"csv"];
        IITRTimeTableParser * parser = [[IITRTimeTableParser alloc] initWithContentsOfCSVFile:path delegate:self];
        
        [parser parse];
        
        NZAlertView *alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                          title:@"Done"
                                                        message:@"Successfully Imported"
                                                       delegate:nil];
        
       // [alert setTextAlignment:NSTextAlignmentCenter];
        
        [alert show];

    }
}

#pragma mark - Parser Delegate

-(void)parserDidBeginParsing:(IITRTimeTableParser *)parser
{
    
}

-(void) parserDidFinishParsing:(IITRTimeTableParser *)parser parsedData:(NSArray *)data
{
    NSLog(@"Data %@",data);
    
    __weak TTSettingsViewController * weakself = self;
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
       
        NSInteger baseIndex = 5;
        
        __block NSInteger timeCount =1;
        
        NSArray * currentSubjectList = (NSArray*)[RDUtility getObjectForKey:@"subjectlist"];
        
        NSMutableSet * subjectSet = [[NSMutableSet alloc] initWithArray:currentSubjectList];
        
        [data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if(idx<baseIndex) return ;
            
            //NSLog(@"INDEX KEY %d",(100*(timeCount)+ idx%5));
            
            [subjectSet addObject:(NSString*)obj];
            
            if(![(NSString*)obj isEqualToString:@""])
                [RDUtility saveObject:(NSString*)obj forKey:[NSString stringWithFormat:@"%i",(100*(timeCount)+ idx%5)] inDictionaryWithKey:@"TT"];
            
            if((idx+1)%5 ==0)timeCount++;
            
        }];
        
        
        
        
        [RDUtility saveObject:[[subjectSet allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]forKey:@"subjectlist"];

        
        [weakself performSelectorOnMainThread:@selector(didSavedCSVTimeTable) withObject:nil waitUntilDone:YES];
        
    });
    
   
    
    
}

-(void)didSavedCSVTimeTable
{
    
    [self.dataSource reloadTimeTable];
}

-(void) parser:(IITRTimeTableParser *)parser didFailWithError:(NSError *)error
{
    
    
}
@end
