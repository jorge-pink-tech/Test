//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import Foundation
import UserDatabase
import Vapor

extension UserDTO {
    /// Creates a mock user record in the database.
    ///
    /// - Parameters:
    ///   - database: The database connection.
    /// - Returns: The created user DTO.
    @discardableResult
    public static func createMock(on database: Database) async throws -> UserDTO {
        let randomId = UUID()
        let user = UserDTO(
            id: UUID(),
            countryCode: "\(randomId)-countryCode",
            email: "\(randomId)@email.com",
            firstName: "\(randomId)-name",
            lastName: "\(randomId)-lastname",
            phone: "+573045600841"
        )
        
        try await user.create(on: database)
        return user
    }
}
