//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Extensions
import Fluent
import Utility
import Vapor

/// A model representing an authentication within an application's domain. It defines the
/// properties and methods that an authentication credential object should have, and is used to interact
/// with the data storage system (e.g. a database).
public final class AuthenticationCredentialDTO: Model {
    /// The ID of the credential.
    @ID(key: .id)
    public var id: UUID?

    /// The access token associated with the credential.
    @Field(key: .string(CodingKeys.accessToken))
    public var accessToken: String?
    
    /// The date when the authentication credential was created.
    @Timestamp(key: .string(CodingKeys.createdAt), on: .create)
    public var createdAt: Date?

    /// The databases associated to this credential.
    @Children(for: \.$authenticationCredential)
    public var databases: [DatabaseDTO]
    
    /// The datasource owner of this credential.
    @Parent(key: .string(CodingKeys.datasourceId))
    public var datasource: DatasourceDTO
    
    /// The date when the authentication credential was deleted.
    @Timestamp(key: .string(CodingKeys.deletedAt), on: .delete)
    public var deletedAt: Date?
    
    /// A name that identifies the credential.
    @Field(key: .string(CodingKeys.name))
    public var name: String

    /// The status of the authentication credential (e.g., active, inactive, pending).
    @Enum(key: .string(CodingKeys.status))
    public var status: Status

    /// The date when any of the authentication credential characteristics changed.
    @Timestamp(key: .string(CodingKeys.updatedAt), on: .update)
    public var updatedAt: Date?

    /// The ID of the user owner of this credential.
    @Field(key: .string(CodingKeys.userId))
    public var userId: UUID

    /// The username associated with the credential.
    @Field(key: .string(CodingKeys.username))
    public var username: String

    // MARK: - Static properties
    
    /// The schema route for creating and updating an authentication credential in the database.
    public static let schema = "AuthenticationCredential"

    // MARK: - CodingKeys
    
    /// The allowable fields for the model.
    enum CodingKeys: String, CodingKey {
        case id
        case accessToken
        case createdAt
        case deletedAt
        case datasourceId
        case name
        case status
        case updatedAt
        case userId
        case username
    }
    
    // MARK: - Types
    
    /// An enumeration representing the possible statuses of an authentication credential.
    public enum Status: String, CaseIterable, Codable {
        /// The credential is active and in use.
        case active
        
        /// The credential is inactive and no longer valid.
        case inactive
        
        /// The credential is pending and has not been fully activated.
        case pending
        
        // MARK: - Static Properties
        
        /// The name of the `Status` enum.
        static let name = "AuthenticationCredentialStatus"
    }

    // MARK: Initializers
    
    /// Creates a new instance of the `AuthenticationCredentialDTO`.
    public init() {}
    
    /// Initializes an `AuthenticationCredentialDTO` with specific parameters.
    ///
    /// - Parameters:
    ///   - id: The unique identifier for the credential (optional).
    ///   - accessToken: The access token used for authentication.    
    ///   - name: A name that identifies the credential.
    ///   - status: The status of the credential.
    ///   - userId: The ID of the user owner of this credential.
    ///   - username: The username associated with the credential (optional).
    public init(
        id: UUID? = nil,
        accessToken: String?,
        name: String,
        status: Status,
        userId: UUID,
        username: String
    ) {

        self.id = id
        self.accessToken = accessToken
        self.name = name
        self.status = status
        self.userId = userId
        self.username = username
    }
    
    // MARK: Static methods
    
    /// Finds an `AuthenticationCredentialDTO` by its ID and the associated user ID.
    ///
    /// This asynchronous static method queries the database to find an `AuthenticationCredentialDTO`
    /// that matches both the provided credential `id` and `userId`. If no matching credential is found,
    /// the method throws an error indicating that the credential was not found.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the authentication credential to search for.
    ///   - userId: The unique identifier of the user associated with the authentication credential.
    ///   - database: The database instance on which the query will be performed.
    /// - Returns: An optional `AuthenticationCredentialDTO`. If a matching credential is found, it is returned;
    ///            otherwise, an error is thrown.
    /// - Throws: A `KountyError` If no matching credential is found.
    public static func find(
        id: UUID,
        for userId: UUID,
        on database: Database
    ) async throws -> AuthenticationCredentialDTO {
        try await AuthenticationCredentialDTO.query(on: database)
            .group(.and) { group in
                group.filter(\.$id == id)
                    .filter(\.$deletedAt != nil)
                    .filter(\.$userId == userId)
            }
            .first()
            .unwrap(
                or: KountyError(
                    kind: .DatasourceDatabaseErrorReason.authenticationCredentialNotFound,
                    failureReason: "No se encontro la credencial."
                )
            )
    }
}
