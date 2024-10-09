//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class SignInParametersTests: XCTestCase {

    // MARK: Tests

    func testThatValidatePasswordSignInParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "email": "email@pink-tech.io",
            "password": "",
        }
        """

        // When
        do {
            _ = try SignInParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "La contraseña no puede estar vacia.")
        XCTAssertEqual(validationError!.failures.first?.key, "password")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateEmailSignInParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "email": "",
            "password": "Password123!",
        }
        """

        // When
        do {
            _ = try SignInParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El email no es valido.")
        XCTAssertEqual(validationError!.failures.first?.key, "email")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }
}
