//
//  MCRepeaterInfoAnnotation.m
//  ClusterDemo
//
//  Created by Shawn Chain on 14-8-2.
//  Copyright (c) 2014年 Applidium. All rights reserved.
//

#import "MCRepeaterInfoAnnotation.h"


@interface MCRepeaterInfoAnnotation ()

@end

@implementation MCRepeaterInfoAnnotation

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.name = dict[@"name"];//[dictionary objectForKey:@"name"];
        self.coordinate = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lon"] doubleValue]);
        
        self.ctcss = dict[@"ctcss"];
        self.dcs = dict[@"dcs"];
        self.upFreq = dict[@"upFreq"];
        self.downFreq = dict[@"downFreq"];
        self.opentime = dict[@"opentime"];
        self.admin = dict[@"admin"];
        self.note = dict[@"note"];
    }
    return self;
}

- (NSString *)title {
    return self.description;
}

- (NSString *)subtitle {
    NSString *freq = nil;
    if(self.ctcss.length > 0){
        freq = [NSString stringWithFormat:@"%@/%@/%@",self.downFreq,self.upFreq,self.ctcss];
    }else if(self.dcs.length > 0){
        freq = [NSString stringWithFormat:@"%@/%@/%@",self.downFreq,self.upFreq,self.dcs];
    }else{
        freq = [NSString stringWithFormat:@"%@/%@",self.downFreq,self.upFreq];
    }
    return freq;
}

- (NSString *)description {
    return _name;
}
@end
