//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceApi
import UserApi
import Vapor

/// A controller that manages the datasource CRUD process.
struct DatasourceController: RouteCollection {
    // MARK: - Private Properties
    
    private let authenticationCredentialRepository: AuthenticationCredentialRepository
    private let datasourceRepository: DatasourceRepository

    // MARK: Initializer

    /// Creates a new instance of the `DatasourceController` with
    /// the associated provider.
    ///
    /// - Parameters:
    ///    - authenticationCredentialRepository: A repository that manages the authentication credential related data.
    ///    - datasourceRepository: A repository that manages the datasources related data.
    init(
        authenticationCredentialRepository: AuthenticationCredentialRepository,
        datasourceRepository: DatasourceRepository
    ) {

        self.authenticationCredentialRepository = authenticationCredentialRepository
        self.datasourceRepository = datasourceRepository
    }

    // MARK: Instance methods

    /// Confirms the registration of the user associated to the given email.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: A `KountyAbortError` if someting fails.
    func retrieve(_ req: Request) async throws -> [Datasource] {
        try await datasourceRepository.retrieve()
    }
    
    /// Retrieves a list of `AuthenticationCredential` objects based on the provided request.
    ///
    /// This asynchronous method retrieves authentication credentials for a specified user and credential ID
    /// from the request parameters.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Returns: An array of `AuthenticationCredential` objects associated with the provided user and credential ID.
    /// - Throws: an `AbortError`: If the required `id` parameter is missing or invalid. Other errors that can occur during credential
    ///           retrieval from the repository.
    func retrieveCredentials(_ req: Request) async throws -> [AuthenticationCredential] {
        let id = try req.parameters.require("id", as: UUID.self)
        let user = try req.auth.require(User.self)
        
        return try await authenticationCredentialRepository.retrieve(for: id, userId: user.id)
    }

    // MARK: RouteCollection

    /// Registers routes to the incoming router.
    ///
    /// - Parameter routes: `RoutesBuilder` to register any new routes to.
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: retrieve)
        routes.get(":id", use: retrieveCredentials)
    }
}
