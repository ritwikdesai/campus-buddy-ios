//
//  IITRTimeTableParser.h
//  CampusBuddy
//
//  Created by Ritwik Desai on 07/03/14.
//  Copyright (c) 2014 Ritwik Desai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCSVParser.h"

@class IITRTimeTableParser;

@protocol IITRTimeTableDelegate<NSObject>

@optional

-(void) parserDidBeginParsing:(IITRTimeTableParser *)parser;

-(void)parserDidFinishParsing:(IITRTimeTableParser*)parser parsedData:(NSArray*)data;

-(void)parser:(IITRTimeTableParser*)parser didFailWithError:(NSError*)error;


@end



@interface IITRTimeTableParser : NSObject<CHCSVParserDelegate>

@property (weak,nonatomic) id<IITRTimeTableDelegate> delegate;

@property (strong,nonatomic) NSString * filePath;

+(instancetype) initWithContentsOfCSVFile:(NSString*)path delegate:(id)delegate parseAutomatically:(BOOL)automatically;

-(instancetype) initWithContentsOfCSVFile:(NSString *)path delegate:(id)delegate;

-(void) parse;


@end
