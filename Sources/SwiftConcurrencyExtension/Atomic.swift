//
//  Atomic.swift
//
//
//  Created by Ji-Hwan Kim on 10/29/23.
//

import Foundation

public actor Atomic<Value> {
    public var value: Value
    
    public init(value: Value) {
        self.value = value
    }
}

extension Atomic {
    public func compareAndSet(predicate: (Value) -> Bool, new supplier: () -> Value) {
        if predicate(self.value) {
            self.value = supplier()
        }
    }
}

extension Atomic where Value: BinaryInteger {
    public func increment(by delta: Value = 1) {
        self.value += delta
    }
    
    public func decrement(by delta: Value = 1) {
        self.value -= delta
    }
    
    public func getAndIncrement(by delta: Value = 1) -> Value {
        let value = value
        self.value += delta
        
        return value
    }
    
    public func incrementAndGet(by delta: Value = 1) -> Value {
        self.value += delta
        
        return self.value
    }
    
    public func getAndDecrement(by delta: Value = 1) -> Value {
        let value = value
        self.value -= delta
        
        return value
    }
    
    public func decrementAndGet(by delta: Value = 1) -> Value {
        self.value -= delta
        
        return self.value
    }
}
