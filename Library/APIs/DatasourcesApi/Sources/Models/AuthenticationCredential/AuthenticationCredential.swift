//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Utility
import Vapor

/// A model representing an authentication credential within an application's domain.
public struct AuthenticationCredential: Content {
    /// The ID of the credential.
    public let id: UUID
    
    /// The date when the authentication credential was created.
    public let createdAt: Date?

    /// The databases associated to this credential.
    public let databases: [DatabaseModel]
    
    /// A name that identifies the credential.
    public let name: String

    /// The status of the authentication credential.
    public let status: Status

    /// The date when any of the authentication credential characteristics changed.
    public let updatedAt: Date?

    // MARK: - Types
    
    /// An enumeration representing the possible statuses of an authentication credential.
    public enum Status: String, Content {
        /// The credential is active and in use.
        case active
        
        /// The credential is inactive and no longer valid.
        case inactive
        
        /// The credential is pending and has not been fully activated.
        case pending
        
        /// Unknown type.
        case unknown
    }
    
    /// Creates a instance of the `AuthenticationCredential` from the given DTO.
    ///
    /// - Parameter datasource: The dto containing the data from the database.
    /// - Returns: The new instance of the datasource model.
    static func from(_ authenticationCredential: AuthenticationCredentialDTO) throws -> AuthenticationCredential {
        try AuthenticationCredential(
            id: try authenticationCredential.requireID(),
            createdAt: authenticationCredential.createdAt,
            databases: authenticationCredential.databases.map(DatabaseModel.from),
            name: authenticationCredential.name,
            status: Status(rawValue: authenticationCredential.status.rawValue) ?? .unknown,
            updatedAt: authenticationCredential.updatedAt
        )
    }

    // MARK: Initializer
    
    /// Initializes an `AuthenticationCredential` with specific parameters.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the credential.
    ///   - createdAt: The date when the authentication credential was created.
    ///   - name: A name that identifies the credential.
    ///   - status: The status of the credential.
    ///   - updatedAt: The date when any of the authentication credential characteristics changed.
    public init(
        id: UUID,
        createdAt: Date?,
        databases: [DatabaseModel],
        name: String,
        status: Status,
        updatedAt: Date?
    ) {

        self.id = id
        self.createdAt = createdAt
        self.databases = databases
        self.name = name
        self.status = status
        self.updatedAt = updatedAt
    }
}
