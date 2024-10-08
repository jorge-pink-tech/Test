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
        let databaseConfiguration = SQLPostgresConfiguration(
            hostname: Environment.get("DATABASE_HOST") ?? "",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "",
            password: Environment.get("DATABASE_PASSWORD") ?? "",
            database: Environment.get("DATABASE_NAME") ?? "",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
        
        application.databases.use(.postgres(configuration: databaseConfiguration), as: .psql)

        // Datasource migrations
        application.migrations.add(DatasourceEnumMigration())
        application.migrations.add(DatasourceMigration())
        
        // User Migrations
        application.migrations.add(UserMigration())

        try await application.autoMigrate()
    }
}
