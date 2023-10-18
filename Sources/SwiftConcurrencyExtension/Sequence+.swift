//
//  Sequence+.swift
//
//
//  Created by Ji-Hwan Kim on 10/16/23.
//

import Foundation

extension Sequence {
    public func forEachSerial(
        action: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await action(element)
        }
    }
    
    public func forEachParallel(
        priority: TaskPriority? = nil,
        action: @escaping (Element) async throws -> Void
    ) async rethrows {
        var tasks = [Task<Void, any Error>]()
        for element in self {
            tasks.append(Task<Void, any Error>(priority: priority) {
                try await action(element)
            })
        }
        for task in tasks {
            try await { try await task.value }()
        }
    }
    
    public func mapSerial<Result>(
        transform: (Element) async throws -> Result
    ) async rethrows -> [Result] {
        var arr = [Result]()
        for element in self {
            arr.append(try await transform(element))
        }
        
        return arr
    }
    
    public func mapParallel<Result>(
        priority: TaskPriority? = nil,
        transform: @escaping (Element) async throws -> Result
    ) async rethrows -> [Result] {
        let tasks = map { element in
            Task<Result, any Error>(priority: priority) {
                try await transform(element)
            }
        }
        return try await tasks.mapSerial { task in
            try await task.value
        }
    }
    
    public func filterSerial(
        predicate: (Element) async throws -> Bool
    ) async rethrows -> [Element] {
        var arr = [Element]()
        for element in self {
            if try await predicate(element) {
                arr.append(element)
            }
        }
        
        return arr
    }
    
    public func filterParallel(
        priority: TaskPriority? = nil,
        predicate: @escaping (Element) async throws -> Bool
    ) async rethrows -> [Element] {
        var tasks = [Task<(Element, Bool), any Error>]()
        for element in self {
            tasks.append(Task<(Element, Bool), any Error>(priority: priority) {
                (element, try await predicate(element))
            })
        }
        
        var arr = [Element]()
        for task in tasks {
            let (element, result) = try await { try await task.value }()
            if result {
                arr.append(element)
            }
        }
        
        return arr
    }
}
