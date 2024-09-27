//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation
import Vapor

extension Optional {
    /// Unwraps the optional value or throws an error if the `WrappedType` is nil.
    ///
    /// - Parameter defaultValue: A closure to use as a fallback value.
    /// - Returns: The `WrappedType`.
    public func unwrap(or error: @autoclosure () -> Error) throws -> Self.WrappedType {
        switch self {
        case .none:
            throw error()
            
        case .some(let wrapped):
            return wrapped
        }
    }
}
