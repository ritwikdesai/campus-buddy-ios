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

+(NSString *) getDatabasePathFromAppDelegate ;

+(RDDataAccess*) getDatabaseHelper;

+(RDDataAccess*) getDatabaseHelperForDatabaseWithName:(NSString *) name;

-(BOOL) openDatabase;

-(BOOL) closeDatabase;

//Generalized
-(id) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*) tableName  forId:(NSNumber*)ID withIdColumnName:(NSString*)columnName;

-(NSArray*) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*) tableName  forId:(NSNumber*)ID havingColumnName:(NSString*) columnName selectColumns:(NSArray*)array orderBy: (ORDER) order withRespectToColumns:(NSArray *)orderarray andHasColumnKeys:(NSDictionary *)keys;

-(NSArray *) getObjectModelOfClass:(Class) model fromTableWithName:(NSString*)tableName selectColumns:(NSArray*)array whereClause:(NSString *) sqlWhere orderBy:(ORDER) order withRespectToColumns:(NSArray*) orderarray andHasColumnKeys:(NSDictionary*)keys;

-(FMResultSet *) executeQuery:(NSString *)query;

@end