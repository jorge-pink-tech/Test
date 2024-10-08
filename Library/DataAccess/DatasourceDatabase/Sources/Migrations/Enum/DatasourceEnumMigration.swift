//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles all the enum migrations for the datasource database.
public struct DatasourceEnumMigration: AsyncMigration {
    // MARK: Initializer
    
    /// Creates a new instance of the `EnumMigration`.
    public init() {}
    
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    public func prepare(on database: Database) async throws {
        try await database.enum(DatasourceDTO.AuthenticationType.name)
            .case(DatasourceDTO.AuthenticationType.emailAndAccessKey.rawValue)
            .case(DatasourceDTO.AuthenticationType.emailOnly.rawValue)
            .case(DatasourceDTO.AuthenticationType.usernameAndAccessKey.rawValue)
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    public func revert(on database: Database) async throws {
        try await database.enum(DatasourceDTO.AuthenticationType.name)
            .delete()
    }
}
