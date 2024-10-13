//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility
import XCTest

@testable import Extensions

enum TestEnum: String {
    case cases = "value"
}

final class FieldKeyExtensionsTests: XCTestCase {

    // MARK: Tests

    func testThatValidateStringValueFromEnum() throws {
        // Given
        let sut = FieldKey.string(TestEnum.cases)

        // When, Then
        XCTAssertEqual(sut, "value")
    }
}
