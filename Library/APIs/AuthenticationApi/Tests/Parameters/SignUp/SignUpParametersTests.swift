//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class SignUpParametersTests: XCTestCase {

    // MARK: Tests

    func testThatValidatePasswordIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "CO",
            "email": "email@pink-tech.io",
            "firstName": "pink",
            "lastName": "tech",
            "password": "Pinktech",
            "phone": "+57313333333"
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "La contraseña no cumple con los criterios requeridos.")
        XCTAssertEqual(validationError!.failures.first?.key, "password")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidatePhoneIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "CO",
            "email": "email@pink-tech.io",
            "firstName": "pink",
            "lastName": "tech",
            "password": "Pinktech27!",
            "phone": ""
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El número de teléfono no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "phone")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateFirstNameIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "CO",
            "email": "email@pink-tech.io",
            "firstName": "",
            "lastName": "tech",
            "password": "Pinktech27!",
            "phone": "PinkTech1!"
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El nombre no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "firstName")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateLastNameIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "CO",
            "email": "email@pink-tech.io",
            "firstName": "Pink",
            "lastName": "",
            "password": "Pinktech27!",
            "phone": "PinkTech1!"
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El apellido no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "lastName")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateCountryCodeIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "",
            "email": "email@pink-tech.io",
            "firstName": "Pink",
            "lastName": "Tech",
            "password": "Pinktech27!",
            "phone": "PinkTech1!"
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El codigo del pais no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.first?.key, "countryCode")
        XCTAssertTrue(validationError!.failures.first!.result.isFailure)
    }

    func testThatValidateAllSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "",
            "email": "email@pink-tech.io",
            "firstName": "",
            "lastName": "",
            "password": "Pinktech27!",
            "phone": ""
        }
        """

        // When
        do {
            _ = try SignUpParameters.validate(json: json)
        } catch {
            validationError = error as? ValidationsError
        }

        // Then
        XCTAssertEqual(validationError.status, .badRequest)
        XCTAssertEqual(validationError.description, "El codigo del pais no puede estar vacio., El nombre no puede estar vacio., El apellido no puede estar vacio., El número de teléfono no puede estar vacio.")
        XCTAssertEqual(validationError!.failures.count, 4)
    }
}
