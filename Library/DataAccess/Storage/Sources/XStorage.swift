//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation

/// A type that can convert itself into and out of an external representation.
public typealias XStorage = ReadableStorage & WritableStorage

/// A Swift Storage Client Interface for reading data.
public protocol ReadableStorage {
    /// Fetch the value for the given key.
    ///
    /// - Parameters:
    ///    - key: The storaged key.
    ///    - type: The resulting type when decoding.
    /// - Returns: value for the provided `key` or returns `nil` if no value is found for the given `key`.
    /// - Throws: a `KountyError` if the read fails.
    func read<T>(_ type: T.Type, forKey key: String) async throws -> T? where T: Decodable
}

/// A Swift Storage Client Interface for storing data.
public protocol WritableStorage {
    /// Deletes a key from the storage asynchronously.
    ///
    /// - Parameter key: The key to delete from the Redis database.
    /// - Throws: An error if the operation fails.
    func delete(key: String) async throws

    /// Writes the provided `key`, `value` pair asynchronously.
    ///
    /// - Parameters:
    ///   - value: The value that will be storage.
    ///   - key: The key that save the given value.
    ///   - Throws: a `KountyError` if the read fails.
    func write<T>(_ value: T, forKey key: String) async throws where T: Encodable
}
