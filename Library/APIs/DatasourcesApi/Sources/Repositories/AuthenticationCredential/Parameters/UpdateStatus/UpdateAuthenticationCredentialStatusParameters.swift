//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters to update an authentication credential.
public struct UpdateAuthenticationCredentialStatusParameters: Decodable {
    /// The id of the credential.
    public let id: UUID
    
    /// The new status of the credential.
    public let status: AuthenticationCredential.Status
    
    /// The id of the user owner of the data.
    public let userId: UUID
}

extension UpdateAuthenticationCredentialStatusParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "id",
            as: UUID.self,
            is: .valid,
            customFailureDescription: "El id de la credencial de autenticación no es valido."
        )
        
        validations.add(
            "datasourceId",
            as: UUID.self,
            is: .valid,
            customFailureDescription: "El id del datasource no es valido."
        )
        
        validations.add(
            "userId",
            as: UUID.self,
            is: .valid,
            customFailureDescription: "El id del usuario no es valido."
        )
    }
}
