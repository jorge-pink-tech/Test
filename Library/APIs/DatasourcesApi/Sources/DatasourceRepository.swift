//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Extensions
import Fluent
import Utility
import Vapor

/// A protocol that defines a repository responsible for data source retrieval.
public protocol DatasourceRepository {
    /// Asynchronously retrieves data from the repository.
    ///
    /// This method should be implemented by conforming types to handle fetching or
    /// retrieving data from the associated data source. The method is `async`, meaning
    /// it supports asynchronous operations such as making network requests or database queries.
    ///
    /// - Returns: An array of `Datasource` objects retrieved from the data source.
    /// - Throws: An error if the data retrieval process fails.
    func retrieve() async throws -> [Datasource]
}

/// A concrete implementation of the `AuthenticationRepository`.
public class DatasourceRepositoryImpl: DatasourceRepository {
    // MARK: - Private Properties
            
    private let datasourceDatabase: Database
    
    // MARK: Initializer
    
    /// Creates a new instance of the `AuthenticationRepositoryImpl`.
    ///
    /// - Parameters:
    ///    - cognitoAuthenticatableClient: A type that  defines the user authentication with Amazon Cognito.
    ///    - datasourceDatabase: A object that defines the contract for the datasource database.
    public init(datasourceDatabase: Database) {
        self.datasourceDatabase = datasourceDatabase
    }
    
    // MARK: DatasourceRepository

    /// Asynchronously retrieves data from the repository.
    ///
    /// This method should be implemented by conforming types to handle fetching or
    /// retrieving data from the associated data source. The method is `async`, meaning
    /// it supports asynchronous operations such as making network requests or database queries.
    ///
    /// - Returns: An array of `Datasource` objects retrieved from the data source.
    /// - Throws: An error if the data retrieval process fails.
    public func retrieve() async throws -> [Datasource] {
        do {
            return try await DatasourceDTO.query(on: datasourceDatabase)
                .all()
                .map(Datasource.from)
        } catch {
            throw error.asAbortError()
        }
    }
}
