//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters when creating a new user.
public struct ForgotPasswordParameters: Decodable {
    /// The email of the user.
    public let email: String
}

extension ForgotPasswordParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "email",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El email no puede estar vacio."
        )
    }
}
