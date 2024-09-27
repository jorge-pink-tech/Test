//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation
import Utility

/// All the error reasons that can be thrown by the `CognitoClient`.
public enum CognitoErrorReason: ErrorReason {
    /// `confirmSignup` threw an error in.
    case confirmSignUpFailed

    /// `confirmForgotPassword` threw an error in.
    case confirmForgotPasswordFailed

    /// Expired confirmation code.
    case expiredConfirmationCode

    /// `forgotPassword` threw an error in.
    case forgotPasswordFailed

    /// Invalid confirmation code.
    case invalidConfirmationCode

    /// An invalid password threw an error in.
    case invalidPassword
    
    /// Missing access token.
    case missingAccessToken
    
    /// Missing cognito token.
    case missingIdToken
    
    /// Missing refresh token.
    case missingRefreshToken
    
    /// Missing token expiration date.
    case missingTokenExpirationDate
    
    /// `signIn` threw an error in.
    case signInFailed
    
    /// `signUp` threw an error in.
    case signupFailed

    /// Throw this error when the user isn't confirmed.
    case userNotConfirmed
    
    /// Error thrown when the user is unautorized.
    case unauthorized

    /// Unknown the error.
    case unknown
}
