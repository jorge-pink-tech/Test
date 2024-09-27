//
// Copyright © 2024 PinkTech. All rights reserved.
//

import AuthenticationApi
import Cognito
import Vapor

/// A controller that manages the user authentication process.
struct AuthenticationController: RouteCollection {
    // MARK: - Private Properties
    
    private let authenticationRepository: AuthenticationRepository

    // MARK: Initializer

    /// Creates a new instance of the `AuthenticationController` with
    /// the associated provider.
    ///
    /// - Parameter repository: The user origin datasource.
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }

    // MARK: Instance methods

    /// Update the password related to the user associated to the given username.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: A `KountyAbortError` if someting fails.
    func confirmForgotPassword(_ req: Request) async throws -> HTTPStatus {
        let parameters = try req.content.decode(ConfirmForgotPasswordParameters.self)
    
        try await authenticationRepository.confirmForgotPassword(parameters)

        return .created
    }

    /// Confirms the registration of the user associated to the given email.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: A `KountyAbortError` if someting fails.
    func confirmSignUp(_ req: Request) async throws -> HTTPStatus {
        let parameters = try req.content.decode(ConfirmSignUpParameters.self)
        
        try await authenticationRepository.confirmSignUp(parameters)

        return .noContent
    }

    /// Send a verification code to recover the password of the user associated
    /// to the given username.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: A `KountyAbortError` if someting fails.
    func forgotPassword(_ req: Request) async throws -> [String: String] {
        let parameters = try req.content.decode(ForgotPasswordParameters.self)
        
        try await authenticationRepository.forgotPassword(email: parameters.email)

        return ["message": "Se ha enviado un correo electrónico con las instrucciones correspondientes."]
    }
    
    /// Starts the Sign in process to authenticate an user
    /// with the provided information.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: An `Error` if an exception occurs.
    func signIn(req: Request) async throws -> Response {
        let parameters = try req.content.decode(SignInParameters.self)
        let session = try await authenticationRepository.signIn(parameters)

        return try await session.encodeResponse(status: .created, for: req)
    }

    /// Starts the Sign Up process by creating new user
    /// with the provided information.
    ///
    /// - Parameter req: The incoming HTTP request.
    /// - Throws: An `Error` if an exception occurs.
    func signUp(_ req: Request) async throws -> HTTPStatus {
        let parameters = try req.content.decode(SignUpParameters.self)
        
        try await authenticationRepository.signUp(parameters)
        
        return .created
    }

    // MARK: RouteCollection

    /// Registers routes to the incoming router.
    ///
    /// - Parameter routes: `RoutesBuilder` to register any new routes to.
    func boot(routes: RoutesBuilder) throws {
        routes.post("confirm-forgot-password", use: confirmForgotPassword)
        routes.post("confirm-sign-up", use: confirmSignUp)
        routes.post("forgot-password", use: forgotPassword)
        routes.post("sign-in", use: signIn)
        routes.post("sign-up", use: signUp)
    }
}
