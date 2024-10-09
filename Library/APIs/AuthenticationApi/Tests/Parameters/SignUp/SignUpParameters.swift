//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A struct representing the parameters when creating a new user.
public struct SignUpParameters: Decodable {
    /// The identifier of the country.
    public let countryCode: String
    
    /// The email of the user.
    public let email: String
    
    /// The first name of the user.    
    public let firstName: String
    
    /// The last name of the user.
    public let lastName: String
    
    /// The password of the user.
    public let password: String
    
    /// The phone of the user.    
    public let phone: String
}

extension SignUpParameters: Validatable {
    
    // MARK: Validatable
    
    /// Capable of being validated.
    public static func validations(_ validations: inout Validations) {
        validations.add(
            "countryCode",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El codigo del pais no puede estar vacio."
        )
        
        validations.add(
            "firstName",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El nombre no puede estar vacio."
        )
        
        validations.add(
            "lastName",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El apellido no puede estar vacio."
        )

        validations.add(
            "password",
            as: String.self,
            is: .isValidPassword,
            customFailureDescription: "La contraseña no cumple con los criterios requeridos."
        )
        
        validations.add(
            "phone",
            as: String.self,
            is: !.empty,
            customFailureDescription: "El número de teléfono no puede estar vacio."
        )
    }
}
