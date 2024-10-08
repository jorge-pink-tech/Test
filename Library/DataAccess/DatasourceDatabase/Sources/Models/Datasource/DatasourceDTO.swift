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
    
    /// The type of authentication for the datasource.
    @Enum(key: .string(CodingKeys.authenticationType))
    public var authenticationType: AuthenticationType
   
    /// The date when the user was created.
    @Timestamp(key: .string(CodingKeys.createdAt), on: .create)
    public var createdAt: Date?
   
    /// The url of the logo for this datasource.
    @Field(key: .string(CodingKeys.logoURL))
    public var logoURL: URL
    
    /// The name idenfitiying the datasource.
    @Field(key: .string(CodingKeys.name))
    public var name: String

    /// The date when any of the user characteristics changed.
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
    ///   - url: The server url of this provider.
    public init(
        id: UUID? = nil,
        authenticationType: AuthenticationType,
        logoURL: URL,
        name: String,
        url: URL
    ) {
        
        self.id = id
        self.authenticationType = authenticationType
        self.logoURL = logoURL
        self.name = name
        self.url = url
    }
}
