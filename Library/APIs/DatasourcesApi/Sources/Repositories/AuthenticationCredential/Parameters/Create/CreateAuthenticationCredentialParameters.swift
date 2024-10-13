//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters to create a new authentication credential.
public struct CreateAuthenticationCredentialParameters: Decodable {
    /// The access token associated with the credential.
    public let accessToken: String?
    
    /// The id of the datasource owner of this credential.
    public let datasourceId: UUID
    
    /// A name that identifies the credential.
    public let name: String

    /// The status of the authentication credential.
    public let status: AuthenticationCredential.Status

    /// The username associated with the credential.
    public let username: String
}

extension CreateAuthenticationCredentialParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "datasourceId",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El datasource no puede estar vacio."
        )
        
        validations.add(
            "name",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El nombre no puede estar vacio."
        )
        
        validations.add(
            "username",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El usuario no puede estar vacio."
        )
    }
}
