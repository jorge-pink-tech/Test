//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Extensions
import Fluent
import Utility
import Vapor

/// A model representing a datasource within an application's domain. It defines the
/// properties and methods that a datasource object should have, and is used to interact
/// with the data storage system (e.g. a database).
public final class DatasourceDTO: Model {
    /// The ID of the datasource.
    @ID(key: .id)
    public var id: UUID?
    
    /// The credentials associated to this datasource.
    @Children(for: \.$datasource)
    public var authenticationCredentials: [AuthenticationCredentialDTO]
    
    /// The type of authentication for the datasource.
    @Enum(key: .string(CodingKeys.authenticationType))
    public var authenticationType: AuthenticationType
   
    /// The date when the datasource was created.
    @Timestamp(key: .string(CodingKeys.createdAt), on: .create)
    public var createdAt: Date?
   
    /// The url of the logo for this datasource.
    @Field(key: .string(CodingKeys.logoURL))
    public var logoURL: URL
    
    /// The name idenfitiying the datasource.
    @Field(key: .string(CodingKeys.name))
    public var name: String
    
    /// The origin of the data source.
    @Enum(key: .string(CodingKeys.origin))
    public var origin: Origin
    
    /// The current status of the data source, indicating whether it is enabled or disabled.
    /// `enabled` means the data source is available for use, while `disabled` means it is inactive.
    @Enum(key: .string(CodingKeys.status))
    public var status: Status

    /// The date when any of the database characteristics changed.
    @Timestamp(key: .string(CodingKeys.updatedAt), on: .update)
    public var updatedAt: Date?
    
    /// The server url of this provider.
    @Field(key: .string(CodingKeys.url))
    public var url: URL
    
    // MARK: - Static properties
    
    /// Route to create and update a datasource in database
    public static let schema = "Datasource"
    
    // MARK: - CodingKeys
    
    /// Allowable fields for the model.
    enum CodingKeys: String, CodingKey {
        case id
        case authenticationType
        case createdAt
        case logoURL
        case name
        case origin
        case status
        case updatedAt
        case url
    }
    
    // MARK: - Types
    
    /// An enum that defines different types of authentication methods.
    public enum AuthenticationType: String, Codable, CaseIterable {
        /// Authentication using both email and an access key.
        case emailAndAccessKey
        
        /// Authentication using only an email.
        case emailOnly
        
        /// Authentication using both username and an access key.
        case usernameAndAccessKey
        
        // MARK: - Static Properties
        
        /// The name for this enum.
        static let name = "AuthenticationType"
    }
   
    /// Enum representing the different origins of a data source.
    public enum Origin: String, Codable, CaseIterable {
        /// The data source originates from Alegra.
        /// Alegra is one of the supported data providers, and this case is used to denote that
        /// the data being processed comes from the Alegra service.
        case alegra
        
        /// The data source originates from Quality.
        /// Quality is another supported data provider, and this case is used to identify data
        /// coming from the Quality service.
        case quality
        
        /// The data source originates from Siigo.
        /// Siigo is a third supported data provider, and this case is used to identify data
        /// sourced from Siigo's service.
        case siigo
        
        // MARK: - Static Properties
        
        /// The name for this enum.
        static let name = "DatasourceOrigin"
    }
    
    /// Represents the status of a data source, indicating whether it is enabled or disabled.
    /// This enum is used to define and manage the operational state of a data source.
    public enum Status: String, Codable, CaseIterable {
        /// Indicates that the data source is disabled.
        /// A disabled data source is not available for use, meaning no operations or data ingestion
        /// can be performed on this data source.
        case disabled
        
        /// Indicates that the data source is enabled.
        /// An enabled data source is active and available for use, meaning operations such as data
        /// ingestion, synchronization, or access can be performed on this data source.
        case enabled
        
        // MARK: - Static Properties
        
        /// The name for this enum.
        static let name = "DatasourceStatus"
    }

    // MARK: Initializers
    
    /// Creates a new instance of the `DatasourceDTO`.
    public init() {}
    
    /// Creates a new instance of the `DatasourceDTO`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - authenticationType: The type of authentication for the datasource.
    ///   - logoURL: The url of the logo for this datasource.
    ///   - name: The name idenfitiying the datasource.
    ///   - origin: The origin of the data source.
    ///   - status: The current status of the data source, indicating whether it is enabled or disabled.
    ///   - url: The server url of this provider.
    public init(
        id: UUID? = nil,
        authenticationType: AuthenticationType,
        logoURL: URL,
        name: String,
        origin: Origin,
        status: Status,
        url: URL
    ) {
        
        self.id = id
        self.authenticationType = authenticationType
        self.logoURL = logoURL
        self.name = name
        self.origin = origin
        self.status = status
        self.url = url
    }
    
    // MARK: Public methods
    
    /// Attaches an `AuthenticationCredentialDTO` to the specified database.
    ///
    /// This method is responsible for associating an `AuthenticationCredentialDTO` object with a database.
    /// Before attaching, it performs validation based on the authentication type and checks if the access token is empty.
    /// If the access token is required but is empty, it throws an error indicating that the access token is required.
    /// The operation is asynchronous and can throw an error if the attachment fails.
    ///
    /// - Parameters:
    ///   - authenticationCredential: The `AuthenticationCredentialDTO` object to be attached.
    ///   - database: The `Database` where the authentication credential will be attached.
    /// - Throws:
    ///   - `KountyError` if the access token is required but missing or empty.
    ///   - An error wrapped as `KountyError` if the attachment process fails.
    public func attach(_ authenticationCredential: AuthenticationCredentialDTO, on database: Database) async throws {
        do {
            if authenticationType != .emailOnly,
               
               /// Whether the access token is empty and not null.
               let accessToken = authenticationCredential.accessToken, accessToken.isEmpty {
               
                throw KountyError(
                    kind: .DatasourceDatabaseErrorReason.accessTokenRequired,
                    failureReason: "El token de acceso es requerido."
                )
            }
            
            try await $authenticationCredentials.create(authenticationCredential, on: database)
        } catch {
            throw error.asKountyError(or: .DatasourceDatabaseErrorReason.authenticationCredentialCreationFailed)
        }
    }
}
