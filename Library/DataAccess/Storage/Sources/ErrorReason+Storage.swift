//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Utility

/// Represents all the errors that can be thrown by the `Storage` package.
extension ErrorReason {
    /// A collection of error reasons related to storage operations.
    ///
    /// The `StorageErrorReason` struct provides a set of static constants representing various errors that can occur
    /// during storage operations, such as clearing, reading, writing, or initializing storage. Each error reason is
    /// associated with a unique raw value (error code) to identify and handle different storage-related issues.
    public struct StorageErrorReason {
        /// Error indicating that the `clear` operation threw an error.
        ///
        /// This error occurs when an attempt to clear storage fails due to any internal error within the `clear` operation.
        public static let clearFailed = ErrorReason(rawValue: "CLEAR_FAILED")
        
        /// Error indicating that the `delete` operation threw an error.
        ///
        /// This error occurs when an attempt to delete an item from storage fails due to any internal error within the `delete` operation.
        public static let deleteFailed = ErrorReason(rawValue: "DELETE_FAILED")
        
        /// Error indicating that storage initialization failed.
        ///
        /// This error occurs when the system fails to properly initialize the storage, either due to incorrect configuration
        /// or any other internal error during the setup phase.
        public static let initializationFailed = ErrorReason(rawValue: "INITIALIZATION_FAILED")
        
        /// Error indicating that the `read` operation threw an error.
        ///
        /// This error occurs when an attempt to read data from storage fails due to any internal error within the `read` operation.
        public static let readFailed = ErrorReason(rawValue: "READ_FAILED")
        
        /// Error indicating that the `write` operation threw an error.
        ///
        /// This error occurs when an attempt to write data to storage fails due to any internal error within the `write` operation.
        public static let writeFailed = ErrorReason(rawValue: "WRITE_FAILED")
    }
}
