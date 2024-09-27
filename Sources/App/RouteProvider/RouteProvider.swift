//
// Copyright © 2024 PinkTech. All rights reserved.
//

import AuthenticationApi
import Cognito
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
        let redisStorage = try await RedisStorage.make(hostname: Environment.get("DATABASE_HOST") ?? "localhost")
        
        guard let userDatabase = application.databases.database(
            .users,
            logger: Logger(label: "com.kounty.logger.user.database"),
            on: application.eventLoopGroup.next()
        ) else {
            return
        }
        
        // Services
        let cognitoClient = CognitoClient(clientId: "5cjb30aes7v4tdcn4qnel3lf9v", poolId: "us-east-1_CTA9LEI3X")
        
        // Repositories
        let userRepository = UserRepositoryImpl(userDatabase: userDatabase)
        let authenticationRepository = AuthenticationRepositoryImpl(
            cognitoAuthenticatableClient: cognitoClient,
            userDatabase: userDatabase
        )

        // Controllers
        let authenticationController = AuthenticationController(authenticationRepository: authenticationRepository)
        
        // Routes
        let api = application.grouped("api")
            .grouped(ApiKeyVerificationMiddleware(apiKey: "SLe+eWZgrebIVGla0s/wp/GWOfy4EoBmBxkzz="))
            .grouped(
                AuthenticatorMiddleware(
                    authenticationRepository: authenticationRepository,
                    storage: redisStorage,
                    userRepository: userRepository
                )
            )
        
        try api.register(collection: authenticationController)
        
        /*let countryRoutes = api.grouped("country")
        try countryRoutes.register(collection: countryController)*/
    }
}
