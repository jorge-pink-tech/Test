//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Extensions
import Fluent
import Utility
import Vapor

/// A protocol that defines a repository responsible for data source retrieval.
public protocol AuthenticationCredentialRepository {
    /// Creates a new `AuthenticationCredential` for the specified user.
    ///
    /// This method allows the creation of an authentication credential for a specific user. The method
    /// takes in the necessary parameters and associates the newly created credential with the given `userId`.
    /// The operation is asynchronous and can throw an error if the creation fails.
    ///
    /// - Parameters:
    ///    - parameters: A `CreateAuthenticationCredentialParameters` object containing the necessary details for creating the
    ///                  authentication credential.
    ///    - userId: The id of the user owner of the data.
    /// - Returns: The newly created `AuthenticationCredential`.
    /// - Throws: An error if the credential creation fails.
    func create(
        _ parameters: CreateAuthenticationCredentialParameters,
        for userId: UUID
    ) async throws -> AuthenticationCredential

    /// Deletes an existing `AuthenticationCredential` for the specified user.
    ///
    /// This method allows the deletion of an authentication credential associated with a given `userId`.
    /// The credential is identified by its `UUID`. The operation is asynchronous and can throw an error if the
    /// deletion fails or if the credential does not exist.
    ///
    /// - Parameters:
    ///   - id: The `UUID` of the credential to be deleted.
    ///   - userId: The `UUID` of the user associated with the credential.
    /// - Throws: An error if the credential deletion fails or if the credential is not found.
    func delete(_ id: UUID, for userId: UUID) async throws

    /// Retrieves a list of `AuthenticationCredential` objects for the specified user and data source.
    ///
    /// This method retrieves all authentication credentials that are associated with a particular `userId` and
    /// `datasourceId`. The operation is asynchronous and can throw an error if the retrieval fails or if there are no
    /// credentials found for the given parameters.
    ///
    /// - Parameters:
    ///   - datasourceId: The `UUID` of the data source associated with the credentials.
    ///   - userId: The `UUID` of the user whose credentials are being retrieved.
    /// - Returns: An array of `AuthenticationCredential` objects associated with the given `userId` and `datasourceId`.
    /// - Throws: An error if the credential retrieval fails.
    func retrieve(for datasourceId: UUID, userId: UUID) async throws -> [AuthenticationCredential]
    
    /// Retrieves an `AuthenticationCredential` for a specific user and credential ID.
    ///
    /// This asynchronous method fetches the `AuthenticationCredential` associated with the given credential `id`
    /// and the corresponding `userId`. It performs the necessary query to retrieve the credential and throws an error
    /// if no matching credential is found or if the retrieval process fails.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the authentication credential to be retrieved.
    ///   - userId: The unique identifier of the user to whom the credential belongs.
    /// - Returns: An `AuthenticationCredential` object associated with the given credential `id` and `userId`.
    /// - Throws: An `AbortError`: If no matching credential is found or if the retrieval process encounters an issue.
    func show(_ id: UUID, for userId: UUID) async throws -> AuthenticationCredential

    /// Updates an existing `AuthenticationCredential` for the specified user.
    ///
    /// This method updates an authentication credential using the provided parameters. It associates the updated
    /// credential with the given `userId`. The operation is asynchronous and can throw an error if the update fails.
    ///
    /// - Parameters:
    ///    - parameters: An `UpdateAuthenticationCredentialParameters` object containing the necessary details for updating the
    ///                  authentication credential.
    ///    - id: The id of the authentication credential to update.
    ///    - userId: The id of the user owner of the data.
    /// - Returns: The updated `AuthenticationCredential
    func update(
        _ parameters: UpdateAuthenticationCredentialParameters,
        for id: UUID,
        userId: UUID
    ) async throws -> AuthenticationCredential
    
