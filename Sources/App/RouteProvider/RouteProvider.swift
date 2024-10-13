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
        let logger = Logger(label: "com.kounty.logger.database")
        let eventLoop = application.eventLoopGroup.next()
        let redisStorage = try await RedisStorage.make(hostname: Environment.get("DATABASE_HOST") ?? "localhost")
                
        guard let database = application.databases.database(logger: logger, on: eventLoop) else {
            return
        }
        
        guard let datasourceDatabase = application.databases.database(logger: logger, on: eventLoop) else {
            return
        }
        
        // Services
        let cognitoClient = CognitoClient(clientId: "5cjb30aes7v4tdcn4qnel3lf9v", poolId: "us-east-1_CTA9LEI3X")
        
        // Repositories
        let authenticationCredentialRepository = AuthenticationCredentialRepositoryImpl(database: datasourceDatabase)
        let datasourceRepository = DatasourceRepositoryImpl(datasourceDatabase: datasourceDatabase)
        let userRepository = UserRepositoryImpl(userDatabase: database)
        let authenticationRepository = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: database
        )

        // Controllers
        let authenticationController = AuthenticationController(authenticationRepository: authenticationRepository)
        let datasourceController = DatasourceController(datasourceRepository: datasourceRepository)
        let authenticationCredentialController = AuthenticationCredentialController(
            authenticationCredentialRepository: authenticationCredentialRepository
        )
        
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
        
        try authenticatedApi
            .grouped("datasources")
            .register(collection: datasourceController)

        try authenticatedApi
            .grouped("authentication-credentials")
            .register(collection: authenticationCredentialController)            
    }
}
