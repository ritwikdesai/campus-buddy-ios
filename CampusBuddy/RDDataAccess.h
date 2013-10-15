//
//  DatabaseHelper.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 08/07/13.
//  Copyright (c) 2013 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface RDDataAccess : NSObject


typedef enum {ASC,DEC} ORDER;

/*!
 @abstract  gets RDDataAccess object for database with provided name

 @param name    Database name
 */

+(RDDataAccess*) getDataAccessForDatabaseWithName:(NSString *) name;

/*!
 @abstract  Open Database
 */

-(BOOL) openDatabase;

/*!
 @abstract Close Database
 */
-(BOOL) closeDatabase;


/*!
 @abstract  Returns a array of objects for the executed Query
 
 @param model               Class of Object Model
 
 @param tableName           Name of the table to be queried
 
 @param ID                  Id for Where Clause Condition
 
 @param columnName          Column Name for Id
 
 @param array               Array consisting of column names to be selected in the query
 
 @param order               Order By Ascending or Descending
 
 @param orderarray          Array of columns for ordering
 
 @param keys                Key value pairs for maping table entries to object Model
 
 */
-(NSArray*) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*) tableName  forId:(NSNumber*)ID havingColumnName:(NSString*) columnName selectColumns:(NSArray*)array orderBy: (ORDER) order withRespectToColumns:(NSArray *)orderarray andHasColumnKeys:(NSDictionary *)keys;


/*!
 @abstract  Returns a array of objects for the executed Query
 
 @param model               Class of Object Model
 
 @param tableName           Name of the table to be queried

 @param sqlWhere            Where Clause in the query
 
 @param array               Array consisting of column names to be selected in the query
 
 @param order               Order By Ascending or Descending
 
 @param orderarray          Array of columns for ordering
 
 @param keys                Key value pairs for maping table entries to object Model
 
 */

-(NSArray *) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*)tableName selectColumns:(NSArray*)array whereClause:(NSString *) sqlWhere orderBy:(ORDER) order withRespectToColumns:(NSArray*) orderarray andHasColumnKeys:(NSDictionary*)keys;

/*!
 @abstract  Returns FMResultSet object consisting of returned Rows from the Query

 @param query   SQL query to execute
 
 */

-(FMResultSet *) executeQuery:(NSString *)query;

@end