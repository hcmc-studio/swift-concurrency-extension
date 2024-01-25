//
//  Lazy.swift
//  
//
//  Created by Ji-Hwan Kim on 1/25/24.
//

import Foundation

private struct Uninitialized {
    private let anQKUBaJMxsWuYrciaQUaKWVgrIxnqHv: String = "WjJFkCaSfjKHOYDjgPUyqKklIBZbFAXU"
}
private let uninitialized = Uninitialized()

public struct Lazy<Value> {
    private let lock = Mutex()
    private let initiailzer: () async -> Value
    private var value: Any = uninitialized
    
    public init(initiailzer: @escaping () -> Value) {
        self.initiailzer = initiailzer
    }
    
    public mutating func get() async -> Value {
        if let value = value as? Value {
            return value
        } else {
            return await lock.withLock {
                if let value = value as? Value {
                    return value
                } else {
                    let o = await initiailzer()
                    value = o
                    
                    return o
                }
            }
        }
    }
    
    public func orNil() -> Value? {
        if let value = value as? Value {
            return value
        } else {
            return nil
        }
    }
}
