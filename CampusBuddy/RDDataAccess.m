//
//  DatabaseHelper.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import "RDDataAccess.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface RDDataAccess ()


@end
@implementation RDDataAccess

 static RDDataAccess* _databaseHelper;
static FMDatabase* _database;
 
+(RDDataAccess*) getDatabaseHelper
{
    @synchronized([RDDataAccess class])
    {
        if (!_databaseHelper)
          
        { _databaseHelper = [[self alloc] init];
         
          _database = [[FMDatabase alloc] initWithPath:[RDDataAccess getDatabasePathFromAppDelegate]];
        }
        
        return _databaseHelper;
    }
    
    return nil;
}

+(RDDataAccess *)getDatabaseHelperForDatabaseWithName:(NSString *)name
{
    @synchronized([RDDataAccess class])
    {
        if (!_databaseHelper)
            
        { _databaseHelper = [[self alloc] init];
            
            _database = [[FMDatabase alloc] initWithPath:[RDDataAccess getDatabasePathWithName:name]];
        }
        
        return _databaseHelper;
    }
    
    return nil;
}

-(BOOL) openDatabase
{
    BOOL success = NO;
    
    success = [_database open];
    
    return success;
}

-(BOOL) closeDatabase
{
    BOOL success = NO;
    
    success = [_database close];
    _databaseHelper = nil;
    return success;
}

