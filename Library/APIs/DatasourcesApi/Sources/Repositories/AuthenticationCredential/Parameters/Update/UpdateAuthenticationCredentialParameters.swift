//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters to update an authentication credential.
public struct UpdateAuthenticationCredentialParameters: Decodable {
    /// The id of the credential.
    public let id: UUID
    
    /// A name that identifies the credential.
    public let name: String
    
    /// The id of the user owner of the data.
    public let userId: UUID
}

extension UpdateAuthenticationCredentialParameters: Validatable {
    
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
            "name",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El nombre no puede estar vacio."
        )
        
        validations.add(
            "userId",
            as: UUID.self,
            is: .valid,
            customFailureDescription: "El id del usuario no es valido."
        )
    }
}
