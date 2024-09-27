//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility

/// Represents all the errors that can be thrown by the `UserDatabase`.
public enum UserDatabaseErrorReason: ErrorReason {
    /// The user's email is taken.
    case emailTaken
    
    /// The user's phone is already registered.
    case phoneIsRegistered
    
    /// Save operation  threw an error in.
    case saveFailed
}
