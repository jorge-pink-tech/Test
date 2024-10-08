//
// Copyright © 2024 PinkTech. All rights reserved.
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

    func testThatKountyErrorAsAbortError() throws {
        // Given
        let error = KountyError(kind: TestErrorReason.userNotFound)

        // When
        let kountyAbortError = error.asAbortError(.badGateway, failureReason: "Error")

        // Then
        XCTAssertEqual(kountyAbortError.status, .badGateway)
        XCTAssertEqual(kountyAbortError.reason, "Error")
    }

    func testThatKountyErrorAsAbortErrorOnNilFailureReason() throws {
        // Given
        let error = KountyError(kind: TestErrorReason.userNotFound)

        // When
        let kountyAbortError = error.asAbortError(.badGateway)

        // Then
        XCTAssertEqual(kountyAbortError.status, .badGateway)
        XCTAssertFalse(kountyAbortError.reason.isEmpty)
    }

    func testThatKountyAbortErrorAsAbort() throws {
        // Given
        let error = KountyAbortError.abort(.conflict, reason: "Error", underlyingError: NSError(domain: "", code: 0))

        // Then, When
        XCTAssertEqual(error.status, .conflict)
        XCTAssertEqual(error.reason, "Error")
        XCTAssertNotNil(error.underlyingErrors)
        XCTAssertFalse(error.localizedDescription.isEmpty)
    }

    func testThatKountyAbortErrorAsAbortOnDifferentsUnderlyingErrors() throws {
        // Given
        let error = KountyAbortError.abort(.conflict, reason: "Error", underlyingErrors: [NSError(domain: "", code: 0)])

        // Then, When
        XCTAssertEqual(error.status, .conflict)
        XCTAssertEqual(error.reason, "Error")
        XCTAssertNotNil(error.underlyingErrors)
    }

    func testThatKountyAbortErrorAsAbortError1() throws {
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
        XCTAssertNotNil(kountyError.errorDescription)
    }
}