-(id)getObjectModelOfClass:(id)model fromTableWithName:(NSString *)tableName forId:(NSNumber *)ID withIdColumnName:(NSString *)columnName
{
    id oObject = [[model alloc] init];
    NSMutableArray * columnNames = [[NSMutableArray alloc] init];
    NSMutableString * string = [[NSMutableString alloc] initWithString:@"PRAGMA table_info("];
    [string appendString:tableName];
    [string appendString:@");"];
    FMResultSet* result = [_database executeQuery:string];
    while (result.next) {
        [columnNames addObject:(NSString*)[result objectForColumnName:@"name"]];
    }
    
    FMResultSet * resultfortable = [_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%i'",tableName,columnName,[ID integerValue]]];
    
    BOOL get = resultfortable.next;
    if (get) {
        NSLog(@"Database Contains data: %@",@"YES");
    }
    
    @try {
        for (int i=0; i<columnNames.count; i++) {
           
            
            [oObject setValue:[resultfortable objectForColumnName:[columnNames objectAtIndex:i]] forKey:[columnNames objectAtIndex:i]];
        
        }

    }
    @catch (NSException *exception) {
        NSLog(@"Error Model Database Mismatch Error : %@",exception.name);
    }
    @finally {
        // Done
    }

    return oObject;
}

-(NSArray*)getObjectModelOfClass:(Class)model fromTableWithName:(NSString *)tableName forId:(NSNumber *)ID havingColumnName:(NSString *)columnName selectColumns:(NSArray *)array orderBy:(ORDER)order withRespectToColumns:(NSArray *)orderarray andHasColumnKeys:(NSDictionary *)keys
{
   
    
    NSMutableArray * columnNames = [[NSMutableArray alloc] init];
    NSMutableString * string = [[NSMutableString alloc] initWithString:@"PRAGMA table_info("];
    [string appendString:tableName];
    [string appendString:@");"];
    FMResultSet* result = [_database executeQuery:string];
    while (result.next) {
        [columnNames addObject:(NSString*)[result objectForColumnName:@"name"]];
    }
    
    FMResultSet * resultfortable = nil;
    

    
     if(array == nil && ID !=nil) resultfortable =[_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%i'",tableName,columnName,[ID integerValue]]];
    
    else
    {
        NSMutableString * str = [[NSMutableString alloc] initWithString:@"SELECT "];
        
        if(array !=nil)
        {
            for(int i=0;i<[array count] -1;i++)
            {
            if([[array objectAtIndex:i] isKindOfClass:[NSString class]])
            [str appendString:[NSString stringWithFormat:@"%@ , ",[array objectAtIndex:i]]];
            
            else return nil;
            }
        
        if([[array objectAtIndex:[array count]-1] isKindOfClass:[NSString class]])
        {
           if(ID !=nil) [str appendString:[NSString stringWithFormat:@"%@ FROM %@ WHERE %@ = '%i'",[array objectAtIndex:[array count]-1],tableName,columnName,[ID integerValue]]];
            
            else [str appendString:[NSString stringWithFormat:@"%@ FROM %@ ",[array objectAtIndex:[array count]-1],tableName]];
        }
        
        else return nil;
        }
        
        else
        {
            if(ID !=nil) [str appendString:[NSString stringWithFormat:@"* FROM %@ WHERE %@ = '%i'",tableName,columnName,[ID integerValue]]];
            
            else [str appendString:[NSString stringWithFormat:@"* FROM %@ ",tableName]];
        }
        
        
        if(orderarray !=nil)
        {
            [str appendString:@" ORDER BY "];
            for(int i=0;i<[orderarray count] -1;i++)
            {
                if([[array objectAtIndex:i] isKindOfClass:[NSString class]])
                    [str appendString:[NSString stringWithFormat:@"%@ , ",[orderarray objectAtIndex:i]]];
                
                else return nil;
            }
            
            if([[orderarray objectAtIndex:[orderarray count]-1] isKindOfClass:[NSString class]])
            {
                [str appendString:[NSString stringWithFormat:@"%@ ",[orderarray objectAtIndex:[orderarray count]-1]]];
                
                if(order == ASC) [str appendString:@"ASC;"];
                
                else [str appendString:@"DESC;"];
            }
            
            else return nil;
            
        }
        
        NSLog(@"QUERY : %@",str);
        
        resultfortable = [_database executeQuery:[str copy]];
        
    }

    
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    @try {
        while (resultfortable.next) {
           
            id oObject = [[model alloc] init];
            
            for (int i=0; i<columnNames.count; i++) {
                
                if([keys objectForKey:[columnNames objectAtIndex:i]])
                [oObject setValue:[resultfortable objectForColumnName:[columnNames objectAtIndex:i]] forKey:[keys valueForKey:[columnNames objectAtIndex:i]]];
                
            }
            
            [returnArray addObject:oObject];

        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error Model Database Mismatch Error : %@",exception.name);
    }
    @finally {
        // Done
    }
    
    return [returnArray copy];
}

-(NSArray *)getObjectModelOfClass:(Class)model fromTableWithName:(NSString *)tableName selectColumns:(NSArray *)array whereClause:(NSString *)sqlWhere orderBy:(ORDER)order withRespectToColumns:(NSArray *)orderarray andHasColumnKeys:(NSDictionary *)keys
{
    NSMutableArray * columnNames = [[NSMutableArray alloc] init];
    NSMutableString * string = [[NSMutableString alloc] initWithString:@"PRAGMA table_info("];
    [string appendString:tableName];
    [string appendString:@");"];
    FMResultSet* result = [_database executeQuery:string];
    while (result.next) {
        [columnNames addObject:(NSString*)[result objectForColumnName:@"name"]];
    }
    
    FMResultSet * resultfortable = nil;
    
    
    
    if(array == nil && orderarray == nil) resultfortable =[_database executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,sqlWhere]];
    
    else if (array == nil && orderarray !=nil)
    {
            NSMutableString * str = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,sqlWhere]];
        
        [str appendString:@" ORDER BY "];
        
        for(int i=0;i<[orderarray count] -1;i++)
        {
            if([[array objectAtIndex:i] isKindOfClass:[NSString class]])
                [str appendString:[NSString stringWithFormat:@"%@ , ",[orderarray objectAtIndex:i]]];
            
            else return nil;
        }
        
        if([[orderarray objectAtIndex:[orderarray count]-1] isKindOfClass:[NSString class]])
        {
            [str appendString:[NSString stringWithFormat:@"%@ ",[orderarray objectAtIndex:[orderarray count]-1]]];
            
            if(order == ASC) [str appendString:@"ASC;"];
            
            else [str appendString:@"DESC;"];
        }
        
        else return nil;
        
        resultfortable =[_database executeQuery:[str copy]];

    }
    
    else
    {
        NSMutableString * str = [[NSMutableString alloc] initWithString:@"SELECT "];
        
        
            for(int i=0;i<[array count] -1;i++)
            {
                if([[array objectAtIndex:i] isKindOfClass:[NSString class]])
                    [str appendString:[NSString stringWithFormat:@"%@ , ",[array objectAtIndex:i]]];
                
                else return nil;
            }
            
            if([[array objectAtIndex:[array count]-1] isKindOfClass:[NSString class]])
            {
                
                 [str appendString:[NSString stringWithFormat:@"%@ FROM %@ %@",[array objectAtIndex:[array count]-1],tableName,sqlWhere]];
            }
            
            else return nil;
        
        if(orderarray !=nil)
        {
            [str appendString:@" ORDER BY "];
            
            for(int i=0;i<[orderarray count] -1;i++)
            {
                if([[array objectAtIndex:i] isKindOfClass:[NSString class]])
                    [str appendString:[NSString stringWithFormat:@"%@ , ",[orderarray objectAtIndex:i]]];
                
                else return nil;
            }
            
            if([[orderarray objectAtIndex:[orderarray count]-1] isKindOfClass:[NSString class]])
            {
                [str appendString:[NSString stringWithFormat:@"%@ ",[orderarray objectAtIndex:[orderarray count]-1]]];
                
                if(order == ASC) [str appendString:@"ASC;"];
                
                else [str appendString:@"DESC;"];
            }
            
            else return nil;
        }
        
        resultfortable = [_database executeQuery:[str copy]];

    }
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    @try {
        while (resultfortable.next) {
            
            id oObject = [[model alloc] init];
            
            for (int i=0; i<columnNames.count; i++) {
                
                if([keys objectForKey:[columnNames objectAtIndex:i]])
                    [oObject setValue:[resultfortable objectForColumnName:[columnNames objectAtIndex:i]] forKey:[keys valueForKey:[columnNames objectAtIndex:i]]];
                
            }
            
            [returnArray addObject:oObject];
            
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"Error Model Database Mismatch Error : %@",exception.name);
    }
    @finally {
        // Done
    }
    
    return [returnArray copy];
    
}

-(FMResultSet *)executeQuery:(NSString *)query
{
    return [_database executeQuery:query];
}



+(NSString*) getDatabasePathFromAppDelegate
{
    NSString *databaseString = [[NSBundle mainBundle] pathForResource:@"campusbuddy" ofType:@"db"];
    return databaseString;
}

+(NSString*) getDatabasePathWithName:(NSString*)name
{
    NSString *databaseString = [[NSBundle mainBundle] pathForResource:name ofType:@"db"];
    return databaseString;
}

@end
