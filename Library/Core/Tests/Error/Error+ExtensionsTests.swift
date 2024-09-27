//
//  Error+ExtensionsTests.swift
//
//  Created by PinkTech on 8/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import XCTest
import Utility

@testable import Extensions

/// All the error reasons that can be thrown by the `AuthenticationRepository`.
public enum TestErrorReason: ErrorReason {
    /// user has not been found.
    case userNotFound
}

final class ErrorExtensionsTests: XCTestCase {

    // MARK: Tests

    func testThatKountyAbortErrorAsAbortError() throws {
        // Given
        var error = KountyAbortError(
            reason: "any error",
            status: .badRequest,
            underlyingErrors: [
                NSError(domain: "", code: 0)
            ]
        )

        // When
        error = error.asAbortError()

        // Then
        XCTAssertEqual(error.status, .badRequest)
    }

    func testThatNSErrorAsAbortError() throws {
        // Given
        let error = NSError(domain: "", code: 0)

        // When
        let abortError = error.asAbortError()

        // Then
        XCTAssertEqual(abortError.status, .internalServerError)
    }

    func testThatKountyErrorAsKountyError() throws {
        // Given
        var error = KountyError(kind: TestErrorReason.userNotFound)

        // When
        error = error.asKountyError(or: TestErrorReason.userNotFound)

        // Then
        XCTAssertTrue(error.kind as? TestErrorReason == TestErrorReason.userNotFound)
    }

    func testThatKNSErrorAsKountyError() throws {
        // Given
        let error = NSError(domain: "", code: 0)

        // When
        let kountyError = error.asKountyError(or: TestErrorReason.userNotFound)

        // Then
        XCTAssertTrue(kountyError.kind as? TestErrorReason == TestErrorReason.userNotFound)
    }
}
