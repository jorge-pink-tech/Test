//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import UserDatabase
import Utility
import Vapor

/// A repository that handle the states.
public protocol UserRepository {
    /// Retrieve all the information related to the user.
    ///
    /// - Parameter email: The email of the user.
    /// - Returns: The `User` that matches the provided email.
    /// - Throws: A `KountyAbortError`  if the user is not found.
    func find(by email: String) async throws -> User
}

/// A concrete implementation of the `UserRepository`.
public class UserRepositoryImpl: UserRepository {
    /// A object that defines the contract for the user database.
    private let userDatabase: Database
    
    // MARK: Initializers
    
    /// Creates a new instance of the `UserRepositoryImpl`.
    ///
    /// - Parameter userDataAccess: A object that defines the contract for the user database.
    public init(userDatabase: Database) {
        self.userDatabase = userDatabase
    }
    
    // MARK: UserRepository

    /// Retrieve all the information related to the user.
    ///
    /// - Parameter email: The email of the user.
    /// - Returns: The `User` that matches the provided email.
    /// - Throws: A `KountyAbortError`  if the user is not found.
    public func find(by email: String) async throws -> User {
        do {
            guard let user = try await UserDTO.query(on: userDatabase)
                .filter(\.$email == email)
                .first() else {

                throw KountyAbortError(reason: "Usuario no encontrado", status: .notFound)
            }

            return try .from(user)
        } catch let error as KountyError {
            throw error.asAbortError(.internalServerError)
        } catch {
            throw error.asAbortError()
        }
    }
}
