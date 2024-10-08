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

    /// The date when any of the user characteristics changed.
    public let updatedAt: Date?
    
    /// The server url of this provider.
    public let url: URL
    
    // MARK: - Types
    
    /// An enum that defines different types of authentication methods.
    public enum AuthenticationType: String, Codable {
        /// Authentication using only an email.
        case emailOnly
        
        /// Authentication using both email and an access key.
        case emailAndAccessKey
        
        /// Authentication using both username and an access key.
        case usernameAndAccessKey
        
        /// Unknown type.
        case unknown
    }
    
    // MARK: Static methods
    
    /// Creates a instance of the `Datasource` from the given DTO.
    ///
    /// - Parameter datasource: The dto containing the data from the database.
    /// - Returns: The new instance of the datasource model.
    public static func from(_ datasource: DatasourceDTO) throws -> Datasource {
        try Datasource(
            id: datasource.requireID(),
            authenticationType: AuthenticationType(rawValue: datasource.authenticationType.rawValue) ?? .unknown,
            createdAt: datasource.createdAt,
            logoURL: datasource.logoURL,
            name: datasource.name,
            updatedAt: datasource.updatedAt,
            url: datasource.logoURL
        )
    }

    // MARK: Initializers
    
    /// Creates a new instance of the `DatasourceDTO`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - authenticationType: The type of authentication for the datasource.
    ///   - createdAt: The date when the user was created.
    ///   - logoURL: The url of the logo for this datasource.
    ///   - name: The name idenfitiying the datasource.
    ///   - updatedAt: The date when any of the user characteristics changed.
    ///   - url: The server url of this provider.
    public init(
        id: UUID,
        authenticationType: AuthenticationType,
        createdAt: Date?,
        logoURL: URL,
        name: String,
        updatedAt: Date?,
        url: URL
    ) {
        
        self.id = id
        self.authenticationType = authenticationType
        self.createdAt = createdAt
        self.logoURL = logoURL
        self.name = name
        self.updatedAt = updatedAt
        self.url = url
    }
}
