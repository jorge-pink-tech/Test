//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent

/// Handles all the enum migrations for the datasource database.
struct EnumMigration: AsyncMigration {
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    func prepare(on database: Database) async throws {
        _ = try await database.enum(AuthenticationCredentialDTO.Status.name)
            .case(AuthenticationCredentialDTO.Status.active.rawValue)
            .case(AuthenticationCredentialDTO.Status.inactive.rawValue)
            .case(AuthenticationCredentialDTO.Status.pending.rawValue)
            .create()
        
        _ = try await database.enum(DatasourceDTO.AuthenticationType.name)
            .case(DatasourceDTO.AuthenticationType.emailAndAccessKey.rawValue)
            .case(DatasourceDTO.AuthenticationType.emailOnly.rawValue)
            .case(DatasourceDTO.AuthenticationType.usernameAndAccessKey.rawValue)
            .create()
        
        _ = try await database.enum(DatasourceDTO.Origin.name)
            .case(DatasourceDTO.Origin.alegra.rawValue)
            .case(DatasourceDTO.Origin.quality.rawValue)
            .case(DatasourceDTO.Origin.siigo.rawValue)
            .create()
        
        _ = try await database.enum(DatasourceDTO.Status.name)
            .case(DatasourceDTO.Status.disabled.rawValue)
            .case(DatasourceDTO.Status.enabled.rawValue)
            .create()
        
        _ = try await database.enum(DatabaseDTO.Status.name)
            .case(DatabaseDTO.Status.active.rawValue)
            .case(DatabaseDTO.Status.inactive.rawValue)
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    func revert(on database: Database) async throws {
        try await database.enum(AuthenticationCredentialDTO.Status.name)
            .delete()
        
        try await database.enum(DatasourceDTO.AuthenticationType.name)
            .delete()
        
        try await database.enum(DatasourceDTO.Origin.name)
            .delete()
        
        try await database.enum(DatasourceDTO.Status.name)
            .delete()
        
        try await database.enum(DatabaseDTO.Status.name)
            .delete()
    }
}
