//
//  TPKitTests.m
//  TPKitTests
//
//  Created by Eliran Ben-Ezra on 1/24/16.
//  Copyright © 2016 Threeplay Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

/*
 
 
 TPContainerProtocol
   allKeys
   
 
 container = [TPResourcePackerContainer containerWithContentsOfFile:];
  withData
  withStream:

 container.allKeys
 
 container stringForKey:]
 container dataForKey:]
 container streamForKey:]
 [container randomAccessDataForKey:]

 
 TPStreamInterface
    dataWithLength:(NSRange) => TPPromise
 TPSeekableSteamInterface
    seekToOffset => TPPromise
    dataInRange
       seekToOffset
       dataWithLength



 TPRandomAccessData 
     dataInRange:(NSRange) => TPPromise

 TPStreamData
     dataWithLength:(NSRange) => TPPromise


 

 Securely verify application/in-app purchases:
   1. Check if a receipt has been checked (compare SHA256 signature)
        if checked pull the value of the check and use it
   2. Use online service to query if the receipt is valid and extract specific data
   3. Verify the verification (see how to sign the file)
   4.

 
-(TPPromise *)verifyReceipt:(NSData *)receipt securedStorage{
  NSData *signature = [receipt SHA256HashWithPassword:@""];
   
}
 
   signature = [receipt calculateSHA256Siganture]
   
   storedReply = [securedStorage dictionaryWithKey:@"receipt"]
   if ( storedReply && [storedReply[@"signature"] isEqaul:siganture] )
     return storedReply[@"onlineVerificationPacket"];
   verifyReceipt(recepit) onSuccess:
      [securedStorage putObject:@{@"signature": signature, @"onlineVerificationPacket": data} withKey:@"receipt"]
      return data;



   securedStorage 

 TPSecureStorage
    putObject:(NSData *)object withKey:
 
    getObject:key
    
    verifyObjectKey
 

 Todo:
 
   - An encrypted container with password
      the container have different types of objects
      - Strings
      - Data
 
      each object have a name and can be accessed
     
 
   container = [TPContainer containerWithData:]
  
   container.allKeys => returns an empty list if container is not unlocked
 
   [container unlockWithPassword:]

   container[@"key"] 
   [container valueForKey:@"key];


   In addition, develop a tool that will scan *.m files and special files
   for TPOB_STRING(), TPOB_DATA etc,. and convert them into key readings
 
    so it will be as follows:
  
      [TPContainer defaultContainer][@"key"] to access any information
 
      and the tool will create a container with the key inside
 
      Another options is to provide the name of the container
 
   [TPContainer containerNamed:@"container"][@"key"];


 TPContainer is a protocol
 Also instead of data use 
 
   TPData source
     
 
   TPData allows for data stored on disk to be loaded incrementally when required
 
    it supports requests to load all at once, or load part that required
 
TPStorage returns an entire object not partial object
 
  TPReadStorage
    getObject
  TPWriteStorage
    putObject
    deleteObject
  TPRWStorage <TPReadStorage, TPWriteStorage>
 

TPContainer (each object in the container can have its own type)
   (TPContainer Protocol is compatible with NSDictionary so NSDictionar can be TPContainer)
  allKeys

  TPSecuredContainer
      unlockWithCredentials:
      lock

 
 resourcePacket format
   open-header
     signature
     sha1 signature
   encrypted data
     numberOfObjects:Long, list of objects size:Long
   list of objects
      nameLength:Word, objectName:UTF8, offset:Long, size:Long, type:
   data contains all the objects data

 
   The signature is not encrypted, in addition, a sha1 of the entire file

 [TPContainer containerNamed:];
 [TPContainer defaultContainer];
 [TPContainer setDefaultContainer:];


 
   TPDataContainer <TPContainer>
      

   TPResourcePackerContainer <TPSecuredContainer>

 [TPContainer containerWithData:]
 [TPContainer containerWithPromise:]

 container.isReady
 container.isUnlocked
 container.isLocked
 container.streamDataWithKey
 
 TPStreamData


  [container stringWithKey:];
  [container dataWithKey:];
  [container dictionaryWithKey:];
 [container serializedJSONWithKey:]; # NSJSONSerialization

 */
#import "TPKit.h"

static const char *hexTestBytes = "\x00\x01\xa0\xff";
static NSString *hexTestString = @"0001a0ff";

@interface TPKitTests : XCTestCase

@end

@implementation TPKitTests

-(void)setUp {
  [super setUp];
}
-(void)test_that_a_string_can_convert_bytes_to_hex {
  XCTAssertEqualObjects([NSString stringWithHexOfBytes:hexTestBytes count:4],hexTestString);
}
-(void)test_that_data_can_convert_itself_to_hex {
  XCTAssertEqualObjects([[NSData dataWithBytes:hexTestBytes length:4] hexString], hexTestString);
}
-(void)tearDown {
  [super tearDown];
}
@end
