//
// Copyright © 2024 PinkTech. All rights reserved.
//

import AuthenticationApi
import Cognito
import DatasourceApi
import DatasourceDatabase
import Fluent
import FluentPostgresDriver
import Foundation
import NIOSSL
import Storage
import UserDatabase
import Vapor

extension DatabaseID {
    /// The ID for the datasource database.
    static let datasourceDatabaseId = DatabaseID(string: "datasource-database")
}

/// The `AppBootstrapper` is responsible for setting up and initializing the necessary configurations
/// and services needed to bootstrap the application, such as connecting to the database and running migrations.
struct AppBootstrapper {
    // MARK: - Properties
    
    let application: Application
    
    // MARK: Instance methods
    
    /// Bootstraps the application by configuring the database and running migrations.
    ///
    /// This method sets up the database connection using environment variables for the database
    /// host, port, username, password, and name. It also configures TLS for the database connection.
    /// After configuring the database, the method runs any pending database migrations.
    ///
    /// - Throws: An error if the database configuration or migrations fail.
    func bootstrap() async throws {
        // uncomment to serve files from /Public folder
        // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
        let defaultPortNumber = SQLPostgresConfiguration.ianaPortNumber
        let databaseConfiguration = SQLPostgresConfiguration(
            hostname: Environment.get("DATABASE_HOST") ?? "",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? defaultPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "",
            password: Environment.get("DATABASE_PASSWORD") ?? "",
            database: Environment.get("DATABASE_NAME") ?? "",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
        
        let datasourceDatabaseConfiguration = SQLPostgresConfiguration(
            hostname: Environment.get("DATASOURCE_DATABASE_HOST") ?? "",
            port: Environment.get("DATASOURCE_DATABASE_PORT").flatMap(Int.init) ?? defaultPortNumber,
            username: Environment.get("DATASOURCE_DATABASE_USERNAME") ?? "",
            password: Environment.get("DATASOURCE_DATABASE_PASSWORD") ?? "",
            database: Environment.get("DATASOURCE_DATABASE_NAME") ?? "",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
        
        application.databases.use(.postgres(configuration: databaseConfiguration), as: .psql)
        application.databases.use(.postgres(configuration: datasourceDatabaseConfiguration), as: .datasourceDatabaseId)

        // Datasource migrations
        application.migrations.add(CreateDatasourceDatabaseMigration())
        
        // User Migrations
        application.migrations.add(CreateUserDatabaseMigration())

        try await application.autoMigrate()
    }
}
