//
//  ForgotPasswordParametersTests.swift
//
//  Created by PinkTech on 8/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class ForgotPasswordParametersTests: XCTestCase {

    // MARK: Tests

    func testThatValidateForgotPasswordParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "email": ""
        }
        """

        // When
        do {
            _ = try ForgotPasswordParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El email no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "email")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }
}
