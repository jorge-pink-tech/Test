//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the `DatasourceDTO`database migrations.
public struct DatasourceMigration: AsyncMigration {
    // MARK: Initializer
    
    /// Creates a new instance of the `DatasourceMigration`.
    public init() {}
    
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    public func prepare(on database: Database) async throws {
        let authenticationType = try await database
            .enum(DatasourceDTO.AuthenticationType.name)
            .read()
        
        try await database.schema(DatasourceDTO.schema)
            .id()
            .field(.string(DatasourceDTO.CodingKeys.authenticationType), authenticationType, .required)
            .field(.string(DatasourceDTO.CodingKeys.logoURL), .string, .required)
            .field(.string(DatasourceDTO.CodingKeys.name), .string, .required)
            .field(.string(DatasourceDTO.CodingKeys.createdAt), .datetime)
            .field(.string(DatasourceDTO.CodingKeys.updatedAt), .datetime)
            .field(.string(DatasourceDTO.CodingKeys.url), .string)
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    public func revert(on database: Database) async throws {
        try await database.schema(DatasourceDTO.schema).delete()
    }
}
