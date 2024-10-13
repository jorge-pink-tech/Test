//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters to update an authentication credential.
public struct UpdateAuthenticationCredentialStatusParameters: Decodable {
    /// The new status of the credential.
    public let status: AuthenticationCredential.Status
}

extension UpdateAuthenticationCredentialStatusParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "status",
            as: AuthenticationCredential.Status.self,
            is: .valid,
            customFailureDescription: "El estatus de la credencial no es valido."
        )
    }
}
