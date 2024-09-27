//
// Copyright © 2024 PinkTech. All rights reserved.
//

import AuthenticationApi
import Storage
import UserApi
import Utility
import Vapor

/// Helper for creating authentication middleware using the Bearer authorization header.
struct AuthenticatorMiddleware: AsyncBearerAuthenticator {
    // MARK: - Private Properties
    
    private let authenticationRepository: AuthenticationRepository
    private let storage: XStorage
    private let userRepository: UserRepository

    // MARK: Initializer

    /// Creates a new instance of the `UserAuthenticatorMiddleware`.
    ///
    /// - Parameters:
    ///    - authenticationRepository: A repository that handle the authentication of the users.
    ///    - storage: A type that can convert itself into and out of an external representation.
    ///    - userRepository: A repository that handles the user related communication.
    init(authenticationRepository: AuthenticationRepository, storage: XStorage, userRepository: UserRepository) {
        self.authenticationRepository = authenticationRepository
        self.storage = storage
        self.userRepository = userRepository
    }

    // MARK: AsyncBearerAuthenticator

    /// Performs the `Authentication` process by checking the `BearerToken`.
    ///
    /// - Parameters:
    ///    - bearer: The bearer token.
    ///    - request: The incoming HTTP request.
    func authenticate(bearer: BearerAuthorization, for request: Request) async throws {
        guard let user = try await storage.read(CacheEntry.self, forKey: bearer.token) else {
            let accessTokenPayload = try await authenticationRepository.decode(bearer.token)
            let user = try await userRepository.find(by: accessTokenPayload.username)

            let cacheEntry = CacheEntry(user: user, expiration: accessTokenPayload.expiresIn)
            try await storage.write(cacheEntry, forKey: bearer.token)

            request.auth.login(user)
            return
        }
        
        guard user.expiration > Date.now else {
            throw KountyAbortError(reason: "El usuario no esta autenticado", status: .unauthorized)
        }
        
        request.auth.login(user.user)
   }
}

/// Represents an entry stored in the cache, containing user information and expiration date.
private struct CacheEntry: Decodable, Encodable {
    /// The user information stored in the cache entry.
    let user: User
    
    /// The expiration date of the cached data.
    let expiration: Date
}
