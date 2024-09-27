//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters when creating a new user.
public struct ConfirmSignUpParameters: Decodable {
    /// The confirmation code of the user.
    public var confirmationCode: String

    /// The email of the user.
    public let email: String
}

extension ConfirmSignUpParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "confirmationCode",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El codigo de confirmación no puede estar vacio."
        )

        validations.add(
            "email",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El email no puede estar vacio."
        )
    }
}
