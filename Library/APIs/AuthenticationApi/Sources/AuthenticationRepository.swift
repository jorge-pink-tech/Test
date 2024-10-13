//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Cognito
import Extensions
import Fluent
import UserDatabase
import Utility
import Vapor

/// A repository that handle the authentication of the users.
public protocol AuthenticationRepository {
    /// Confirms a forgotten password with the provided parameters.
    ///
    /// - Parameter parameters: The parameters required to confirm the forgotten password.
    /// - Throws: A `KountyAbortError` if someting fails.
    func confirmForgotPassword(_ parameters: ConfirmForgotPasswordParameters) async throws

    /// Confirms the  user's registration with the provided parameters.
    ///
    /// - Parameter parameters: The parameters required to confirm the sign up.
    /// - Throws: A `KountyAbortError` if someting fails.
    func confirmSignUp(_ parameters: ConfirmSignUpParameters) async throws
    
    /// Decodes the access token if not expired.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Returns: The payload of the access token.
    /// - Throws. A `KountyAbortError` If an error occurs during the verification process.
    func decode(_ accessToken: String) async throws -> AccessTokenPayload

    /// Send a verification code to recover the password of the user associated
    /// to the given username.
    ///
    /// - Parameter email: The username of the user to recover the password.
    /// - Throws: A `KountyAbortError` if someting fails.
    func forgotPassword(email: String) async throws

    /// Sign in the current user.
    ///
    /// - Parameter parameters: The struct containing the user's credential.
    /// - Returns: The authentication token.
    /// - Throws: A `KountyAbortError` if someting fails.
    func signIn(_ parameters: SignInParameters) async throws -> AuthToken
    
    /// Signs up the user.
    ///
    /// - Parameter parameters: The struct containing the user information.
    /// - Returns: The registered user.
    /// - Throws: A `KountyAbortError` if someting fails.
    func signUp(_ parameters: SignUpParameters) async throws
}

/// A concrete implementation of the `AuthenticationRepository`.
public class AuthenticationRepositoryImpl: AuthenticationRepository {
    // MARK: - Private Properties
        
    private let cognitoAuthenticatableClient: CognitoAuthenticatableClient
    private let userDatabase: Database
    
    // MARK: Initializer
    
    /// Creates a new instance of the `AuthenticationRepositoryImpl`.
    ///
    /// - Parameters:
    ///    - cognitoAuthenticatableClient: A type that  defines the user authentication with Amazon Cognito.
    ///    - userDatabase: A object that defines the contract for the user database.
    public init(cognitoAuthenticatableClient: CognitoAuthenticatableClient, userDatabase: Database) {
        self.cognitoAuthenticatableClient = cognitoAuthenticatableClient
        self.userDatabase = userDatabase
    }
    
    // MARK: AuthenticationRepository

    /// Confirms a forgotten password with the provided parameters.
    ///
    /// - Parameter parameters: The parameters required to confirm the forgotten password.
    /// - Throws: A `KountyAbortError` if someting fails.
    public func confirmForgotPassword(_ parameters: ConfirmForgotPasswordParameters) async throws {
        guard parameters.newPassword == parameters.confirmPassword else {
            throw .abort(.badRequest, reason: "Las contraseñas no coinciden.")
        }
        
        do {
            try await cognitoAuthenticatableClient.confirmForgotPassword(
                username: parameters.email,
                newPassword: parameters.newPassword,
                confirmationCode: parameters.confirmationCode
            )
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Confirms the  user's registration with the provided parameters.
    ///
    /// - Parameter parameters: The parameters required to confirm the sign up.
    /// - Throws: A `KountyAbortError` if someting fails.
    public func confirmSignUp(_ parameters: ConfirmSignUpParameters) async throws {
        do {
            try await cognitoAuthenticatableClient.confirmSignUp(
                username: parameters.email,
                confirmationCode: parameters.confirmationCode
            )
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Decodes the access token if not expired.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Returns: The payload of the access token.
    /// - Throws. A `KountyAbortError` If an error occurs during the verification process.
    public func decode(_ accessToken: String) async throws -> AccessTokenPayload {
        do {
            let accessTokenPayload = try await cognitoAuthenticatableClient.decode(accessToken)
            
            return .init(expiresIn: accessTokenPayload.exp, username: accessTokenPayload.email)
        } catch {
            throw error.toAbortError()
        }
    }

    /// Send a verification code to recover the password of the user associated
    /// to the given username.
    ///
    /// - Parameter email: The username of the user to recover the password.
    /// - Throws: A `KountyAbortError` if someting fails.
    public func forgotPassword(email: String) async throws {
        do {
            try await cognitoAuthenticatableClient.forgotPassword(username: email)
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Sign in the current user.
    ///
    /// - Parameter parameters: The struct containing the user's credential.
    /// - Returns: The authentication token.
    /// - Throws: A `KountyAbortError` if someting fails.
    public func signIn(_ parameters: SignInParameters) async throws -> AuthToken {
        do {
            let credential = UsernameAndPasswordCredential(username: parameters.email, password: parameters.password)
            let cognitoToken = try await cognitoAuthenticatableClient.signIn(credential)
            
            _ = try await UserDTO.query(on: userDatabase)
                .filter(\.$email == parameters.email)
                .first()
                .unwrap(or: .abort(.notFound, reason: "El usuario no se encuentra registrado."))

            return .init(
                accessToken: cognitoToken.accessToken,
                expiresIn: cognitoToken.expiresIn,
                idToken: cognitoToken.idToken,
                refreshToken: cognitoToken.refreshToken
            )
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Signs up the user.
    ///
    /// - Parameter parameters: The struct containing the user information.
    /// - Returns: The registered user.
    /// - Throws: A `KountyAbortError` if someting fails.
    public func signUp(_ parameters: SignUpParameters) async throws {
        do {
            let user = UserDTO(
                countryCode: parameters.countryCode,
                email: parameters.email,
                firstName: parameters.firstName,
                lastName: parameters.lastName,
                phone: parameters.phone
            )

            try await cognitoAuthenticatableClient.signUp(
                username: parameters.email,
                password: parameters.password,
                firstName: parameters.firstName,
                lastName: parameters.lastName
            )

            try await user.save(on: userDatabase)
        } catch {
            throw error.toAbortError()
        }
    }
}

private extension ErrorReason {
    /// Returns the HTTP status code associated with the error reason.
    var statusCode: HTTPResponseStatus {
        switch self {
        case .CognitoErrorReason.invalidConfirmationCode,
             .CognitoErrorReason.confirmSignUpFailed,
             .CognitoErrorReason.expiredConfirmationCode,
             .CognitoErrorReason.invalidPassword,
             .CognitoErrorReason.userNotConfirmed:

            return .badRequest
            
        case .CognitoErrorReason.unauthorized:
            return .unauthorized

        default:
            return .internalServerError
        }
    }
}

private extension Error {
    /// Casts the instance as `KountyAbortError` or returns a default one.
    func toAbortError() -> KountyAbortError {
        guard let error = self as? KountyError else {
            return asAbortError()
        }
        
        return error.asAbortError(error.kind.statusCode)
    }
}
