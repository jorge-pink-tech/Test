//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the `AuthenticationCredentialDTO`database migrations.
struct CreateAuthenticationCredentialMigration: AsyncMigration {

    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    func prepare(on database: Database) async throws {
        let status = try await database
            .enum(AuthenticationCredentialDTO.Status.name)
            .read()
        
        try await database.schema(AuthenticationCredentialDTO.schema)
            .id()
            .field(.string(AuthenticationCredentialDTO.CodingKeys.accessToken), .string)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.createdAt), .datetime)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.deletedAt), .datetime)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.name), .string, .required)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.status), status, .required)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.userId), .uuid, .required)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.username), .string, .required)
            .field(.string(AuthenticationCredentialDTO.CodingKeys.updatedAt), .datetime)
            .field(
                .string(AuthenticationCredentialDTO.CodingKeys.datasourceId),
                .uuid,
                .required,
                .references(
                    DatasourceDTO.schema,
                    .string(DatasourceDTO.CodingKeys.id),
                    onDelete: .cascade
                )
            )
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    func revert(on database: Database) async throws {
        try await database.schema(AuthenticationCredentialDTO.schema).delete()
    }
}
