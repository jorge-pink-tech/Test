//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import Vapor

extension Error {
    /// Casts the instance as `KountyAbortError` or returns a default one.
    public func asAbortError() -> KountyAbortError {
        self as? KountyAbortError ?? .abort(.internalServerError, reason: localizedDescription, underlyingError: self)
    }
    
    /// Casts the instance as `KountyError` or returns a default one.
    public func asKountyError(or defaultKind: @autoclosure () -> any ErrorReason) -> KountyError {
        self as? KountyError ?? KountyError(kind: defaultKind(), underlyingError: self)
    }
}

extension KountyError {
    /// Casts the instance as `KountyAbortError` or returns a default one.
    ///
    /// - Parameter status: The HTTP response status.
    public func asAbortError(_ status: HTTPResponseStatus, failureReason: String? = nil) -> KountyAbortError {
       .abort(status, reason: localizedDescription, underlyingError: self)
    }
}

extension Error where Self == KountyAbortError {
    /// Creates a new instance of the `KountyAbortError` error.
    ///
    /// - Parameters:
    ///   - status: The HTTP response status.
    ///   - code: The error code.
    ///   - reason: The error reason.
    ///   - underlyingErrors: The underlying errors if any.
    public static func abort(
        _ status: HTTPResponseStatus,
        reason: String,
        underlyingErrors: [Error] = []
    ) -> KountyAbortError {
        
        .init(reason: reason, status: status, underlyingErrors: underlyingErrors)
    }
    
    /// Creates a new instance of the `KountyAbortError` error.
    ///
    /// - Parameters:
    ///   - status: The HTTP response status.
    ///   - code: The error code.
    ///   - reason: The error reason.
    ///   - underlyingError: The underlying error if any.
    public static func abort(_ status: HTTPResponseStatus, reason: String, underlyingError: Error) -> KountyAbortError {
        .init(reason: reason, status: status, underlyingErrors: [underlyingError])
    }
}
