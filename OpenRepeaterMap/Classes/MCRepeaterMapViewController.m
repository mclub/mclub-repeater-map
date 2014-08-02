//
//  CDRepeaterMapViewController.m
//  ClusterDemo
//
//  Created by Patrick Nollet on 11/10/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import "MCRepeaterMapViewController.h"
#import "MCRepeaterInfoAnnotation.h"

@implementation MCRepeaterMapViewController
- (NSString *)seedFileName {
    return @"repeaters";
}

- (NSString *)pictoName {
    return @"single_annotation.png";
}

- (NSString *)clusterPictoName {
    return @"cluster_annotation.png";
}

-(void) loadAnnotations{
    NSLog(@"Loading data…");
    self.annotations = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.seedFileName ofType:@"json"]];
        
        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            MCRepeaterInfoAnnotation * annotation = [[MCRepeaterInfoAnnotation alloc] initWithDictionary:annotationDictionary];
            [self.annotations addObject:annotation];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Building KD-Tree…");
            [self.mapView setAnnotations:self.annotations];
        });
    });
}
@end
