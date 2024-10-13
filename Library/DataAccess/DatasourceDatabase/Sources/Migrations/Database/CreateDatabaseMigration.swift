//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the `DatabaseDTO`database migrations.
struct CreateDatabaseMigration: AsyncMigration {

    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    func prepare(on database: Database) async throws {
        let status = try await database
            .enum(DatabaseDTO.Status.name)
            .read()
        
        try await database.schema(DatabaseDTO.schema)
            .id()
            .field(.string(DatabaseDTO.CodingKeys.createdAt), .datetime)
            .field(.string(DatabaseDTO.CodingKeys.name), .string, .required)
            .field(.string(DatabaseDTO.CodingKeys.status), status, .required)
            .field(.string(DatabaseDTO.CodingKeys.updatedAt), .datetime)
            .field(
                .string(DatabaseDTO.CodingKeys.authenticationCredentialId),
                .uuid,
                .required,
                .references(
                    AuthenticationCredentialDTO.schema,
                    .string(AuthenticationCredentialDTO.CodingKeys.id),
                    onDelete: .cascade
                )
            )
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    func revert(on database: Database) async throws {
        try await database.schema(DatabaseDTO.schema).delete()
    }
}
