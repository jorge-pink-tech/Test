//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation
import Utility

/// A Storage client which implements the base `Storage` interface.
/// `InMemoryStorage` uses a `Dictionary` internally.
///
/// Create a `InMemoryStorage` instance.
/// let storage = InMemoryStorage();
///
/// Write a key/value pair.
/// storage.write("my_value",  forKey: "my_key")
///
/// Read value for key.
/// let value = storage.read(key:  "mykey")
public class InMemoryStorage: XStorage {
    // MARK: - Private Properties
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var storage: [String: Data] = [:]

    // MARK: Initializer

    /// Creates a new instance of this `InMemoryStorage`.
    public init() {}

    // MARK: Storage

    /// Deletes a key from the storage asynchronously.
    ///
    /// - Parameter key: The key to delete from the Redis database.
    /// - Throws: An error if the operation fails.
    public func delete(key: String) async throws {
        storage.removeValue(forKey: key)
    }

    /// Fetch the value for the given key.
    ///
    /// - Parameters:
    ///    - key: The storaged key.
    ///    - type: The resulting type when decoding.
    /// - Returns: value for the provided `key` or returns `nil` if no value is found for the given `key`.
    /// - Throws: a `KountyError` if the read fails.
    public func read<T>(_ type: T.Type, forKey key: String) async throws -> T? where T: Decodable {
        do {
            guard let data = storage[key] else {
                return nil
            }
                
            return try decoder.decode(T.self, from: data)
        } catch {
            throw KountyError(kind: StorageErrorReason.readFailed, underlyingError: error)
        }
    }

    /// Writes the provided `key`, `value` pair asynchronously.
    ///
    /// - Parameters:
    ///   - value: The value that will be storage.
    ///   - key: The key that save the given value.
    ///   - Throws: a `KountyError` if the read fails.
    public func write<T>(_ value: T, forKey key: String) async throws where T: Encodable {
        do {
            /// Encodes the value to data using JSONEncoder.
            let data = try encoder.encode(value)
            storage[key] = data
        } catch {
            throw KountyError(kind: StorageErrorReason.writeFailed, underlyingError: error)
        }
    }
}
