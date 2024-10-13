//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Utility
import Vapor

/// A model representing a database within an application's domain.
public final class DatabaseModel: Content {
    /// The ID of the database.
    public let id: UUID
    
    /// The date when the database was created.
    public let createdAt: Date?
    
    /// The name idenfitiying the datasource.
    public let name: String
    
    /// The current status of the database, indicating whether it is enabled or disabled.
    public var status: Status

    /// The date when any of the database characteristics changed.
    public let updatedAt: Date?
    
    // MARK: - CodingKeys
    
    /// Allowable fields for the model.
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt
        case name
        case status
        case updatedAt
    }
    
    // MARK: - Types
    
    /// Represents the status of a database, indicating whether it is enabled or disabled.
    /// This enum is used to define and manage the operational state of a database.
    public enum Status: String, Content {
        /// Indicates that the datbase is active.
        /// An active database is active and available for use, meaning operations such as data
        /// ingestion, synchronization, or access can be performed on this database.
        case active
        
        /// Indicates that the database is inactive.
        /// A inactive database is not available for use, meaning no operations or data ingestion
        /// can be performed on this database.
        case inactive
        
        /// Unknown type.
        case unknown
    }
    
    /// Creates a instance of the `DatabaseModel` from the given DTO.
    ///
    /// - Parameter datasource: The dto containing the data from the database.
    /// - Returns: The new instance of the datasource model.
    static func from(_ database: DatabaseDTO) throws -> DatabaseModel {
        try DatabaseModel(
            id: try database.requireID(),
            createdAt: database.createdAt,
            name: database.name,
            status: Status(rawValue: database.status.rawValue) ?? .unknown,
            updatedAt: database.updatedAt
        )
    }

    // MARK: Initializer
    
    /// Creates a new instance of the `DatabaseDTO`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - createdAt: The date when the database was created.
    ///   - name: The name idenfitiying the datasource.
    ///   - status: The current status of the data source, indicating whether it is enabled or disabled.
    ///   - updatedAt: The date when any of the database characteristics changed.
    public init(id: UUID, createdAt: Date?, name: String, status: Status, updatedAt: Date?) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.status = status
        self.updatedAt = updatedAt
    }
}
