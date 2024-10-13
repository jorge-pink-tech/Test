//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation
import Utility

/// All the error reasons that can be thrown by the `CognitoClient`.
extension ErrorReason {
    /// A collection of error reasons related to AWS Cognito operations.
    ///
    /// The `CognitoErrorReason` struct provides a set of static constants representing various errors that can occur
    /// during interactions with AWS Cognito, such as sign-up, sign-in, password recovery, and token management.
    /// Each error reason is associated with a unique raw value (error code) to help identify and handle
    /// specific Cognito-related issues.
    public struct CognitoErrorReason {
        /// Error indicating that confirming the sign-up process has failed.
        ///
        /// This error occurs when AWS Cognito fails to confirm the user's sign-up due to invalid or missing data.
        public static let confirmSignUpFailed = ErrorReason(rawValue: "CONFIRM_SIGNUP_FAILED")
        
        /// Error indicating that confirming the forgot password process has failed.
        ///
        /// This error occurs when AWS Cognito fails to confirm the forgot password process, typically due to invalid or expired data.
        public static let confirmForgotPasswordFailed = ErrorReason(rawValue: "CONFIRM_FORGOT_PASSWORD_FAILED")
        
        /// Error indicating that the confirmation code has expired.
        ///
        /// This error occurs when the user provides an expired confirmation code during sign-up or password recovery.
        public static let expiredConfirmationCode = ErrorReason(rawValue: "EXPIRED_CONFIRMATION_CODE")
        
        /// Error indicating that the forgot password process has failed.
        ///
        /// This error occurs when AWS Cognito fails to process the forgot password request.
        public static let forgotPasswordFailed = ErrorReason(rawValue: "FORGOT_PASSWORD_FAILED")
        
        /// Error indicating that the provided confirmation code is invalid.
        ///
        /// This error occurs when the confirmation code provided by the user is invalid during the sign-up or password recovery process.
        public static let invalidConfirmationCode = ErrorReason(rawValue: "INVALID_CONFIRMATION_CODE")
        
        /// Error indicating that the provided password is invalid.
        ///
        /// This error occurs when the password provided does not meet the required conditions.
        public static let invalidPassword = ErrorReason(rawValue: "INVALID_PASSWORD")
        
        /// Error indicating that the access token is missing.
        ///
        /// This error occurs when an access token is required but is missing from the request.
        public static let missingAccessToken = ErrorReason(rawValue: "MISSING_ACCESS_TOKEN")
        
        /// Error indicating that the ID token is missing.
        ///
        /// This error occurs when an ID token is required but is missing from the request.
        public static let missingIdToken = ErrorReason(rawValue: "MISSING_ID_TOKEN")
        
        /// Error indicating that the refresh token is missing.
        ///
        /// This error occurs when a refresh token is required but is missing from the request.
        public static let missingRefreshToken = ErrorReason(rawValue: "MISSING_REFRESH_TOKEN")
        
        /// Error indicating that the token expiration date is missing.
        ///
        /// This error occurs when the expiration date of a token is required but is missing.
        public static let missingTokenExpirationDate = ErrorReason(rawValue: "MISSING_TOKEN_EXPIRATION_DATE")
        
        /// Error indicating that the sign-in process has failed.
        ///
        /// This error occurs when AWS Cognito fails to sign in the user, typically due to invalid credentials or missing information.
        public static let signInFailed = ErrorReason(rawValue: "SIGN_IN_FAILED")
        
        /// Error indicating that the sign-up process has failed.
        ///
        /// This error occurs when AWS Cognito fails to sign up the user due to invalid data or other issues.
        public static let signUpFailed = ErrorReason(rawValue: "SIGN_UP_FAILED")
        
        /// Error indicating that the user has not confirmed their account.
        ///
        /// This error occurs when an attempt is made to sign in or perform actions with an account that has not been confirmed.
        public static let userNotConfirmed = ErrorReason(rawValue: "USER_NOT_CONFIRMED")
        
        /// Error indicating an unauthorized access attempt.
        ///
        /// This error occurs when a request is made without proper authentication or authorization.
        public static let unauthorized = ErrorReason(rawValue: "UNAUTHORIZED")
    }
}
