//
// Copyright © 2024 PinkTech. All rights reserved.
//

import DatasourceDatabase
import Extensions
import Fluent
import Vapor

/// A protocol that defines a repository responsible for data source retrieval.
public protocol DatasourceRepository {
    /// Retrieves an array of `Datasource` objects.
    ///
    /// This method is asynchronous and can throw an error if the retrieval fails. It returns a list of
    /// `Datasource` objects, representing the available data sources within the system.
    ///
    /// - Returns: An array of `Datasource` objects.
    /// - Throws: An error if the retrieval fails.
    func retrieve() async throws -> [Datasource]
}

/// A concrete implementation of the `AuthenticationRepository`.
public class DatasourceRepositoryImpl: DatasourceRepository {
    // MARK: - Private Properties
            
    private let datasourceDatabase: Database
    
    // MARK: Initializer
    
    /// Creates a new instance of the `AuthenticationRepositoryImpl`.
    ///
    /// - Parameter datasourceDatabase: A object that defines the contract for the datasource database.
    public init(datasourceDatabase: Database) {
        self.datasourceDatabase = datasourceDatabase
    }
    
    // MARK: DatasourceRepository

    /// Retrieves an array of `Datasource` objects.
    ///
    /// This method is asynchronous and can throw an error if the retrieval fails. It returns a list of
    /// `Datasource` objects, representing the available data sources within the system.
    ///
    /// - Returns: An array of `Datasource` objects.
    /// - Throws: An error if the retrieval fails.
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
