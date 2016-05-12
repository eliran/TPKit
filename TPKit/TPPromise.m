//
//  QSPromise.m
//  testDepends
//
//  Created by Eliran Ben-Ezra on 12/8/14.
//  Copyright (c) 2014 Threeplay. All rights reserved.
//

#import "TPPromise.h"

@implementation TPPromise {
  TPPromiseState    _state;
  BOOL              handlersReady;
  TPPROMISE_HANDLER handlers[TPPromiseStates];
  id                _returnObject;
  // Next Promise info
  TPPromiseState    _nextState;
  id                _nextObject;
}
+(TPPromise *)noHandlers {
  return [[TPPromise new] noHandlers];
}
+(TPPromise *)newWithBlock:(void (^)(TPPromise *))promiseBlock {
  TPPromise *promise = [TPPromise new];
  if ( promiseBlock ) promiseBlock(promise);
  return promise;
}
+(instancetype)newWithBlock:(void (^)(TPPromise *))promiseBlock
                  onSuccess:(TPPROMISE_HANDLER)successBlock
                  onFailure:(TPPROMISE_HANDLER)failureBlock {
  TPPromise *newPromise = [self newWithBlock:promiseBlock];
  return [newPromise onSuccess:successBlock onFailure:failureBlock];
}
+(instancetype)newWithBlock:(void (^)(TPPromise *))promiseBlock
                      onAny:(TPPROMISE_HANDLER)anyBlock {
  return [self newWithBlock:promiseBlock onSuccess:anyBlock onFailure:anyBlock];
}
+(instancetype)newWithBlock:(void (^)(TPPromise *))promiseBlock
                  onSuccess:(TPPROMISE_HANDLER)successBlock {
  return [self newWithBlock:promiseBlock onSuccess:successBlock onFailure:nil];
}
+(instancetype)newWithBlock:(void (^)(TPPromise *))promiseBlock
                  onFailure:(TPPROMISE_HANDLER)failureBlock {
  return [self newWithBlock:promiseBlock onSuccess:nil onFailure:failureBlock];
}
+(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock
               onFailure:(TPPROMISE_HANDLER)failureBlock {
  TPPromise *newPromise = [self new];
  [newPromise onSuccess:successBlock onFailure:failureBlock];
  return newPromise;
}
+(instancetype)onAny:(TPPROMISE_HANDLER)anyBlock {
  return [self onSuccess:anyBlock onFailure:anyBlock];
}
+(instancetype)onSuccess:(TPPROMISE_HANDLER)successBlock {
  return [self onSuccess:successBlock onFailure:nil];
}
+(instancetype)onFailure:(TPPROMISE_HANDLER)failureBlock {
  return [self onSuccess:nil onFailure:failureBlock];
}
+(instancetype)succeededWithObject:(id)object {
  TPPromise *promise = [self new];
  [promise succeededWithObject:object];
  return promise;
}
+(instancetype)failedWithObject:(id)object {
  TPPromise *promise = [self new];
  [promise failedWithObject:object];
  return promise;
}
+(instancetype)failedWithError:(NSError *)error {
  return [self failedWithObject:error];
}
-(BOOL)isTriggered {
  return _state != TPPromiseStateNotTriggered;
}
-(void)forwardPromise {
  if ( _nextState != TPPromiseStateNotTriggered && !_defered && handlersReady ) {
    // If returned a promise, we need to link it to our own nextPromise
    if ( _nextPromise && !_forwarded ) {
      _forwarded = YES;
      [(TPPromise *)_nextPromise trigger:_nextState withObject:_nextObject];
    }
  }
}
-(void)executeHandler {
  if ( handlersReady && _state >= 1 && _state <= TPPromiseStates ) {
    _returnObject = _object;
    if ( handlers[_state-1] ) {
      _returnObject = handlers[_state-1](self);
      if ( [_returnObject isKindOfClass:TPPromise.class] ) {
        _defered = YES;
        // Got promise other then ourselves, we need to defer until that promise chain is done
        if ( _returnObject != self ) {
          // Look for the end of the chain and add ourselves to that chain
          while ( [(TPPromise *)_returnObject nextPromise] ) {
            _returnObject = [(TPPromise *)_returnObject nextPromise];
          }
          [[(TPPromise *)_returnObject noHandlers] setNextPromise:_nextPromise];
        }
      }
      else if ( _nextState == TPPromiseStateNotTriggered ) {
        _nextState  = _state;
        _nextObject = _returnObject;
      }
    }
    else if ( _nextState == TPPromiseStateNotTriggered ) {
      _nextState  = _state;
      _nextObject = _returnObject;
    }
    handlers[0] = handlers[1] = nil; // Release handlers once they have been used (We never trigger them twice)
    [self forwardPromise];
  }
}
-(TPPROMISE_HANDLER)successBlock {
  return handlers[TPPromiseStateSucceeded-1];
}
-(TPPROMISE_HANDLER)failureBlock {
  return handlers[TPPromiseStateFailed-1];
}
-(void)setState:(TPPromiseState)state block:(TPPROMISE_HANDLER)block {
  if ( state >= 1 && state <= TPPromiseStates && block ) {
    if ( handlers[state-1] == nil ) {
      handlers[state-1] = [block copy];
    }
    else @throw [NSError errorWithDomain:@"promise" code:0 userInfo:@{NSLocalizedDescriptionKey:@"Cannot set promise handler when there is already an handler"}];
  }
}
-(void)setNextPromise:(TPPromise *)nextPromise {
  if ( nextPromise ) {
    if ( _nextPromise == nil ) {
      _nextPromise = nextPromise;
      [self forwardPromise];
    }
  }
}
-(id)trigger:(TPPromiseState)state withObject:(id)object {
  if ( _state == TPPromiseStateNotTriggered ) {
    _state = state;
    _object = object;
    [self executeHandler];
    return object;
  }
  else if ( _nextState == TPPromiseStateNotTriggered ) {
    _nextState  = state;
    _nextObject = object;
    if ( _defered ) {
      _defered = NO;
      [self forwardPromise];
    }
    return object;
  }
  return nil;
}
-(id)cancel {
  _canceled = YES;
  // Clear all state & objects
  handlersReady = NO;
  _nextState = _state = TPPromiseStateNotTriggered;
  _returnObject = _object = nil;
  handlers[0] = handlers[1] = nil;
  _nextPromise = nil;
  return nil;
}
-(id)defer {
  _defered = YES;
  return self;
}
-(id)succeededWithObject:(id)object {
  return [self trigger:TPPromiseStateSucceeded withObject:object];
}
-(id)failedWithObject:(id)object {
  return [self trigger:TPPromiseStateFailed withObject:object];
}
-(id)failedWithError:(NSError *)error {
  return [self trigger:TPPromiseStateFailed withObject:error];
}
//
-(TPPromise *)onSuccess:(TPPROMISE_HANDLER)successBlock onFailure:(TPPROMISE_HANDLER)failedBlock {
  [self setState:TPPromiseStateSucceeded block:successBlock];
  [self setState:TPPromiseStateFailed block:failedBlock];
  TPPromise *nextPromise = _nextPromise;
  if ( nextPromise == nil ) {
    _nextPromise = nextPromise = [TPPromise new];
  }
  handlersReady = YES;
  [self executeHandler];
  return nextPromise;
}
-(TPPromise *)noHandlers {
  handlersReady = YES;
  [self executeHandler];
  return self;
}
-(TPPromise *)onSuccess:(TPPROMISE_HANDLER)successBlock {
  return [self onSuccess:successBlock onFailure:nil];
}
-(TPPromise *)onFailure:(TPPROMISE_HANDLER)failedBlock {
  return [self onSuccess:nil onFailure:failedBlock];
}
-(TPPromise *)onAny:(TPPROMISE_HANDLER)anyBlock {
  return [self onSuccess:anyBlock onFailure:anyBlock];
}

-(TPPromise *)logFailure {
  return [self logFailureWithLevel:TPLoggerLevelError];
}
-(TPPromise *)logFailureWithLevel:(TPLoggerLevel)level {
  return [self logFailureWithLogger:TPLogger.defaultLogger level:level];
}
-(TPPromise *)logFailureWithLogger:(TPLogger *)logger level:(TPLoggerLevel)level {
  return [self onFailure:^id(TPPromise <NSError *>*p) {
    [logger log:level message:@"%@", p.object];
    return p.object;
  }];
}
-(TPPromise *)forwardToPromise:(TPPromise *)targetPromise {
  return [self onSuccess:^id(TPPromise *p) {
    [targetPromise succeededWithObject:p.object];
    return p.object;
  } onFailure:^id(TPPromise *p) {
    [targetPromise failedWithObject:p.object];
    return p.object;
  }];
}
@end
