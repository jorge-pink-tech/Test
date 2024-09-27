//
//  SignUpParametersTests.swift
//
//  Created by PinkTech on 5/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import Utility
import Vapor
import XCTest

@testable import AuthenticationApi

final class SignUpParametersTests: XCTestCase {

    // MARK: Tests
    
    func testThatValidatePhoneIntoSignUpParametersShouldFail() throws {
        // Given
        var validationError: ValidationsError!
        let json = """
        {
            "countryCode": "CO",
            "email": "email@pink-tech.io",
            "firstName": "pink",
            "lastName": "tech",
            "password": "Pinktech!",
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
            "password": "Pinktech!",
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
            "password": "Pinktech!",
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
            "password": "Pinktech!",
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
            "password": "Pinktech!",
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
