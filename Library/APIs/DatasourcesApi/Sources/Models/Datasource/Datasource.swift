//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Utility
import Vapor

/// A model representing a datasource within an application's domain.
public final class Datasource: Content {
    /// The ID of the datasource.
    public let id: UUID
    
    /// The type of authentication for the datasource.
    public var authenticationType: AuthenticationType
   
    /// The date when the user was created.
    public var createdAt: Date?
   
    /// The url of the logo for this datasource.
    public var logoURL: URL
    
    /// The name idenfitiying the datasource.
    public let name: String
    
    /// The current status of the data source.
    public let status: Status

    /// The date when any of the user characteristics changed.
    public let updatedAt: Date?
    
    /// The server url of this provider.
    public let url: URL
    
    // MARK: - Types
    
    /// An enum that defines different types of authentication methods.
    public enum AuthenticationType: String, Content {
        /// Authentication using only an email.
        case emailOnly
        
        /// Authentication using both email and an access key.
        case emailAndAccessKey
        
        /// Authentication using both username and an access key.
        case usernameAndAccessKey
        
        /// Unknown type.
        case unknown
    }
    
    /// Represents the status of a data source, indicating whether it is enabled or disabled.
    /// This enum is used to define and manage the operational state of a data source.
    public enum Status: String, Content {
        /// Indicates that the data source is disabled.
        /// A disabled data source is not available for use, meaning no operations or data ingestion
        /// can be performed on this data source.
        case disabled
        
        /// Indicates that the data source is enabled.
        /// An enabled data source is active and available for use, meaning operations such as data
        /// ingestion, synchronization, or access can be performed on this data source.
        case enabled
        
        /// Unknown type.
        case unknown
    }
    
    // MARK: Static methods
    
    /// Creates a instance of the `Datasource` from the given DTO.
    ///
    /// - Parameter datasource: The dto containing the data from the database.
    /// - Returns: The new instance of the datasource model.
    static func from(_ datasource: DatasourceDTO) throws -> Datasource {
        try Datasource(
            id: datasource.requireID(),
            authenticationType: AuthenticationType(rawValue: datasource.authenticationType.rawValue) ?? .unknown,
            createdAt: datasource.createdAt,
            logoURL: datasource.logoURL,
            name: datasource.name,
            status: Status(rawValue: datasource.status.rawValue) ?? .unknown,
            updatedAt: datasource.updatedAt,
            url: datasource.logoURL
        )
    }

    // MARK: Initializer
    
    /// Creates a new instance of the `Datasource`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - authenticationType: The type of authentication for the datasource.
    ///   - createdAt: The date when the user was created.
    ///   - logoURL: The url of the logo for this datasource.
    ///   - name: The name idenfitiying the datasource.
    ///   - status: The current status of the data source.
    ///   - updatedAt: The date when any of the user characteristics changed.
    ///   - url: The server url of this provider.
    public init(
        id: UUID,
        authenticationType: AuthenticationType,
        createdAt: Date?,
        logoURL: URL,
        name: String,
        status: Status,
        updatedAt: Date?,
        url: URL
    ) {
        
        self.id = id
        self.authenticationType = authenticationType
        self.createdAt = createdAt
        self.logoURL = logoURL
        self.name = name
        self.status = status
        self.updatedAt = updatedAt
        self.url = url
    }
}
