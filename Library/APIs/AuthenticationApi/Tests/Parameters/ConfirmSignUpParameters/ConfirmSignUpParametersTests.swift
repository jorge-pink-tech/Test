//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class ConfirmSignUpParametersTests: XCTestCase {

    // MARK: Tests

    func testThatValidateEmailOnConfirmSignUpParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "email": "",
            "confirmationCode": "ConfirmSignUp"
        }
        """

        // When
        do {
            _ = try ConfirmSignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El email no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "email")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateCodeOnConfirmSignUpParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "email": "test@gmail.com",
            "confirmationCode": ""
        }
        """

        // When
        do {
            _ = try ConfirmSignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El codigo de confirmación no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "confirmationCode")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }
}
