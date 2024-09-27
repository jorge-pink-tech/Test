//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation

/// The authentication token containing all the values
/// from the created session.
public struct CognitoToken {
    /// The access token.
    public let accessToken: String
    
    /// The expiration date of the token.
    public let expiresIn: Date
    
    /// The id token.
    public let idToken: String
    
    /// The token that you can use to get new tokens.
    public let refreshToken: String
    
    // MARK: Instance methods
    
    /// Creates a new instance of the `CognitoToken`.
    ///
    /// - Parameters:
    ///   - accessToken: The access token.
    ///   - expiresIn: The expiration date of the token.
    ///   - idToken: The id token.
    ///   - refreshToken: The token that you can use to get new tokens.
    public init(accessToken: String, expiresIn: Date, idToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.idToken = idToken
        self.refreshToken = refreshToken
    }
}
