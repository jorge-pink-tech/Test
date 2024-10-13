//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class ConfirmForgotPasswordParametersTests: XCTestCase {

    // MARK: Tests

    func testThatValidateConfirmationCodeOnConfirmForgotPasswordParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "newPassword": "DarienCharris27!",
            "email": "darychm@gmail.com",
            "confirmPassword": "DarienCharris27!",
            "confirmationCode": ""
        }
        """

        // When
        do {
            _ = try ConfirmForgotPasswordParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El código de confirmación no puede estar vacío.")
        XCTAssertEqual(validationError!.failures.first?.key, "confirmationCode")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateConfirmPasswordOnConfirmForgotPasswordParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "newPassword": "DarienCharris27!",
            "email": "darychm@gmail.com",
            "confirmPassword": "",
            "confirmationCode": "123123"
        }
        """

        // When
        do {
            _ = try ConfirmForgotPasswordParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "La contraseña no cumple con los criterios requeridos.")
        XCTAssertEqual(validationError!.failures.first?.key, "confirmPassword")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidatePasswordOnConfirmForgotPasswordParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "newPassword": "",
            "email": "darychm@gmail.com",
            "confirmPassword": "DarienCharris27!",
            "confirmationCode": "123123"
        }
        """

        // When
        do {
            _ = try ConfirmForgotPasswordParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "La contraseña no cumple con los criterios requeridos.")
        XCTAssertEqual(validationError!.failures.first?.key, "newPassword")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateEmailOnConfirmForgotPasswordParameters() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "newPassword": "DarienCharris27!",
            "email": "",
            "confirmPassword": "DarienCharris27!",
            "confirmationCode": "123123"
        }
        """

        // When
        do {
            _ = try ConfirmForgotPasswordParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "Email invalido.")
        XCTAssertEqual(validationError!.failures.first?.key, "email")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }
}
