//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceApi
import Vapor

/// A controller that manages the user authentication process.
struct DatasourceController: RouteCollection {
    // MARK: - Private Properties
    
    private let datasourceRepository: DatasourceRepository

    // MARK: Initializer

    /// Creates a new instance of the `DatasourceController` with
    /// the associated provider.
    ///
    /// - Parameter datasourceRepository: The datasource origin datasource.
    init(datasourceRepository: DatasourceRepository) {
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

    // MARK: RouteCollection

    /// Registers routes to the incoming router.
    ///
    /// - Parameter routes: `RoutesBuilder` to register any new routes to.
    func boot(routes: RoutesBuilder) throws {
        routes.get(use: retrieve)
    }
}
