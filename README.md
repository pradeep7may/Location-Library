Location-Library
================

Get Function for all the location working

```
    This function is used for calculating the distance between two cordinates.
 
    INPUT
        #lat1  - latitude of 1st point
        #long1 - longitude of 1st point
        #lat2  - latitude of 2nd point
        #long2 - longitude of 2nd point
    OUTPUT 
        #returns the distance in meters from point 1 to point 2
    FRAMEWORK
        #CoreLocation.framework
        
- (CLLocationDistance)getDistanceBetweenTwoCordinates:(double)lat1 longitude1:(double)long1  latitude2:(double)lat2 longitude2:(double)long2;

```


```
    This method is used for getting the cordinate from the address of a location. 
    INPUT
        #address string
    OUTPUT
        #CLLocation information containing cordinates and other information
    FRAMEWORK
        #CoreLocation.framework
    NOTE
        Support only in iOS 5.0 and above
 
- (void)getCordinatesFromAddress:(NSString*)addressString responseBlock:(void(^)(CLLocation *cordinate))locationBlock;

```

```
    This method is used for getting the address information from the latitude and longitude.
    INPUT
        #latCord - latitude 
        #longCord - longitude
    OUTPUT
        #NSDictionary containing the address information
    FRAMEWORK
        #CoreLocation.framework
        #MapKit.framework

    NOTE
        #Uses CLLocation for iOS 5.0 and above And MKReverseGeoCoder for below iOS 5.0

-(void)getAddressInfoFromLocationLatitude:(double)latCord longitude:(double)longCord completionBlock:(void(^)(NSDictionary * addressDic))block;

```


```

This method is used for getting the address information from the latitude and longitude using Google Api( http://maps.googleapis.com )
    INPUT
        #latCord - latitude
        #longCord - longitude
    OUTPUT
        #NSDictionary containing the address information
    FRAMEWORK
        #JSON framework


-(void)getAddressInfoFromGoogleApiLatitude:(double)latCord longitude:(double)longCord completionBlock:(void(^)(NSDictionary * addressDic))block;

```
