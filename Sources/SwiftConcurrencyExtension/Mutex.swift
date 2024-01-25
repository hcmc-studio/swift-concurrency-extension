//
//  Mutex.swift
//  Thanks to pookjw from GitHub
//  https://pookjw.github.io/Develop/About_Actor_Concurrency/article.html
//
//  Created by Ji-Hwan Kim on 1/25/24.
//

import Foundation
import Collections

public actor Mutex {
    private typealias Stream = AsyncStream<Void>
    private typealias Key = Int64
    
    private(set) var isLocked: Bool = false
    private var continuations: OrderedDictionary<Key, Stream.Continuation> = [:]
    
    public init() {}
    
    deinit {
        continuations.forEach { (key, stream) in
            stream.finish()
        }
    }
    
    private var stream: AsyncStream<Void> {
        let (stream, continuation) = AsyncStream<Void>.makeStream()
        let key = Key.random(in: Key.min...Key.max)
        continuation.onTermination = { [weak self] _ in
            Task { [weak self] in
                await self?.remove(key: key)
            }
        }
        continuations[key] = continuation
        
        return stream
    }
    
    public func lock() async {
        if isLocked {
            for await _ in stream {
                if !isLocked {
                    break
                }
            }
        }
        
        isLocked = true
    }
    
    public func unlock() async {
        isLocked = false
        continuations.forEach { (key: Key, value: Stream.Continuation) in
            value.yield()
        }
    }
    
    public func withLock<Result>(action: () async throws -> Result) async rethrows -> Result {
        await lock()
        do {
            let result = try await action()
            await unlock()
            
            return result
        }
    }
    
    private func remove(key: Key) {
        continuations.removeValue(forKey: key)
    }
}
