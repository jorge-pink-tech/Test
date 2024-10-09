//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters when sign in a user.
public struct SignInParameters: Decodable {
    /// The email of the user.
    public let email: String
    
    /// The password of the user.
    public let password: String
}

extension SignInParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "email",
            as: String.self,
            is: .email,
            customFailureDescription: "El email no es valido."
        )
        
        validations.add(
            "password",
            as: String.self,
            is: !.empty,
            customFailureDescription: "La contraseña no puede estar vacia."
        )
    }
}
