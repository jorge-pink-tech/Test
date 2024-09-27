//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// Protocol for establishing reasons with the domain of Errors.
public protocol ErrorReason: Equatable {}

/// A wrapper that contains an error reason as well as an underlying error.
public struct KountyError: LocalizedError {
    /// The affected column line in the source code.
    public let column: Int
    
    /// A localized message describing the reason for the failure.
    public let failureReason: String?

    /// The affected line in the source code.
    public let line: Int

    /// The reason the error was triggered.
    public let kind: any ErrorReason

    /// The underliying error.
    public let underlyingError: Error?

    /// A localized message describing what error occurred.
    public var errorDescription: String? {
        failureReason ?? underlyingError?.localizedDescription
    }

    // MARK: Initializer

    /// Creates a new instance of the `KountyError` with the given
    /// underliying error type.
    ///
    /// - Parameters:
    ///   - kind: The type of error.
    ///   - column: The affected column line in the source code.
    ///   - failureReason: A localized message describing the reason for the failure.
    ///   - line: The affected line in the source code.
    ///   - underlyingError: The underliying error.
    public init(
        kind: any ErrorReason,
        failureReason: String? = nil,
        underlyingError: Error? = nil,
        column: Int = #column,
        line: Int = #line
    ) {

        self.column = column
        self.failureReason = failureReason
        self.kind = kind
        self.line = line
        self.underlyingError = underlyingError
    }
}

/// A wrapper that contains an error.
public struct KountyAbortError: AbortError {
    /// The reason for this error.
    public let reason: String

    /// The HTTP status code this error will return.
    public let status: HTTPResponseStatus
    
    /// A short description for this error.
    public let title: String?
    
    /// The underliying error.
    public let underlyingErrors: [Error]
    
    /// Retrieve the localized description for this error.
    public var localizedDescription: String {
        reason
    }
    
    /// Allowable fields for the model.
    public enum CodingKeys: String, CodingKey {
        case reason
        case status
        case title
    }

    // MARK: Initializer

    /// Creates a new instance of the `KountyAbortError` with the given
    /// underliying error type.
    ///
    /// - Parameters:
    ///   - reason: The reason of this error.
    ///   - status: The HTTP status code this error will return.
    ///   - underlyingErrors: The underliying errors.
    ///   - title: A short description for this error.
    public init(reason: String, status: HTTPResponseStatus, underlyingErrors: [Error] = [], title: String? = nil) {
        self.reason = reason
        self.status = status
        self.title = title
        self.underlyingErrors = underlyingErrors
    }
}
