# TPKit

![](https://travis-ci.org/eliran/TPKit.svg?branch=master)

A Collection of useful utility classes and extensions

## Classes

### TPPromise

TPPromise class uses the promise pattern of appending success & failure handlers to a previous promise and
let the chain of handlers execute once a result success/failure is triggered on the root promise.

### TPLogger

TPLogger allows adding logging messages with different logging levels and enable/disable levels through one point.
In addition, different log reporters can be attached to the logger object, which allows different processing of the log to occur.

Usage:

        [TPLogger log:level message:@"message %@", argument]; // using defaultLogger
        [loggerObject error:@"error %@", argument]; // using alloc/init object
        [[TPLogger defaultLogger] attachReporter:uploadLogToServerReporter]

## Lazy Array/Dictionary



### QRange

creates a lazy array return a range of integers
        
        [QRange integerRangeFrom:10 to:20].lazy

### NSArrayGenerator

creates a lazy array from a NSArray

        [NSArrayGenerator initWithArray:array]

## Extensions

### NSArray & NSDictionary lazy extension

invoking #lazy method on NSArray or NSDictionary return a lazy NSArrayGenerator or NSDictionaryGenerator, respectively

NSArray & NSDictionary are further extended with various method like map, filter, keep, each and reduce.
These extensions lazify the array/dictionary run the respective method and return a concrete object of array/dictionary with 
the result.

### NSDictionary safe field extracting

various method to extract fields and return a typed object if field exists and can be converted to the requested type,
otherwise returns a default value or null.

available method: numberField, arrayField, stringField, dictionaryField, integerField, realField and field

### NSString extension

Return a string with lowercase hex representation of the bytes

        +(NSString *)stringWithHexOfBytes:count:  

Return the range of the string

        -(NSRange)range