    /// Updates the status of an `AuthenticationCredential`.
    ///
    /// This asynchronous function is used to update the status of an `AuthenticationCredential` object.
    /// The method performs the update operation and can throw an error if the operation fails.
    ///
    /// - Parameters:
    ///    - parameters: An `UpdateAuthenticationCredentialParameters` object containing the necessary details for updating the
    ///                   authentication credential status.
    ///    - id: The id of the authentication credential to update.
    ///    - userId: The id of the user owner of the data.
    /// - Throws: An error if the update operation fails.
    func updateStatus(
        _ parameters: UpdateAuthenticationCredentialStatusParameters,
        for id: UUID,
        userId: UUID
    ) async throws
}

/// A concrete implementation of the `AuthenticationCredentialRepository`.
public class AuthenticationCredentialRepositoryImpl: AuthenticationCredentialRepository {
    // MARK: - Private Properties
            
    private let database: Database
    
    // MARK: Initializer
    
    /// Creates a new instance of the `AuthenticationRepositoryImpl`.
    ///
    /// - Parameter database: A object that defines the contract for the datasource database.
    public init(database: Database) {
        self.database = database
    }
    
    // MARK: AuthenticationCredentialRepository

    /// Creates a new `AuthenticationCredential` for the specified user.
    ///
    /// This method allows the creation of an authentication credential for a specific user. The method
    /// takes in the necessary parameters and associates the newly created credential with the given `userId`.
    /// The operation is asynchronous and can throw an error if the creation fails.
    ///
    /// - Parameters:
    ///    - parameters: A `CreateAuthenticationCredentialParameters` object containing the necessary details for creating the
    ///                  authentication credential.
    ///    - userId: The id of the user owner of the data.
    /// - Returns: The newly created `AuthenticationCredential`.
    /// - Throws: An error if the credential creation fails.
    public func create(
        _ parameters: CreateAuthenticationCredentialParameters,
        for userId: UUID
    ) async throws -> AuthenticationCredential {
        do {
            let datasource = try await DatasourceDTO.find(parameters.datasourceId, on: database)
                .unwrap(or: .abort(.notFound, reason: "El origen de datos no se encontro."))
            
            guard let status = AuthenticationCredentialDTO.Status(rawValue: parameters.status.rawValue) else {
                throw .abort(.notFound, reason: "El estatus para la credencial no es valido.")
            }
            
            let authenticationCredential = AuthenticationCredentialDTO(
                accessToken: parameters.accessToken,
                name: parameters.name,
                status: status,
                userId: userId,
                username: parameters.username
            )
            
            try await datasource.attach(authenticationCredential, on: database)
            
            return try AuthenticationCredential.from(authenticationCredential)
        } catch {
            throw error.toAbortError()
        }
    }

    /// Deletes an existing `AuthenticationCredential` for the specified user.
    ///
    /// This method allows the deletion of an authentication credential associated with a given `userId`.
    /// The credential is identified by its `UUID`. The operation is asynchronous and can throw an error if the
    /// deletion fails or if the credential does not exist.
    ///
    /// - Parameters:
    ///   - id: The `UUID` of the credential to be deleted.
    ///   - userID: The `UUID` of the user associated with the credential.
    /// - Throws: An error if the credential deletion fails or if the credential is not found.
    public func delete(_ id: UUID, for userId: UUID) async throws {
        do {
            try await AuthenticationCredentialDTO.find(id: id, for: userId, on: database)
                .delete(on: database)
        } catch {
            throw error.toAbortError()
        }
    }

