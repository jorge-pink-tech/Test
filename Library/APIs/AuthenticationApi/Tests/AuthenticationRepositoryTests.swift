//
//  AuthenticationRepositoryTests.swift
//
//  Created by PinkTech on 3/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import Cognito
import CognitoTesting
import Extensions
import Fluent
import Utility
import UserDatabase
import UserDatabaseTesting
import XCTest
import XCTVapor

@testable import AuthenticationApi

public enum TestErrorReason: ErrorReason {
    case test
}

final class AuthenticationRepositoryTests: XCTestCase {
    private var cognitoClient: CognitoAuthenticatableClientMock!
    var app: Application!
    private var userDatabase: Database!
    
    /// Error that can be thrown in the test.
    enum AuthenticationError: LocalizedError {
        case error(reason: String)
        
        /// A localized message describing what error occurred.
        var errorDescription: String? {
            switch self {
            case .error(let reason):
                return reason
            }
        }
    }
    
    // MARK: Overriden methods
    
    override func setUpWithError() throws {
        cognitoClient = CognitoAuthenticatableClientMock()
        app = Application(.testing)
        userDatabase = try app.testableUserDatabase()
        
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        cognitoClient = nil
        userDatabase = nil

        app.shutdown()
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    
    func testThatConfirmForgotPasswordShouldPassCorrectParameters() async throws {
        // Given
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        try await sut.confirmForgotPassword(
            ConfirmForgotPasswordParameters(
                confirmationCode: "confirmationCode",
                confirmPassword: "newPassword",
                email: "example@email.com",
                newPassword: "newPassword"
            )
        )
        
        // Then
        XCTAssertEqual(cognitoClient.username, "example@email.com")
        XCTAssertEqual(cognitoClient.newPassword, "newPassword")
        XCTAssertEqual(cognitoClient.confirmationCode, "confirmationCode")
    }
    
    func testThatConfirmForgotPasswordShouldFailOnInvalidPassword() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.invalidPassword,
            underlyingError: AuthenticationError.error(reason: "Test")
        )
        
