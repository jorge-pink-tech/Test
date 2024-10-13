//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Extensions
import Fluent
import Utility
import Vapor

/// A model representing a database within an application's domain. It defines the
/// properties and methods that a database object should have, and is used to interact
/// with the data storage system (e.g. a database).
public final class DatabaseDTO: Model {
    /// The ID of the database.
    @ID(key: .id)
    public var id: UUID?
   
    /// The authentication credential owner of this database.
    @Parent(key: .string(CodingKeys.authenticationCredentialId))
    public var authenticationCredential: AuthenticationCredentialDTO
    
    /// The date when the database was created.
    @Timestamp(key: .string(CodingKeys.createdAt), on: .create)
    public var createdAt: Date?
    
    /// The name idenfitiying the datasource.
    @Field(key: .string(CodingKeys.name))
    public var name: String
    
    /// The current status of the database.
    @Enum(key: .string(CodingKeys.status))
    public var status: Status

    /// The date when any of the database characteristics changed.
    @Timestamp(key: .string(CodingKeys.updatedAt), on: .update)
    public var updatedAt: Date?
    
    // MARK: - Static properties
    
    /// Route to create and update a database.
    public static let schema = "Database"
    
    // MARK: - CodingKeys
    
    /// Allowable fields for the model.
    enum CodingKeys: String, CodingKey {
        case id
        case authenticationCredentialId
        case createdAt
        case name
        case status
        case updatedAt
    }
    
    // MARK: - Types
    
    /// Represents the status of a database, indicating whether it is enabled or disabled.
    /// This enum is used to define and manage the operational state of a database.
    public enum Status: String, Codable, CaseIterable {
        /// Indicates that the datbase is active.
        /// An active database is active and available for use, meaning operations such as data
        /// ingestion, synchronization, or access can be performed on this database.
        case active
        
        /// Indicates that the database is inactive.
        /// A inactive database is not available for use, meaning no operations or data ingestion
        /// can be performed on this database.
        case inactive
        
        // MARK: - Static Properties
        
        /// The name for this enum.
        static let name = "DatabaseStatus"
    }

    // MARK: Initializers
    
    /// Creates a new instance of the `DatabaseDTO`.
    public init() {}
    
    /// Creates a new instance of the `DatabaseDTO`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - name: The name idenfitiying the datasource.
    ///   - status: The current status of the database.
    public init(id: UUID? = nil, name: String, status: Status) {
        self.id = id
        self.name = name
        self.status = status
    }
}
