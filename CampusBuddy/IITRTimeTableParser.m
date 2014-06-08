//
//  IITRTimeTableParser.m
//  CampusBuddy
//
//  Created by Ritwik Desai on 07/03/14.
//  Copyright (c) 2014 Ritwik Desai. All rights reserved.
//

#import "IITRTimeTableParser.h"
#import "CHCSVParser.h"
#import "RDUtility.h"
@interface IITRTimeTableParser ()

@property (strong,atomic) CHCSVParser * csvParser;

@property (strong,nonatomic) NSMutableArray * subjectEntries;

@property NSInteger startIndex;

@property BOOL begin;

@property BOOL end;


@end

@implementation IITRTimeTableParser

-(NSMutableArray *)subjectEntries
{
    if(_subjectEntries) return _subjectEntries;
    
    else return _subjectEntries = [[NSMutableArray alloc] init];
}

-(instancetype)initWithContentsOfCSVFile:(NSString *)path delegate:(id)delegate
{
    self = [super init];
    
    if(self){
        
        self.delegate = delegate;
        
        self.filePath = path;
        
        self.csvParser = [[CHCSVParser alloc] initWithContentsOfCSVFile:self.filePath];
        
        self.csvParser.delegate = self;
        
        self.csvParser.sanitizesFields = YES;
        self.begin = NO;
        
        self.end = NO;
    }
    
    return self;
}

+(instancetype)initWithContentsOfCSVFile:(NSString *)path delegate:(id)delegate parseAutomatically:(BOOL)automatically

{
    
    IITRTimeTableParser * parser = [[IITRTimeTableParser alloc] initWithContentsOfCSVFile:path delegate:delegate];
    
    if(automatically) [parser parse];
    
    return parser;
    
    
}

-(void)parse
{
    if(self.csvParser)
    {
        //[self.csvParser parse];
        
        
        [RDUtility executeBlock:^NSDictionary *{
            
            [self.csvParser parse];
            
            return nil;
            
        } target:nil selector:nil];
        
    }
}


-(void)parserDidBeginDocument:(CHCSVParser *)parser

{
    
    if([self.delegate respondsToSelector:@selector(parserDidBeginParsing:)])
    {
        [self.delegate parserDidBeginParsing:self];
    }
}


-(void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{

        if([self.delegate respondsToSelector:@selector(parser:didFailWithError:)])
        {
            [self.delegate parser:self didFailWithError:error];
        }

}


-(void)parserDidEndDocument:(CHCSVParser *)parser
{
 
    if([self.subjectEntries count]<50)
    {
        if([self.delegate respondsToSelector:@selector(parserDidFinishParsing:parsedData:)])
            [self.delegate parserDidFinishParsing:self parsedData:nil];

    }
    
    else{
        if([self.delegate respondsToSelector:@selector(parserDidFinishParsing:parsedData:)])
        [self.delegate parserDidFinishParsing:self parsedData:[self.subjectEntries copy]];
    
    }
}


-(void) parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex

{
    if(self.end) return;
    
    
   if(!self.begin)
   {
       NSString * field_lower = [field lowercaseString];
       
       if([field_lower isEqualToString:@"time"])
       {
           self.begin = YES;
           self.startIndex = fieldIndex;
       }
    
       else if(![field isEqualToString:@""]) {
           
           [self.csvParser cancelParsing];
       }
   }
    
    else
   {
        if(fieldIndex>(self.startIndex) && fieldIndex<(self.startIndex +6))
        {
            [self.subjectEntries addObject:field];
            
            if([self.subjectEntries count] ==50) self.end = YES;
        }
   }
}



@end
