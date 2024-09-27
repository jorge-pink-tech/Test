//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import UserDatabase
import Vapor

/// A model representing a user within an application's domain.
public struct User: Authenticatable, Content, Equatable {
    /// The ID of the user.
    public let id: UUID
    
    /// The identifier of the country.
    public let countryCode: String
   
    /// The date when the user was created.
    public let createdAt: Date?
   
    /// The email of the user.
    public let email: String
   
    /// The first name of the user.
    public let firstName: String
   
    /// The last name of the user.
    public let lastName: String
   
    /// The phone of the user.
    public let phone: String
   
    /// The date when any of the user characteristics changed.
    public let updatedAt: Date?
    
    /// Create a anonymous instance for user.
    public static let anonymous = User(
        id: UUID(),
        countryCode: "",
        createdAt: nil,
        email: "",
        firstName: "",
        lastName: "",
        phone: "",
        updatedAt: nil
    )
    
    // MARK: Static methods
    
    /// Creates a new instance of the `User` from
    ///
    /// - Parameter user: The DTO containing the user information.
    /// - Throws: An `Error` if somethings goes wrong.
    /// - Returns: A new instance of the `User`.
    static func from(_ user: UserDTO) throws -> Self {
        .init(
            id: try user.requireID(),
            countryCode: user.countryCode,
            createdAt: user.createdAt,
            email: user.email,
            firstName: user.firstName,
            lastName: user.lastName,
            phone: user.phone,
            updatedAt: user.updatedAt
        )
    }

    // MARK: Initializer
    
    /// Creates a new instance of the `User`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - countryCode: The identifier of the country.
    ///   - createdAt: The date when te user was created.
    ///   - email: The email of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - phone: The phone of the user.
    ///   - updatedAt: The date when te user was updated.
    public init(
        id: UUID,
        countryCode: String,
        createdAt: Date?,
        email: String,
        firstName: String,
        lastName: String,
        phone: String,
        updatedAt: Date?
    ) {

        self.id = id
        self.countryCode = countryCode
        self.createdAt = createdAt
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.updatedAt = updatedAt
    }
}
