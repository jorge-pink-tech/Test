//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Extensions
import Foundation
import SotoCognitoAuthenticationKit
import SotoCognitoIdentityProvider
import Utility

/// All AWS server regions
public typealias AWSRegion = SotoCognitoIdentityProvider.Region

/// Represents the user credentials within an authentication system.
public protocol Credential {}

/// A struct representing a user credential with a username and password. It conforms to the `Credential` protocol.
public struct UsernameAndPasswordCredential: Credential {
    /// The password associated to this credential.
    public let password: String
    
    /// The username associated to this credential.
    public let username: String
    
    // MARK: Initializers
    
    /// Creates a new instance of the `UsernameAndPasswordCredential`.
    ///
    /// - Parameters:
    ///   - username: The username associated to this credential.
    ///   - password: The password associated to this credential.
    public init(username: String, password: String) {
        self.password = password
        self.username = username
    }
}

/// A protocol that defines the user authentication with Amazon Cognito.
public protocol CognitoAuthenticatableClient {
    /// Confirms a forgotten password using the provided username, new password, and confirmation code.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - newPassword: The new password.
    ///    - verificationCode: The verification code sent by amazon cognito.
    /// - Throws: A `KountyError` if the authentication client fails.
    func confirmForgotPassword(username: String, newPassword: String, confirmationCode: String) async throws

    /// Confirms the registration of the user associated to the given username.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - confirmationCode:The confirmation code in email.
    /// - Throws: A `KountyError` if the authentication client fails.
    func confirmSignUp(username: String, confirmationCode: String) async throws
    
    /// Decodes the access token if not expired.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Returns: The payload of the access token.
    /// - Throws. A `KountyError` If an error occurs during the verification process.
    func decode(_ accessToken: String) async throws -> CognitoTokenPayload

    /// Send a verification code to recover the password of the user associated 
    /// to the given username.
    ///
    /// - Parameter username: The username of the user being confirmed.
    /// - Throws: A `KountyError` if the authentication client fails.
    func forgotPassword(username: String) async throws
    
    /// Sign in the current user.
    ///
    /// - Parameter credential: The user credential.
    /// - Returns: The `CognitoToken` if any.
    /// - Throws: A `KountyError` if the authentication client fails.
    func signIn(_ credential: Credential) async throws -> CognitoToken
    
    /// Signs up the user.
    ///
    /// - Parameters:
    ///    - username: The username of the user that is being authenticated.
    ///    - password: The password of the user that is being authenticated.
    ///    - firstName: The first name of the user.
    ///    - lastName: The last name of the user.
    /// - Throws: A `KountyError` if the authentication client fails.
    func signUp(username: String, password: String, firstName: String, lastName: String) async throws
}

/// A Client that facilitates user authentication with Amazon Cognito.
/// It provides methods for user  sign-in, sign-out, and token retrieval.
public class CognitoClient: CognitoAuthenticatableClient {
    // MARK: - Private Properties
    
    private let cognitoAuthenticatable: CognitoAuthenticatable
    
    // MARK: - Types
    
    /// All the errors that can be thrown by the `CognitoClient`
    public enum CognitoClientError: Error {
        /// Unknown error
        case unknown
    }
    
    // MARK: Initializers
    
    /// Creates a new instance of the `CognitoClient`.
    ///
    /// - Parameters:
    ///   - clientId: The aws client id.
    ///   - clientSecret: The aws client secret.
    ///   - poolId: The aws pool id.
    ///   - identityProvider: Object for interacting with AWS CognitoIdentityProvider service.
    init(cognitoAuthenticatable: CognitoAuthenticatable) {
        self.cognitoAuthenticatable = cognitoAuthenticatable
    }
    
    /// Creates a new instance of the `CognitoClient`.
    ///
    /// - Parameters:
    ///   - clientId: The aws client id.
    ///   - clientSecret: The aws client secret.
    ///   - poolId: The aws pool id.
    ///   - region: The aws region to use.
    public init(clientId: String, poolId: String, clientSecret: String? = nil, region: AWSRegion = .useast1) {
        let awsClient = AWSClient(credentialProvider: .empty, httpClientProvider: .createNew)
        let cognitoIdentityProvider = CognitoIdentityProvider(client: awsClient, region: region)
        let configuration = CognitoConfiguration(
            userPoolId: poolId,
            clientId: clientId,
            clientSecret: clientSecret,
            cognitoIDP: cognitoIdentityProvider,
            adminClient: false
        )
        self.cognitoAuthenticatable = CognitoAuthenticatable(configuration: configuration)
    }
    
