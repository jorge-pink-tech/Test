//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// Represents the payload of an access token.
public struct AccessTokenPayload: Content {
    /// The expiration date.
    public let expiresIn: Date

    /// The username associated with the token.
    public let username: String
}
