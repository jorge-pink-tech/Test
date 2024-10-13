//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Utility

/// Handles the `UserDTO`database migrations.
struct CreateUserMigration: AsyncMigration {
    // MARK: Migration
    
    /// Called when a migration is executed.
    ///
    /// - Parameter database: `Database` to run the migration on,
    func prepare(on database: Database) async throws {
        try await database.schema(UserDTO.schema)
            .id()
            .field(.string(UserDTO.CodingKeys.countryCode), .string, .required)
            .field(.string(UserDTO.CodingKeys.email), .string, .required)
            .field(.string(UserDTO.CodingKeys.firstName), .string, .required)
            .field(.string(UserDTO.CodingKeys.lastName), .string, .required)
            .field(.string(UserDTO.CodingKeys.phone), .string, .required)
            .field(.string(UserDTO.CodingKeys.createdAt), .datetime)
            .field(.string(UserDTO.CodingKeys.updatedAt), .datetime)
            .unique(on: .string(UserDTO.CodingKeys.email))
            .unique(on: .string(UserDTO.CodingKeys.phone))
            .create()
    }
    
    /// Called when the changes from a migration are reverted.
    ///
    /// - Parameter database: `Database` to revert the migration on.
    func revert(on database: Database) async throws {
        try await database.schema(UserDTO.schema).delete()
    }
}
