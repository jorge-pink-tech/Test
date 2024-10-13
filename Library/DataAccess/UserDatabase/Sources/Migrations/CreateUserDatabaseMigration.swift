//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the user database creation.
public struct CreateUserDatabaseMigration: AsyncMigration {
    // MARK: Initializer
    
    /// Creates a new instance of the `CreateUserDatabaseMigration`.
    public init() {}
    
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    public func prepare(on database: Database) async throws {
        try await CreateUserMigration()
            .prepare(on: database)
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    public func revert(on database: Database) async throws {
        try await CreateUserMigration()
            .revert(on: database)
    }
}
