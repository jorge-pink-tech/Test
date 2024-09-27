//
//  FieldKey+ExtensionsTests.swift
//  
//  Created by PinkTech on 8/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import Fluent
import Utility
import XCTest

@testable import Extensions

enum TestEnum: String {
    case cases = "value"
}

final class FieldKey_ExtensionsTests: XCTestCase {

    // MARK: Tests

    func testExample() throws {
        // Given
        let sut = FieldKey.string(TestEnum.cases)

        // When, Then
        XCTAssertEqual(sut, "value")
    }
}
