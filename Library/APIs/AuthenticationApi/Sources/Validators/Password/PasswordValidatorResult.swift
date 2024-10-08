//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// Represents the result of a password validation.
struct PasswordValidatorResult: ValidatorResult {
    /// Indicates whether the input is a valid password.
    let isValid: Bool

    /// A boolean value indicating whether the validation failed.
    var isFailure: Bool {
        !isValid
    }

    /// A description of success, which is nil for a password validation.
    var successDescription: String? {
        nil
    }

    /// A description of failure, indicating that the input is not a valid password.
    var failureDescription: String? {
        "La contraseña no cumple con los criterios requeridos."
    }
}

extension Validator where T == String {
    /// Validates whether a `String` is a valid zip code.
    static var isValidPassword: Validator<T> {
        .init { password in
            let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"

            do {
                let regex = try NSRegularExpression(pattern: regex)
                let range = NSRange(location: 0, length: password.utf16.count)
                let isValid = regex.firstMatch(in: password, options: [], range: range) != nil
                
                return PasswordValidatorResult(isValid: isValid)
            } catch {
                return PasswordValidatorResult(isValid: false)
            }
        }
    }
}
