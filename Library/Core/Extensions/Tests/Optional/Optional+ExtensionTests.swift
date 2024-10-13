//
// Copyright © 2024 PinkTech. All rights reserved.
//

import XCTest
import Utility

@testable import Extensions

final class OptionalExtensionTests: XCTestCase {

    // MARK: Tests

    func testThatUnwrapThrownAnErrorWhenValueIsNill() throws {
        // Given
        var optionalError: Error?
        var optional: String?

        // When
        do {
            _ = try optional.unwrap(or: NSError(domain: "", code: 0))
        } catch let error {
            optionalError = error
        }
        
        // Then
        XCTAssertNotNil(optionalError)
    }

    func testThatUnwrapReturnAValue() throws {
        // Given
        var optionalError: Error?
        let optional: String? = "Value"

        // When
        do {
            _ = try optional.unwrap(or: NSError(domain: "", code: 0))
        } catch let error {
            optionalError = error
        }
        
        // Then
        XCTAssertNil(optionalError)
        XCTAssertEqual(optional, "Value")
    }
}
