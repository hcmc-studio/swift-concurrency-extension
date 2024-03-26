//
//  Sequence+.swift
//
//
//  Created by Ji-Hwan Kim on 10/16/23.
//

import Foundation
import Algorithms

extension Sequence {
    public func forEachParallel(
        action: @escaping (Element) async throws -> Void
    ) async rethrows {
        _ = try await mapParallel(transform: action)
    }
    
    public func mapParallel<Result>(
        transform: @escaping (Element) async throws -> Result
    ) async rethrows -> [Result] {
        try await withThrowingTaskGroup(of: Result.self) { group in
            for element in self {
                group.addTask { try await transform(element) }
            }
            
            var result = [Result]()
            while let element = try await group.next() {
                result.append(element)
            }
            
            return result
        }
    }
    
    public func mapNotNilParallel<Result>(
        transform: @escaping (Element) async throws -> Result?
    ) async rethrows -> [Result] {
        try await withThrowingTaskGroup(of: Result?.self) { group in
            for element in self {
                group.addTask { try await transform(element) }
            }
            
            var result = [Result]()
            while let element = try await group.next() {
                if let element = element {
                    result.append(element)
                }
            }
            
            return result
        }
    }
    
    public func filterParallel(
        predicate: @escaping (Element) async throws -> Bool
    ) async rethrows -> [Element] {
        try await mapNotNilParallel { element in
            if try await predicate(element) {
                return element
            } else {
                return nil
            }
        }
    }
}
