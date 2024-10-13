//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import FluentPostgresDriver
import UserDatabase
import XCTVapor

extension Application {
    /// Returns a testable instance of the `Application`.
    public func testableUserDatabase() throws -> Database {
        let userDatabaseID = DatabaseID(string: "DatabaseId")        
        let databaseConfiguration = DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: Environment.get("DATABASE_PORT").flatMap(Int.init) ?? SQLPostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "postgres",
                password: Environment.get("DATABASE_PASSWORD") ?? "123456",
                database: Environment.get("DATABASE_NAME") ?? "test",
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        )
        
        migrations.add(CreateUserDatabaseMigration())
        databases.use(databaseConfiguration, as: userDatabaseID)

        try autoRevert().wait()
        try autoMigrate().wait()

        return databases.database(userDatabaseID, logger: Logger(label: #file), on: eventLoopGroup.next())!
    }
}
