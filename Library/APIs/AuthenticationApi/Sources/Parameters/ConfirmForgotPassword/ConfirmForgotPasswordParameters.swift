//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters when creating a new password
public struct ConfirmForgotPasswordParameters: Decodable {
    /// The confirmation code of the user.
    public let confirmationCode: String

    /// The confirmation password of the user.
    public let confirmPassword: String

    /// The email of the user.
    public let email: String

    /// The password of the user.
    public let newPassword: String
}

extension ConfirmForgotPasswordParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "confirmationCode",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El código de confirmación no puede estar vacío."
        )
        
        validations.add(
            "email",
            as: String.self,
            is: .email,
            customFailureDescription: "Email invalido."
        )
        
        validations.add(
            "newPassword",
            as: String.self,
            is: .isValidPassword,
            customFailureDescription: "La contraseña no cumple con los criterios requeridos."
        )

        validations.add(
            "confirmPassword",
            as: String.self,
            is: .isValidPassword,
            customFailureDescription: "La contraseña no cumple con los criterios requeridos."
        )
    }
}