    deinit {
        cognitoAuthenticatable.configuration.cognitoIDP.client.shutdown { error in
            guard let error = error else { return }
            
            print(error)
        }
    }
    
    // MARK: CognitoAuthenticatableClient

    /// Confirms a forgotten password using the provided username, new password, and confirmation code.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - newPassword: The new password.
    ///    - confirmationCode: The confirmation code sent by amazon cognito.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func confirmForgotPassword(username: String, newPassword: String, confirmationCode: String) async throws {
        do {
            _ = try await cognitoAuthenticatable.confirmForgotPassword(
                username: username,
                newPassword: newPassword,
                confirmationCode: confirmationCode
            )
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }
    
    /// Confirms the registration of the user associated to the given username.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - confirmationCode:The confirmation code in email.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func confirmSignUp(username: String, confirmationCode: String) async throws {
        do {
            _ = try await cognitoAuthenticatable.confirmSignUp(username: username, confirmationCode: confirmationCode)
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }
    
    /// Decodes the access token if not expired.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Returns: The payload of the access token.
    /// - Throws. A `KountyError` If an error occurs during the verification process.
    public func decode(_ accessToken: String) async throws -> CognitoTokenPayload {
        do {
            let payload: CognitoTokenPayload = try await cognitoAuthenticatable.authenticate(
                idToken: accessToken,
                on: cognitoAuthenticatable.configuration.cognitoIDP.eventLoopGroup.next()
            )

            return payload
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }

    /// Send a verification code to recover the password of the user associated
    /// to the given username
    ///
    /// - Parameter username: The username of the user being confirmed.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func forgotPassword(username: String) async throws {
        do {
            _ = try await cognitoAuthenticatable.forgotPassword(username: username)
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }
    
    /// Sign in the current user.
    ///
    /// - Parameter credential: The user credential.
    /// - Returns: The `CognitoToken` if any.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func signIn(_ credential: Credential) async throws -> CognitoToken {
        guard let credential = credential as? UsernameAndPasswordCredential else {
            fatalError("Unsupported credential type \(type(of: credential))")
        }
        
        do {
            let response = try await cognitoAuthenticatable.authenticate(
                username: credential.username,
                password: credential.password
            )

            switch response {
            case let .authenticated(authenticated):
                return try authenticated.toCognitoToken()
                
            default:
                throw CognitoClientError.unknown
            }
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }
    
    /// Signs up the user.
    ///
    /// - Parameters:
    ///    - username: The username of the user that is being authenticated.
    ///    - password: The password of the user that is being authenticated.
    ///    - firstName: The first name of the user.
    ///    - lastName: The last name of the user.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func signUp(username: String, password: String, firstName: String, lastName: String) async throws {
        do {
            _ = try await cognitoAuthenticatable.signUp(
                username: username,
                password: password,
                attributes: [
                    "family_name": lastName,
                    "given_name": firstName
                ]
            )
        } catch {
            throw KountyError(kind: error.cognitoErrorKind, underlyingError: error)
        }
    }
}

private extension CognitoAuthenticateResponse.AuthenticatedResponse {
    /// Transforms the current `AuthenticatedResponse` into a `CognitoToken` instance.
    func toCognitoToken() throws -> CognitoToken {
        guard let accessToken else {
            throw KountyError(kind: .CognitoErrorReason.missingAccessToken)
        }
        
        guard let expiresIn else {
            throw KountyError(kind: .CognitoErrorReason.missingTokenExpirationDate)
        }
        
        guard let idToken else {
            throw KountyError(kind: .CognitoErrorReason.missingAccessToken)
        }
        
        guard let refreshToken else {
            throw KountyError(kind: .CognitoErrorReason.missingRefreshToken)
        }
        
        return CognitoToken(
            accessToken: accessToken,
            expiresIn: expiresIn,
            idToken: idToken,
            refreshToken: refreshToken
        )
    }
}

private extension Error {
    /// The error reason returned by Amazon Cognito.
    var cognitoErrorKind: ErrorReason {
        guard let cognitoError = self as? CognitoIdentityProviderErrorType else {
            return .CognitoErrorReason.signUpFailed
        }
        
        switch cognitoError {
        case .codeMismatchException:
            return .CognitoErrorReason.invalidConfirmationCode

        case .expiredCodeException:
            return .CognitoErrorReason.expiredConfirmationCode

        case .invalidPasswordException:
            return .CognitoErrorReason.invalidPassword

        case .unauthorizedException:
            return .CognitoErrorReason.unauthorized
            
        case .userNotConfirmedException:
            return .CognitoErrorReason.userNotConfirmed

        default:
            return .unknown
        }
    }
}
