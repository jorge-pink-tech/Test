//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters to update an authentication credential.
public struct UpdateAuthenticationCredentialParameters: Decodable {
    /// A name that identifies the credential.
    public let name: String
}

extension UpdateAuthenticationCredentialParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "name",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El nombre no puede estar vacio."
        )
    }
}
