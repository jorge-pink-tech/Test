//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility

/// Represents all the errors that can be thrown by the `UserDatabase`.
extension ErrorReason {
    /// A collection of error reasons related to user database operations.
    ///
    /// The `UserDatabaseErrorReason` struct provides a set of static constants representing common errors that can occur
    /// during user-related operations in the database, such as registering a user or saving user information. Each error
    /// reason is associated with a unique raw value (error code) to identify specific database-related issues when working
    /// with user data.
    public struct UserDatabaseErrorReason {
        /// Error indicating that the email address provided is already registered.
        ///
        /// This error occurs when an attempt to register a user with an email address fails because the email is already taken.
        public static let emailTaken = ErrorReason(rawValue: "EMAIL_TAKEN")
        
        /// Error indicating that the phone number provided is already registered.
        ///
        /// This error occurs when an attempt to register a user with a phone number fails because the phone number is already registered.
        public static let phoneIsRegistered = ErrorReason(rawValue: "PHONE_IS_REGISTERED")
        
        /// Error indicating that saving the user to the database has failed.
        ///
        /// This error occurs when there is an internal failure while attempting to save a user record in the database.
        public static let saveFailed = ErrorReason(rawValue: "SAVE_FAILED")
    }
}
