//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Extensions
import Fluent
import Utility
import Vapor

/// A model representing a user within an application's domain. It defines the
/// properties and methods that a user object should have, and is used to interact
/// with the data storage system (e.g. a database).
public final class UserDTO: Model {
    /// The ID of the user.
    @ID(key: .id)
    public var id: UUID?
   
    /// The date when the user was created.
    @Timestamp(key: .string(CodingKeys.createdAt), on: .create)
    public var createdAt: Date?
    
    /// The identifier of the country.
    @Field(key: .string(CodingKeys.countryCode))
    public var countryCode: String
   
    /// The email of the user.
    @Field(key: .string(CodingKeys.email))
    public var email: String
   
    /// The first name of the user.
    @Field(key: .string(CodingKeys.firstName))
    public var firstName: String
   
    /// The last name of the user.
    @Field(key: .string(CodingKeys.lastName))
    public var lastName: String
   
    /// The phone of the user.
    @Field(key: .string(CodingKeys.phone.rawValue))
    public var phone: String
   
    /// The date when any of the user characteristics changed.
    @Timestamp(key: .string(CodingKeys.updatedAt.rawValue), on: .update)
    public var updatedAt: Date?
    
    /// Route to create and update an user in database
    public static let schema = "User"
    
    /// Allowable fields for the model.
    enum CodingKeys: String, CodingKey {
        case id
        case countryCode
        case createdAt
        case email
        case firstName
        case lastName
        case phone
        case status
        case updatedAt
    }

    // MARK: Initializers
    
    /// Creates a new instance of the `UserDTO`.
    public init() {}
    
    /// Creates a new instance of the `UserDTO`.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the user.
    ///   - countryCode: The identifier of the country.
    ///   - email: The email of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - phone: The phone of the user.
    public init(
        id: UUID? = nil,
        countryCode: String,
        email: String,
        firstName: String,
        lastName: String,
        phone: String
    ) {

        self.id = id
        self.countryCode = countryCode
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
    
    // MARK: Public methods
    
    /// Saves the user asynchronously.
    ///
    /// - Parameter database: The database connection on which to execute the operation.
    /// - Throws: An error if there's an issue with the database operation.
    /// - Note: This method overrides the default implementation of the `Model` protocol by adding
    /// extra functionally, like validating the existence of the model in order to update or create a record.
    public func save(on database: Database) async throws {
        do {
            guard id != nil else {
                try await validateExistence(on: database)
                try await create(on: database)
                
                return
            }
            
            try await update(on: database)
        } catch {
            throw error.asKountyError(or: UserDatabaseErrorReason.saveFailed)
        }
    }
    
    // MARK: Private methods
    
    private func validateExistence(on database: Database) async throws {
        let user = try await UserDTO.query(on: database)
            .group(.or) { group in
                group.filter(\.$email == email)
                    .filter(\.$phone == phone)
            }
            .first()
        
        guard let user else { return }
        
        if user.email == email {
            throw KountyError(
                kind: UserDatabaseErrorReason.emailTaken,
                failureReason: "El email se encuentra registrado."
            )
        }
        
        if user.phone == phone {
            throw KountyError(
                kind: UserDatabaseErrorReason.phoneIsRegistered,
                failureReason: "El telefono se encuentra registrado."
            )
        }
    }
}

extension UserDTO: Authenticatable {}
