//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// The authentication token containing all the values
/// from the created session.
public struct AuthToken: Content {
    /// The access token.
    public let accessToken: String
    
    /// The expiration date of the token.
    public let expiresIn: Date
    
    /// The id token.
    public let idToken: String
    
    /// The token that you can use to get new tokens.
    public let refreshToken: String
}
