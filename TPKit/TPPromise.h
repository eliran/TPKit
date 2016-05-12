//
//  QSPromise.h
//  TPPromise
//
//  Created by Eliran Ben-Ezra on 12/8/14.
//  Copyright (c) 2014 Threeplay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPLogger.h"
/// \class TPPromise
/// create promise objects that can be chained together
///   and have synchronise or asynchronise dispatching
///   
@class TPPromise;

typedef id(^TPPROMISE_HANDLER)(TPPromise *p);
typedef NS_ENUM(NSUInteger, TPPromiseState) {
  TPPromiseStateNotTriggered,
  TPPromiseStateSucceeded,
  TPPromiseStateFailed,
  TPPromiseStates
};

@interface TPPromise<__covariant ObjectType> : NSObject
/// YES, when either succeededWithObject: or failedWithObject: was called on
///   the promise object
@property (readonly,getter=isTriggered)BOOL triggered;
/// YES, when -cancelPromise was called on the promise
@property (readonly,getter=isCanceled) BOOL canceled;
/// YES, when -defer was called on the promise
@property (readonly,getter=isDefered)BOOL defered;
/// YES, when promise state has been forwared to the next promise in chain
@property (readonly,getter=iSForwarded)BOOL forwarded;
/// The trigger state of the promise
@property (readonly)TPPromiseState    state;
@property (readonly)TPPROMISE_HANDLER successBlock;
@property (readonly)TPPROMISE_HANDLER failureBlock;
/// The object associated with the promise's state
@property (readonly)ObjectType object;
/// The next promise in the chain that will be dispatched.
///  If this value is nil and is assigned a promise when
///  the current promise is already triggered, this new promise
///  will be triggered immediatly
@property (readwrite,nonatomic)TPPromise *nextPromise;
/// Creating promises
+(instancetype)noHandlers;
// Always returns the first object not the next object
+(instancetype)newWithBlock:(void(^)(TPPromise *promise))promiseBlock;
+(instancetype)newWithBlock:(void (^)(TPPromise *promise))promiseBlock
                  onSuccess:(TPPROMISE_HANDLER)successBlock
                  onFailure:(TPPROMISE_HANDLER)failureBlock;
+(instancetype)newWithBlock:(void (^)(TPPromise *promise))promiseBlock
                      onAny:(TPPROMISE_HANDLER)anyBlock;
+(instancetype)newWithBlock:(void (^)(TPPromise *promise))promiseBlock
                      onSuccess:(TPPROMISE_HANDLER)successBlock;
+(instancetype)newWithBlock:(void (^)(TPPromise *promise))promiseBlock
                      onFailure:(TPPROMISE_HANDLER)failureBlock;
+(instancetype)onAny:(TPPROMISE_HANDLER)anyBlock;
+(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock;
+(instancetype)onFailure:(TPPROMISE_HANDLER)failureBlock;
+(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock
               onFailure:(TPPROMISE_HANDLER)failureBlock;
// Instant triggered promises
+(instancetype)succeededWithObject:(ObjectType)object;
+(instancetype)failedWithObject:(ObjectType)object;
+(instancetype)failedWithError:(NSError *)error;
/// Allows promise state to be forwarded without having any handlers defined
-(instancetype)noHandlers;
-(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock;
-(instancetype)onFailure:(TPPROMISE_HANDLER)failureBlock;
-(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock onFailure:(TPPROMISE_HANDLER)failureBlock;
-(instancetype)onAny:(TPPROMISE_HANDLER)anyBlock;
//
/// Cancel forwarding the current promise's state to the next promise.
///  Effectivaly canceling the promise dispatch chain
-(id)cancel;
/// Defers the current promise
-(id)defer;
/// Trigger an non-triggered promise with a succeeded state and object
/// @param object the object that will be associated with this promise
/// @returns incase of changing a promise state from failed to succeeded inside
///  handler block the value from this method need to be the returned value of the
///  block
-(id)succeededWithObject:(ObjectType)object;
/// Trigger an non-triggered promise with a failed state and object
/// @param object the object that will be associated with this promise
/// @returns incase of changing a promise state from succeeded to failed inside
///  handler block the value from this method need to be the returned value of the
///  block
-(id)failedWithObject:(ObjectType)object;
-(id)failedWithError:(NSError *)error;

/// Logging errors
-(TPPromise *)logFailure;
-(TPPromise *)logFailureWithLevel:(TPLoggerLevel)level;
-(TPPromise *)logFailureWithLogger:(TPLogger *)logger level:(TPLoggerLevel)level;
-(TPPromise *)forwardToPromise:(TPPromise *)targetPromise;
@end
