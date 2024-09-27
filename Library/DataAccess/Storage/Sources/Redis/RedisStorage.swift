//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Foundation
import NIOCore
import NIOPosix
import RediStack
import Utility

/// A Secure Storage client which implements the base `Storage` interface.
/// `RedisStorage` uses `RedisClient` internally.
///
/// Create a `KeychainStorage` instance.
/// let storage = RedisStorage();
///
/// Write a key/value pair.
/// try await storage.write("my_value",  forKey: "my_key")
///
/// Read value for key.
/// let value = try await storage.read(key:  "mykey")
public struct RedisStorage: XStorage {
    // MARK: - Private Properties
    
    private let jsondDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    private let redisClient: RedisClient
    
    // MARK: Static methods

    /// Creates a new instance of this `RedisStorage` class.
    ///
    /// - Parameters:
    ///    - hostname: The remote hostname to connect to.
    ///    - port: The port that the Redis instance connects with.
    ///    - password: The optional password to authenticate the connection with. The default is `nil`.
    public static func make(hostname: String, port: Int? = nil, password: String? = nil) async throws -> RedisStorage {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                RedisConnection.make(
                    configuration: try .init(
                        hostname: hostname,
                        port: port ?? RedisConnection.Configuration.defaultPort,
                        password: password
                    ),
                    boundEventLoop: NIOSingletons.posixEventLoopGroup.any()
                )
                .whenComplete { result in
                    switch result {
                    case let .failure(redisError):
                        let error = KountyError(
                            kind: StorageErrorReason.initializationFailed,
                            underlyingError: redisError
                        )
                        
                        continuation.resume(throwing: error)
                        
                    case let .success(redisConnection):
                        let redisStorage = RedisStorage(redisClient: redisConnection)
                        
                        continuation.resume(with: .success(redisStorage))
                    }
                }
            } catch {
                let error = KountyError(kind: StorageErrorReason.initializationFailed, underlyingError: error)
                continuation.resume(throwing: error)
            }
        }
    }

    // MARK: Initializer

    /// Creates a new instance of this `RedisStorage`.
    ///
    /// - Parameter connection: The concrete `RedisClient` implementation that represents an individual connection to a Redis instance.
    init(redisClient: RedisClient) {
        self.redisClient = redisClient
    }
    
    // MARK: Storage

    /// Deletes a key from the storage asynchronously.
    ///
    /// - Parameter key: The key to delete from the Redis database.
    /// - Throws: An error if the operation fails.
    public func delete(key: String) async throws {
        try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
            redisClient.delete([.init(key)])
                .whenComplete { result in
                    switch result {
                    case let .failure(redisError):
                        let error = KountyError(kind: StorageErrorReason.deleteFailed, underlyingError: redisError)
                        
                        continuation.resume(throwing: error)
                        
                    case let .success(keysDeleted):
                        guard keysDeleted > 0 else {
                            let error = KountyError(kind: StorageErrorReason.deleteFailed)
                            
                            continuation.resume(with: .failure(error))
                            return
                        }
                        
                        continuation.resume()
                    }
                }
        }
    }

    /// Fetch the value for the given key.
    ///
    /// - Parameters:
    ///    - key: The storaged key.
    ///    - type: The resulting type when decoding.
    /// - Returns: value for the provided `key` or returns `nil` if no value is found for the given `key`.
    /// - Throws: a `KountyError` if the read fails.
    public func read<T>(_ type: T.Type, forKey key: String) async throws -> T? where T: Decodable {
        try await withUnsafeThrowingContinuation { continuation in
            redisClient.get(.init(key), as: Data.self)
                .whenComplete { result in
                    switch result {
                    case let .failure(redisError):
                        let error = KountyError(kind: StorageErrorReason.readFailed, underlyingError: redisError)
                        
                        continuation.resume(throwing: error)
                        
                    case let .success(data):
                        guard let data = data else {
                            continuation.resume(with: .success(nil))
                            return
                        }
                        
                        do {
                            let value = try jsondDecoder.decode(T.self, from: data)
                            
                            continuation.resume(with: .success(value))
                        } catch {
                            let error = KountyError(kind: StorageErrorReason.readFailed, underlyingError: error)
                            
                            continuation.resume(throwing: error)
                        }
                    }
                }
        }
    }

    /// Writes the provided `key`, `value` pair asynchronously.
    ///
    /// - Parameters:
    ///   - value: The value that will be storage.
    ///   - key: The key that save the given value.
    ///   - Throws: a `KountyError` if the read fails.
    public func write<T>(_ value: T, forKey key: String) async throws where T: Encodable {
        try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Void, Error>) in
            do {
                let data = try jsonEncoder.encode(value)
                
                redisClient.set(.init(key), to: data)
                    .whenComplete { result in
                        switch result {
                        case let .failure(redisError):
                            let error = KountyError(kind: StorageErrorReason.writeFailed, underlyingError: redisError)
                            
                            continuation.resume(throwing: error)
                            
                        case .success:
                            continuation.resume()
                        }
                    }
            } catch {
                let error = KountyError(kind: StorageErrorReason.writeFailed, underlyingError: error)
                
                continuation.resume(throwing: error)
            }
        }
    }
}
