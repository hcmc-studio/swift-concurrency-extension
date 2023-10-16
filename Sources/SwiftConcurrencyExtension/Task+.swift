//
//  Task+.swift
//
//
//  Created by Ji-Hwan Kim on 10/16/23.
//

import Foundation

extension Task {
    @discardableResult
    public static func execute(
        priority: TaskPriority? = nil,
        withoutResult fetch: @escaping () async throws -> Void,
        onReady: @escaping ((any Error)?) -> Void
    ) -> Task<Void, any Error> {
        Task<Void, any Error>(priority: priority) {
            try await operation(fetch: fetch, onReady: { result in
                switch result {
                case .success(): onReady(nil)
                case .failure(let error): onReady(error)
                }
            })
        }
    }
    
    @discardableResult
    public static func execute(
        priority: TaskPriority? = nil,
        withoutResult fetch: @escaping () async throws -> Void,
        onSuccess: @escaping () -> Void,
        onFailure: @escaping (any Error) -> Void
    ) -> Task<Void, any Error> {
        Task<Void, any Error>(priority: priority) {
            try await operation(fetch: fetch, onReady: { result in
                switch result {
                case .success(): onSuccess()
                case .failure(let error): onFailure(error)
                }
            })
        }
    }
    
    @discardableResult
    public static func execute<FetchResult: Sendable>(
        priority: TaskPriority? = nil,
        withResult fetch: @escaping () async throws -> FetchResult,
        onReady: @escaping (Result<FetchResult, Error>) -> Void
    ) -> Task<FetchResult, any Error> {
        Task<FetchResult, any Error>(priority: priority) {
            try await operation(fetch: fetch, onReady: onReady)
        }
    }
    
    @discardableResult
    public static func execute<FetchResult: Sendable>(
        priority: TaskPriority? = nil,
        withResult fetch: @escaping () async throws -> FetchResult,
        onSuccess: @escaping (FetchResult) -> Void,
        onFailure: @escaping (any Error) -> Void
    ) -> Task<FetchResult, any Error> {
        Task<FetchResult, any Error>(priority: priority) {
            try await operation(fetch: fetch, onReady: { result in
                switch result {
                case .success(let result): onSuccess(result)
                case .failure(let error): onFailure(error)
                }
            })
        }
    }
    
    private static func operation<FetchResult: Sendable>(
        priority: TaskPriority? = nil,
        fetch: () async throws -> FetchResult,
        onReady: (Result<FetchResult, Error>) -> Void
    ) async rethrows -> FetchResult {
        do {
            let fetchResult = try await fetch()
            await MainActor.run { onReady(.success(fetchResult)) }
            
            return fetchResult
        } catch let error {
            await MainActor.run { onReady(.failure(error)) }
            
            throw error
        }
    }
}
