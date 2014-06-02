//
//  ViewController.m
//  Location Library Utils
//
//  Created by Pradeep on 28/04/14.
//  Copyright (c) 2014 Pradeep. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"

@interface ViewController ()
{

}
@property(nonatomic,copy)  void(^ reverseGeocodeBlock)(NSDictionary *);

@end

@implementation ViewController
@synthesize reverseGeocodeBlock;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
}


- (CLLocationDistance)getDistanceBetweenTwoCordinates:(double)lat1 longitude1:(double)long1  latitude2:(double)lat2 longitude2:(double)long2
{
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:long1];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:lat2   longitude:long2];
    CLLocationDistance distance = [location1 distanceFromLocation:location2];
    [location1 release];
    [location2 release];
    return distance;
}


#pragma mark GeoCoding Methods
- (void)getCordinatesFromAddress:(NSString*)addressString responseBlock:(void(^)(CLLocation *cordinate))locationBlock
{
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:addressString
                 completionHandler:^(NSArray* placemarks, NSError* error)
    {
                     
                     if ([placemarks count]>0)
                     {
                         CLPlacemark *clPlace = [placemarks objectAtIndex:0];
                         CLLocation *location = clPlace.location;
                         locationBlock(location);
                     }else
                     {
                         
                         locationBlock(nil);
                     }
                     
    }];
    [geocoder release];
}


#pragma mark ReverseGeocoding Methods

- (void)getAddressInfoFromLocationLatitude:(double)latCord longitude:(double)longCord completionBlock:(void(^)(NSDictionary * addressDic))block
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latCord longitude:longCord];
    self.reverseGeocodeBlock = block;
    if([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:
         ^(NSArray* placemarks, NSError* error)
         {
             if ([placemarks count] > 0)
             {
                 CLPlacemark *placeMark = [placemarks objectAtIndex:0];
                 block(placeMark.addressDictionary);
             }else
             {
                 block(nil);
             }
         }];
        
        [geocoder release];
    }else
    {
            MKReverseGeocoder* geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:location.coordinate];
            geocoder.delegate = self;
            [geocoder start];
    }
    [location release];
}

#pragma mark ReverseGeoCoder Delagate
- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFindPlacemark:(MKPlacemark*)place
{
    self.reverseGeocodeBlock(place.addressDictionary);
    [self.reverseGeocodeBlock release];
    [geocoder release];
}

- (void)reverseGeocoder:(MKReverseGeocoder*)geocoder didFailWithError:(NSError*)error
{
    self.reverseGeocodeBlock(nil);
    [self.reverseGeocodeBlock release];
    [geocoder release];
}


#pragma mark ReverseGeoCodingUsing GoogleAPI

- (void)getAddressInfoFromGoogleApiLatitude:(double)latCord longitude:(double)longCord completionBlock:(void(^)(NSDictionary * addressDic))block
{
    NSString *requestUrl=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",latCord,longCord];
    requestUrl = [requestUrl stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setTimeoutInterval:60];
    [request setURL:[NSURL URLWithString:requestUrl]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSString *responseString = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    if (error)
    {
        block(nil);
        
    }else
    {
        responseString  = [[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding];
        if (responseString.length)
        {
            NSMutableDictionary *dicResult  = [responseString JSONValue];
            if ([[dicResult objectForKey:@"status"] isEqualToString:@"OK"])
            {
                NSArray *arrayResult = [dicResult objectForKey:@"results"];
                if ([arrayResult count]>0)
                {
                    block([arrayResult objectAtIndex:0]);
                }else
                {
                    block(nil);
                }
            }else
            {
                block(nil);
            }
            
        }else
        {
            block(nil);
        }
        [responseString release];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