        do {
            try await sut.confirmForgotPassword(
                ConfirmForgotPasswordParameters(
                    confirmationCode: "confirmationCode",
                    confirmPassword: "newPassword",
                    email: "example@email.com",
                    newPassword: "newPassword"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(error.status, .badRequest)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatConfirmForgotPasswordShouldFailOnInvalidConfirmationCode() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.invalidConfirmationCode,
            underlyingError: AuthenticationError.error(reason: "Test")
        )
        
        do {
            try await sut.confirmForgotPassword(
                ConfirmForgotPasswordParameters(
                    confirmationCode: "confirmationCode",
                    confirmPassword: "newPassword",
                    email: "example@email.com",
                    newPassword: "newPassword"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(error.status, .badRequest)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatConfirmForgotPasswordShouldFailOnErrorKindDifferentToCognitoErrorReasonType() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: TestErrorReason.test,
            underlyingError: AuthenticationError.error(reason: "Test")
        )
        
        do {
            try await sut.confirmForgotPassword(
                ConfirmForgotPasswordParameters(
                    confirmationCode: "confirmationCode",
                    confirmPassword: "newPassword",
                    email: "example@email.com",
                    newPassword: "newPassword"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatConfirmForgotPasswordShouldFailOnAnyError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = NSError(domain: "", code: 0)
        
        do {
            try await sut.confirmForgotPassword(
                ConfirmForgotPasswordParameters(
                    confirmationCode: "confirmationCode",
                    confirmPassword: "newPassword",
                    email: "example@email.com",
                    newPassword: "newPassword"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "The operation couldn’t be completed. ( error 0.)")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }
    
    func testThatConfirmSignUpShouldPassCorrectParameters() async throws {
        // Given
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        try await sut.confirmSignUp(
            ConfirmSignUpParameters(
                confirmationCode: "confirmationCode",
                email: "email"
            )
        )
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.confirmationCode, "confirmationCode")        
    }

    func testThatConfirmSignUpShouldFailOnExpiredConfirmationCode() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.expiredConfirmationCode,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.confirmSignUp(
                ConfirmSignUpParameters(
                    confirmationCode: "confirmationCode",
                    email: "email"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.confirmationCode, "confirmationCode")
        XCTAssertEqual(error.status, .badRequest)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatConfirmSignUpShouldFailOnErrorKindDifferentToCognitoErrorReasonType() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: TestErrorReason.test,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.confirmSignUp(
                ConfirmSignUpParameters(
                    confirmationCode: "confirmationCode",
                    email: "email"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.confirmationCode, "confirmationCode")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatConfirmSignUpShouldFailOnAnyError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = NSError(domain: "", code: 0)
        do {
            try await sut.confirmSignUp(
                ConfirmSignUpParameters(
                    confirmationCode: "confirmationCode",
                    email: "email"
                )
            )
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.confirmationCode, "confirmationCode")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "The operation couldn’t be completed. ( error 0.)")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }
    
    func testThatForgotPasswordShouldPassCorrectParameters() async throws {
        // Given
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        try await sut.forgotPassword(email: "email")
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
    }

    func testThatForgotPasswordShouldFailOnUserNotConfirmed() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.userNotConfirmed,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.forgotPassword(email: "email")
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(error.status, .badRequest)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatForgotPasswordShouldFailOnErrorKindDifferentToCognitoErrorReasonType() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: TestErrorReason.test,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.forgotPassword(email: "email")
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatForgotPasswordShouldFailOnAnyError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = NSError(domain: "", code: 0)
        do {
            try await sut.forgotPassword(email: "email")
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "The operation couldn’t be completed. ( error 0.)")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }
    
    func testThatSignInShouldPassCorrectParameters() async throws {
        // Given
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        let user = UserDTO(
            countryCode: "+57",
            email: "email",
            firstName: "firstName",
            lastName: "lastName",
            phone: "phone"
        )
        
        // When
        try await user.save(on: userDatabase)
        
        let session = try await sut.signIn(SignInParameters(email: "email", password: "password"))
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(session.accessToken, cognitoClient.cognitoToken.accessToken)
        XCTAssertEqual(session.idToken, cognitoClient.cognitoToken.idToken)
        XCTAssertEqual(session.refreshToken, cognitoClient.cognitoToken.refreshToken)
    }

    func testThatSignInShouldFailOnUserNotFound() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        do {
            _ = try await sut.signIn(SignInParameters(email: "email", password: "password"))
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .notFound)
        XCTAssertNil(error.title)
        XCTAssertNotNil(error.underlyingErrors)
    }

    func testThatSignInShouldFailOnInvalidPassword() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.invalidPassword,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            _ = try await sut.signIn(SignInParameters(email: "email", password: "password"))
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .badRequest)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatSignInShouldFailOnErrorKindDifferentToCognitoErrorReasonType() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: TestErrorReason.test,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            _ = try await sut.signIn(SignInParameters(email: "email", password: "password"))
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatSignInShouldFailOnAnyError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        // When
        cognitoClient.error = NSError(domain: "", code: 0)

        do {
            _ = try await sut.signIn(SignInParameters(email: "email", password: "password"))
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "The operation couldn’t be completed. ( error 0.)")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }
    
    func testThatSignUpShouldPassCorrectParameters() async throws {
        // Given
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        let parameters = SignUpParameters(
            countryCode: "+57",
            email: "email",
            firstName: "firstName",
            lastName: "lastName",
            password: "password",
            phone: "phone"
        )
        
        // When
        try await sut.signUp(parameters)
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
//        XCTAssertEqual(userDatabase.user.email, parameters.email)
//        XCTAssertEqual(userDatabase.user.firstName, parameters.firstName)
//        XCTAssertEqual(userDatabase.user.lastName, parameters.lastName)
//        XCTAssertEqual(userDatabase.user.phone, parameters.phone)
    }

    func testThatSignUpShouldFailOnCognitoError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        let parameters = SignUpParameters(
            countryCode: "+57",
            email: "email",
            firstName: "firstName",
            lastName: "lastName",
            password: "password",
            phone: "phone"
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: CognitoErrorReason.signupFailed,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.signUp(parameters)
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatSignUpShouldFailOnErrorKindDifferentToCognitoErrorReasonType() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        let parameters = SignUpParameters(
            countryCode: "+57",
            email: "email",
            firstName: "firstName",
            lastName: "lastName",
            password: "password",
            phone: "phone"
        )
        
        // When
        cognitoClient.error = KountyError(
            kind: TestErrorReason.test,
            underlyingError: AuthenticationError.error(reason: "Test")
        )

        do {
            try await sut.signUp(parameters)
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "Test")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }

    func testThatSignUpShouldFailOnAnyError() async throws {
        // Given
        var error: KountyAbortError!
        let sut = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )
        
        let parameters = SignUpParameters(
            countryCode: "+57",
            email: "email",
            firstName: "firstName",
            lastName: "lastName",
            password: "password",
            phone: "phone"
        )
        
        // When
        cognitoClient.error = NSError(domain: "", code: 0)
        do {
            try await sut.signUp(parameters)
        } catch let abortError as KountyAbortError {
            error = abortError
        }
        
        // Then
        XCTAssertEqual(cognitoClient.username, "email")
        XCTAssertEqual(cognitoClient.password, "password")
        XCTAssertEqual(error.status, .internalServerError)
        XCTAssertEqual(error.reason, "The operation couldn’t be completed. ( error 0.)")
        XCTAssertNil(error.title)
        XCTAssertFalse(error.underlyingErrors.isEmpty)
    }
}
