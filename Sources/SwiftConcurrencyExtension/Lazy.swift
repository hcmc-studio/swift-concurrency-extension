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

public struct AsyncLazy<Value> {
    private let lock = Mutex()
    private let initiailzer: () async -> Value
    private var value: Any = uninitialized
    
    public init(initiailzer: @escaping () async -> Value) {
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

public struct ThrowableAsyncLazy<Value> {
    private let lock = Mutex()
    private let initiailzer: () async throws -> Value
    private var value: Any = uninitialized
    
    public init(initiailzer: @escaping () async throws -> Value) {
        self.initiailzer = initiailzer
    }
    
    public mutating func get() async throws -> Value {
        if let value = value as? Value {
            return value
        } else {
            return try await lock.withLock {
                if let value = value as? Value {
                    return value
                } else {
                    let o = try await initiailzer()
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
