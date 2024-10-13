//
// Copyright © 2024 PinkTech. All rights reserved.
//

import AuthenticationApi
import Cognito
import DatasourceApi
import Fluent
import RediStack
import Storage
import UserApi
import UserDatabase
import Vapor

/// The `RouteProvider` is responsible for setting up and registering API routes for the application.
/// It configures various middleware, repositories, and controllers necessary for the API endpoints.
struct RouteProvider {
    // MARK: - Private Properties
    
    private let logger = Logger(label: "com.kounty.logger.database")
    
    // MARK: - Properties
    
    let application: Application
    
    // MARK: Instance methods
    
    /// Registers the API routes and middleware for the application.
    ///
    /// This method sets up the required repositories, services, and middleware for the API.
    /// It registers routes for authentication and other future routes. The method also configures
    /// a Redis storage and connects to the user database.
    ///
    /// - Throws: An error if any route registration or service setup fails.
    func register() async throws {
        let eventLoop = application.eventLoopGroup.next()
                
        guard let database = application.databases.database(logger: logger, on: eventLoop) else {
            return
        }
        
        // Services
        let cognitoClient = CognitoClient(clientId: "5cjb30aes7v4tdcn4qnel3lf9v", poolId: "us-east-1_CTA9LEI3X")
        let redisStorage = try await RedisStorage.make(hostname: Environment.get("DATABASE_HOST") ?? "localhost")
        
        // Repositories
        let userRepository = UserRepositoryImpl(userDatabase: database)
        let authenticationRepository = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: database
        )

        // Controllers
        let authenticationController = AuthenticationController(authenticationRepository: authenticationRepository)

        // Routes
        let api = application
            .grouped("api")
            .grouped(ApiKeyVerificationMiddleware(apiKey: "SLe+eWZgrebIVGla0s/wp/GWOfy4EoBmBxkzz="))
        
        try api.register(collection: authenticationController)
        
        // Authenticated routes
        let authenticatedApi = api.grouped(
            AuthenticatorMiddleware(
                authenticationRepository: authenticationRepository,
                storage: redisStorage,
                userRepository: userRepository
            )
        )
        
        // Other Routes
        try registerDatasourceRoutes(on: authenticatedApi, logger: logger, eventLoop: eventLoop)
    }
    
    // MARK: Private methods
    
    private func registerDatasourceRoutes(
        on routesBuilder: RoutesBuilder,
        logger: Logger,
        eventLoop: EventLoop
    ) throws {
        
        guard let database = application.databases.database(.datasourceDatabaseId, logger: logger, on: eventLoop) else {
            return
        }
        
        // Repositories
        let authenticationCredentialRepository = AuthenticationCredentialRepositoryImpl(database: database)
        let datasourceRepository = DatasourceRepositoryImpl(datasourceDatabase: database)
        
        // Controllers
        let authenticationCredentialController = AuthenticationCredentialController(
            authenticationCredentialRepository: authenticationCredentialRepository
        )

        let datasourceController = DatasourceController(
            authenticationCredentialRepository: authenticationCredentialRepository,
            datasourceRepository: datasourceRepository
        )
        
        try routesBuilder
            .grouped("datasources")
            .register(collection: datasourceController)

        try routesBuilder
            .grouped("authentication-credentials")
            .register(collection: authenticationCredentialController)
    }
}
