//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility

extension ErrorReason {
    /// A struct that defines common datasource-database-related error reasons.
    public struct DatasourceDatabaseErrorReason {
        /// The access token is required to perform this operation.
        ///
        /// This error occurs when an access token is required but has not been provided.
        public static let accessTokenRequired = ErrorReason(rawValue: "ACCESS_TOKEN_REQUIRED")
        
        /// Failed to create the authentication credential.
        ///
        /// This error occurs when the creation of an authentication credential for the datasource fails.
        public static let authenticationCredentialCreationFailed = ErrorReason(
            rawValue: "AUTHENTICATION_TOKEN_CREDENTIAL_FAILED"
        )
        
        /// Authentication credential not found.
        ///
        /// This error occurs when the authentication credential is not found.
        public static let authenticationCredentialNotFound = ErrorReason(
            rawValue: "AUTHENTICATION_CREDENTIAL_NOT_FOUND"
        )
    }
}
