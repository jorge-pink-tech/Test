//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility

/// Represents all the errors that can be thrown by the `Storage` package.
public enum StorageErrorReason: ErrorReason {
    /// `clear` threw an error in.
    case clearFailed

    /// `delete` threw an error in.
    case deleteFailed
    
    /// Storage initialization has failed.
    case initializationFailed

    /// `read` threw an error in.
    case readFailed

    /// `write` threw an error in.
    case writeFailed

    /// Unknown error.
    case unknown
}
