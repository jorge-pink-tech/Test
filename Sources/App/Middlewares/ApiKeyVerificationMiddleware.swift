//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Vapor

/// A middleware that will validate/verify that the incoming
/// request is from a known source by checking for the
/// `x-api-key` header.
///
/// `Note`: Create and generate an api key by hashing the app identifier+a secret key?
struct ApiKeyVerificationMiddleware: AsyncMiddleware {
    // MARK: - Private Properties
    
    private let apiKey: String
    
    // MARK: Initializer
    
    /// Creates a new instance of the `ApiKeyVerificationMiddleware` with
    /// the given api key.
    ///
    /// - Parameter apiKey: The generated api key.
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    // MARK: AsyncMiddleware

    /// Called with each `Request` that passes through this middleware.
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        guard let apiKey = request.headers.first(name: "x-api-key"), apiKey == self.apiKey else {
            throw .abort(.unauthorized, reason: "No authorizado, la llave de autenticaciòn api no fue enviada.")
        }
        
        return try await next.respond(to: request)
    }
}
