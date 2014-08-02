//
//  MCRepeaterInfoAnnotation.h
//  ClusterDemo
//
//  Created by Shawn Chain on 14-8-2.
//  Copyright (c) 2014年 Applidium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "ADMapCluster.h"


@interface MCRepeaterInfoAnnotation : NSObject <MKAnnotation>

@property(nonatomic,readwrite,strong) NSString *name;
@property(nonatomic,readwrite,strong) NSString *upFreq;
@property(nonatomic,readwrite,strong) NSString *downFreq;
@property(nonatomic,readwrite,strong) NSString *ctcss;
@property(nonatomic,readwrite,strong) NSString *dcs;

@property(nonatomic,readwrite,strong) NSString *opentime;
@property(nonatomic,readwrite,strong) NSString *admin;
@property(nonatomic,readwrite,strong) NSString *note;

@property (nonatomic) CLLocationCoordinate2D coordinate;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end