//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the datasource database creation.
public struct CreateDatasourceDatabaseMigration: AsyncMigration {
    // MARK: Initializer
    
    /// Creates a new instance of the `CreateDatasourceDatabaseMigration`.
    public init() {}
    
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    public func prepare(on database: Database) async throws {
        try await EnumMigration()
            .prepare(on: database)
        
        try await CreateDatasourceMigration()
            .prepare(on: database)
        
        try await CreateAuthenticationCredentialMigration()
            .prepare(on: database)
        
        try await CreateDatabaseMigration()
            .prepare(on: database)
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    public func revert(on database: Database) async throws {
        try await CreateDatasourceDatabaseMigration()
            .revert(on: database)
        
        try await CreateAuthenticationCredentialMigration()
            .revert(on: database)
        
        try await CreateDatasourceMigration()
            .revert(on: database)
        
        try await EnumMigration()
            .revert(on: database)
    }
}
