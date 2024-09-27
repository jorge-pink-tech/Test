//
//  CognitoClientMock.swift
//
//  Created by PinkTech on 3/01/24.
//  Copyright © 2023 PinkTech. All rights reserved.
//

import Cognito
import Foundation

public final class CognitoAuthenticatableClientMock: CognitoAuthenticatableClient {
    /// The access token sent.
    public private(set) var accessToken = ""

    /// The cognito access token sent.
    public private(set) var cognitoAccessToken: CognitoTokenPayload?
    
    /// The confirmation cognito code.
    public private(set) var confirmationCode = ""
    
    /// An error to thrown.
    public var error: Error?
    
    /// The user first name.
    public private(set) var firstName = ""
    
    /// The user last name.
    public private(set) var lastName = ""
    
    /// The new password  of the user.
    public private(set) var newPassword = ""
    
    /// The password  of the user.
    public private(set) var password = ""
    
    /// The username.
    public private(set) var username = ""
    
    /// The token to return.
    public var cognitoToken = CognitoToken(
        accessToken: "accessToken",
        expiresIn: .distantFuture,
        idToken: "idToken",
        refreshToken: "refreshToken"
    )
    
    // MARK: Initializers
    
    public init() {}

    /// Update the password related to the user associated to the given username.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - newPassword: The new password.
    ///    - verificationCode: The verification code sent by amazon cognito.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func confirmForgotPassword(username: String, newPassword: String, confirmationCode: String) async throws {
        self.confirmationCode = confirmationCode
        self.newPassword = newPassword
        self.username = username

        if let error {
            throw error
        }
    }

    /// Confirms the registration of the user associated to the given username.
    ///
    /// - Parameters:
    ///    - username: The username of the user being confirmed.
    ///    - confirmationCode:The confirmation code in email.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func confirmSignUp(username: String, confirmationCode: String) async throws {
        self.confirmationCode = confirmationCode
        self.username = username

        if let error {
            throw error
        }
    }

    /// Decodes the access token if not expired.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Returns: The payload of the access token.
    /// - Throws. A `KountyError` If an error occurs during the verification process.
    public func decode(_ accessToken: String) async throws -> Cognito.CognitoTokenPayload {
        self.accessToken = accessToken

        return cognitoAccessToken!
    }

    /// Send a verification code to recover the password of the user associated
    /// to the given username.
    ///
    /// - Parameter username: The username of the user being confirmed.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func forgotPassword(username: String) async throws {
        self.username = username

        if let error {
            throw error
        }
    }
    
    /// Sign in the current user.
    ///
    /// - Parameter credential: The user credential.
    /// - Returns: The `CognitoToken` if any.
    /// - Throws: A `KountyError` if the authentication client fails.
    public func signIn(_ credential: Credential) async throws -> CognitoToken {
        let credential = credential as! UsernameAndPasswordCredential
        
        self.username = credential.username
        self.password = credential.password

        if let error {
            throw error
        }
        
        return cognitoToken
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
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.username = username

        if let error {
            throw error
        }
    }
    
    /// Verifies if the provided access token is valid.
    ///
    /// - Parameter accessToken: The access token to be verified.
    /// - Throws. A `KountyError` If an error occurs during the verification process.
    public func verify(_ accessToken: String) async throws {
        self.accessToken = accessToken
        
        if let error {
            throw error
        }
    }
}
