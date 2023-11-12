//
//  CheckedContinuation+.swift
//  
//
//  Created by Ji-Hwan Kim on 11/9/23.
//

import Foundation

extension CheckedContinuation {
    public func asCompletionHandler() -> (T?, E?) -> Void {
        { result, error in
            if let result = result {
                resume(returning: result)
            }
            if let error = error {
                resume(throwing: error)
            }
        }
    }
}
