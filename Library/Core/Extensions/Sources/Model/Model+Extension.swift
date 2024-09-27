//
// Copyright © 2024 PinkTech. All rights reserved.
//

import FluentKit
import Foundation
import Utility

extension Model where IDValue == UUID {
    /// Checks if the model exists in the database.
    ///
    /// - Parameter database: The database connection on which to execute the operation.
    /// - Returns: A boolean indicating whether the model exists in the database.
    /// - Throws: An error if there's an issue with the database operation.
    public func exists(on database: Database) async throws -> Bool {
        guard let id else {
            return false
        }

        return try await Self.find(id, on: database) != nil
    }
}
