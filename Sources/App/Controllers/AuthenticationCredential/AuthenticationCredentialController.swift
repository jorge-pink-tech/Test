//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceApi
import UserApi
import Vapor

/// A controller that manages the authentication credential CRUD process.
struct AuthenticationCredentialController: RouteCollection {
    // MARK: - Private Properties
    
    private let authenticationCredentialRepository: AuthenticationCredentialRepository

    // MARK: Initializer

    /// Creates a new instance of the `AuthenticationCredentialController` with
    /// the associated repository.
    ///
    /// - Parameter authenticationCredentialRepository: A repository that manages the authentication credential related data.
    init(authenticationCredentialRepository: AuthenticationCredentialRepository) {
        self.authenticationCredentialRepository = authenticationCredentialRepository
    }

    // MARK: Instance methods
    
    /// Creates a new `AuthenticationCredential` based on the provided request.
    ///
    /// This asynchronous method creates a new `AuthenticationCredential` for the authenticated user using the
    /// provided parameters. The request content is validated with `CreateAuthenticationCredentialParameters`,
    /// and the credential is created if validation succeeds. The created credential is then encoded into the
    /// response with a `.created` status upon success.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Returns: A `Response` object with the newly created `AuthenticationCredential` and a status of `.created`.
    /// - Throws: An error if something fails.
    func create(_ req: Request) async throws -> Response {
        try CreateAuthenticationCredentialParameters.validate(content: req)
        
        let user = try req.auth.require(User.self)
        let parameters = try req.content.decode(CreateAuthenticationCredentialParameters.self)
        let authenticationCredential = try await authenticationCredentialRepository.create(parameters, for: user.id)
        
        return try await authenticationCredential.encodeResponse(status: .created, for: req)
    }
    
    /// Retrieves a specific `AuthenticationCredential` for the authenticated user based on the provided request.
    ///
    /// This asynchronous method extracts the `id` of the `AuthenticationCredential` from the request parameters and
    /// the authenticated `User` from the request's authentication context. It then retrieves the corresponding
    /// `AuthenticationCredential` for the authenticated user by calling the repository. If the credential is not found
    /// or the user is not authenticated, it throws an error.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Returns: The `AuthenticationCredential` object associated with the provided `id` and authenticated user.
    /// - Throws: An error if something fails.
    func show(_ req: Request) async throws -> AuthenticationCredential {
        let id = try req.parameters.require("id", as: UUID.self)
        let user = try req.auth.require(User.self)
        
        return try await authenticationCredentialRepository.show(id, for: user.id)
    }
    
    /// Updates an `AuthenticationCredential` based on the provided request.
    ///
    /// This asynchronous method updates an `AuthenticationCredential` identified by the provided `id` in the
    /// request parameters. The request body is validated using `UpdateAuthenticationCredentialParameters`, and
    /// the update operation is performed only if the user is authenticated and authorized to perform the update.
    /// Upon successful update, the function returns a response with a `.noContent` status.
    ///
    /// - Parameter req: The HTTP request object containing the credential `id` in the parameters,
    ///                  the authenticated `User`, and the update data in the request body.
    /// - Returns: A `Response` object with a `.noContent` status indicating the update was successful without any content in the response.
    /// - Throws: an `AbortError`: If the required `id` parameter is missing or invalid. Other errors that can occur during credential
    ///           retrieval from the repository.
    func update(_ req: Request) async throws -> Response {
        try UpdateAuthenticationCredentialParameters.validate(content: req)
        
        let id = try req.parameters.require("id", as: UUID.self)
        let user = try req.auth.require(User.self)
        let parameters = try req.content.decode(UpdateAuthenticationCredentialParameters.self)
        
        _ = try await authenticationCredentialRepository.update(parameters, for: id, userId: user.id)
        
        return Response(status: .noContent)
    }
    
    /// Updates the status of an `AuthenticationCredential` based on the provided request.
    ///
    /// This asynchronous method updates the status of an `AuthenticationCredential` specified by its ID in the
    /// request parameters. It validates the request content using `UpdateAuthenticationCredentialStatusParameters`,
    /// ensures the user is authenticated, and updates the status accordingly. After a successful update, the function
    /// returns a response with a `.noContent` status.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Returns: A `Response` object with a status of `.noContent` indicating a successful update with no additional content.
    /// - Throws: an `AbortError`: If the required `id` parameter is missing or invalid. Other errors that can occur during credential
    ///           retrieval from the repository.
    func updateStatus(_ req: Request) async throws -> Response {
        try UpdateAuthenticationCredentialStatusParameters.validate(content: req)
        
        let id = try req.parameters.require("id", as: UUID.self)
        let user = try req.auth.require(User.self)
        let parameters = try req.content.decode(UpdateAuthenticationCredentialStatusParameters.self)
        
        _ = try await authenticationCredentialRepository.updateStatus(parameters, for: id, userId: user.id)
        
        return Response(status: .noContent)
    }

    // MARK: RouteCollection

    /// Registers routes to the incoming router.
    ///
    /// - Parameter routes: `RoutesBuilder` to register any new routes to.
    func boot(routes: RoutesBuilder) throws {
        routes.get(":id", use: show)
        routes.post(use: create)
        routes.put(":id", use: update)
        routes.put(":id", "status", use: updateStatus)
    }
}
