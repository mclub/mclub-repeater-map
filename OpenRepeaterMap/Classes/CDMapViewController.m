//
//  CDMapViewController.m
//  ClusterDemo
//
//  Created by Patrick Nollet on 09/10/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

#import "CDMapViewController.h"
#import "ADClusterableAnnotation.h"

#define NUMBER_OF_ANNOTATIONS 1000

@interface CDMapViewController()
@property(nonatomic) BOOL centerUserLocation;
@end

@implementation CDMapViewController
@synthesize mapView = _mapView;

#pragma mark - NSObject


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = NO;

    /*
    self.mapView.visibleMapRect = MKMapRectMake(135888858.533591, 92250098.902419, 190858.927912, 145995.678292);
    */
//    self.mapView.delegate = self;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(30.28022, 120.11774);//self.mapView.userLocation.location.coordinate;
    if(!CLLocationCoordinate2DIsValid(center)){
        center = CLLocationCoordinate2DMake(30.28022, 120.11774);
    }
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 500000, 500000);
    region = [self.mapView regionThatFits:region];
    _mapView.region = region;

    [self loadAnnotations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Abstract methods

- (NSString *)seedFileName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

- (NSString *)pictoName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

- (NSString *)clusterPictoName {
    NSAssert(FALSE, @"This abstract method must be overridden!");
    return nil;
}

/*
 * by default will load basic type of clustered annotation
 */
-(void) loadAnnotations{
    self.annotations = [[NSMutableArray alloc] init];
    NSLog(@"Loading data…");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData * JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.seedFileName ofType:@"json"]];
        
        for (NSDictionary * annotationDictionary in [NSJSONSerialization JSONObjectWithData:JSONData options:kNilOptions error:NULL]) {
            ADClusterableAnnotation * annotation = [[ADClusterableAnnotation alloc] initWithDictionary:annotationDictionary];
            [self.annotations addObject:annotation];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Building KD-Tree…");
            [self.mapView setAnnotations:self.annotations];
        });
    });
}

#pragma mark - ADClusterMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADClusterableAnnotation"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"ADClusterableAnnotation"];
        pinView.image = [UIImage imageNamed:self.pictoName];
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}

- (MKAnnotationView *)mapView:(ADClusterMapView *)mapView viewForClusterAnnotation:(id<MKAnnotation>)annotation {
    MKAnnotationView * pinView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ADMapCluster"];
    if (!pinView) {
        pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                               reuseIdentifier:@"ADMapCluster"];
        pinView.image = [UIImage imageNamed:self.clusterPictoName];
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    return pinView;
}


- (void)mapViewDidFinishClustering:(ADClusterMapView *)mapView {
    NSLog(@"Done");
}

- (NSInteger)numberOfClustersInMapView:(ADClusterMapView *)mapView {
    return 20;
}

- (double)clusterDiscriminationPowerForMapView:(ADClusterMapView *)mapView {
    return 1.8;
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView{
    self.centerUserLocation = YES;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if(self.centerUserLocation){
        self.centerUserLocation = NO;
        // Set the proper map zoom
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500000, 500000);
        region = [self.mapView regionThatFits:region];
        [self.mapView setRegion:region animated:YES];
    }
}

@end
