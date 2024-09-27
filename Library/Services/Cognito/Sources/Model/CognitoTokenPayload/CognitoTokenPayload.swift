//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation

/// Represents the payload of an access token.
public struct CognitoTokenPayload: Encodable, Decodable {
    /// The email associated with the token.
    public let email: String

    /// The expiration date.
    public let exp: Date
}