    /// Retrieves a list of `AuthenticationCredential` objects for the specified user and data source.
    ///
    /// This method retrieves all authentication credentials that are associated with a particular `userId` and
    /// `datasourceId`. The operation is asynchronous and can throw an error if the retrieval fails or if there are no
    /// credentials found for the given parameters.
    ///
    /// - Parameters:
    ///   - datasourceId: The `UUID` of the data source associated with the credentials.
    ///   - userId: The `UUID` of the user whose credentials are being retrieved.
    /// - Returns: An array of `AuthenticationCredential` objects associated with the given `userId` and `datasourceId`.
    /// - Throws: An error if the credential retrieval fails.
    public func retrieve(for datasourceId: UUID, userId: UUID) async throws -> [AuthenticationCredential] {
        do {
            let datasource = try await DatasourceDTO.find(datasourceId, on: database)
                .unwrap(or: .abort(.notFound, reason: "El origen de datos no se encontro."))
            
            return try await datasource.$authenticationCredentials.query(on: database)
                .group(.and) { group in
                    group.filter(\.$deletedAt != nil)
                        .filter(\.$userId == userId)
                }
                .all()
                .map(AuthenticationCredential.from)
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Retrieves an `AuthenticationCredential` for a specific user and credential ID.
    ///
    /// This asynchronous method fetches the `AuthenticationCredential` associated with the given credential `id`
    /// and the corresponding `userId`. It performs the necessary query to retrieve the credential and throws an error
    /// if no matching credential is found or if the retrieval process fails.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the authentication credential to be retrieved.
    ///   - userId: The unique identifier of the user to whom the credential belongs.
    /// - Returns: An `AuthenticationCredential` object associated with the given credential `id` and `userId`.
    /// - Throws: An `AbortError`: If no matching credential is found or if the retrieval process encounters an issue.
    public func show(_ id: UUID, for userId: UUID) async throws -> AuthenticationCredential {
        do {
            let authenticationCredential = try await AuthenticationCredentialDTO.find(id: id, for: userId, on: database)
                
            return try AuthenticationCredential.from(authenticationCredential)
        } catch {
            throw error.toAbortError()
        }
    }

    /// Updates an existing `AuthenticationCredential` for the specified user.
    ///
    /// This method updates an authentication credential using the provided parameters. It associates the updated
    /// credential with the given `userId`. The operation is asynchronous and can throw an error if the update fails.
    ///
    /// - Parameters:
    ///    - parameters: An `UpdateAuthenticationCredentialParameters` object containing the necessary details for updating the
    ///                  authentication credential.
    ///    - id: The id of the authentication credential to update.
    ///    - userId: The id of the user owner of the data.
    /// - Returns: The updated `AuthenticationCredential
    public func update(
        _ parameters: UpdateAuthenticationCredentialParameters,
        for id: UUID,
        userId: UUID
    ) async throws -> AuthenticationCredential {
        do {
            let authenticationCredential = try await AuthenticationCredentialDTO.find(id: id, for: userId, on: database)
            
            authenticationCredential.name = parameters.name

            try await authenticationCredential.save(on: database)
            
            return try AuthenticationCredential.from(authenticationCredential)
        } catch {
            throw error.toAbortError()
        }
    }
    
    /// Updates the status of an `AuthenticationCredential`.
    ///
    /// This asynchronous function is used to update the status of an `AuthenticationCredential` object.
    /// The method performs the update operation and can throw an error if the operation fails.
    ///
    /// - Parameters:
    ///    - parameters: An `UpdateAuthenticationCredentialParameters` object containing the necessary details for updating the
    ///                   authentication credential status.
    ///    - userId: The id of the user owner of the data.
    /// - Throws: An error if the update operation fails.
    public func updateStatus(
        _ parameters: UpdateAuthenticationCredentialStatusParameters,
        for id: UUID,
        userId: UUID
    ) async throws {
        do {
            let authenticationCredential = try await AuthenticationCredentialDTO.find(id: id, for: userId, on: database)
            
            guard let status = AuthenticationCredentialDTO.Status(rawValue: parameters.status.rawValue) else {
                throw .abort(.badRequest, reason: "El estatus para la credencial es invalido.")
            }
            
            authenticationCredential.status = status

            try await authenticationCredential.save(on: database)
        } catch {
            throw error.toAbortError()
        }
    }
}

private extension ErrorReason {
    /// Returns the HTTP status code associated with the error reason.
    var statusCode: HTTPResponseStatus {
        switch self {
        case .DatasourceDatabaseErrorReason.accessTokenRequired:
            return .badRequest

        default:
            return .internalServerError
        }
    }
}

private extension Error {
    /// Casts the instance as `KountyAbortError` or returns a default one.
    func toAbortError() -> KountyAbortError {
        guard let error = self as? KountyError else {
            return asAbortError()
        }
        
        return error.asAbortError(error.kind.statusCode)
    }
}
