//
// Copyright © 2024 PinkTech. All rights reserved.
//

import Fluent
import FluentPostgresDriver
import UserDatabase
import XCTVapor

public extension Application {
    /// Returns a testable instance of the `Application`.
    func testableUserDatabase() throws -> Database {
        let databaseID = DatabaseID(string: "kounty-users-test")
        let databaseConfiguration = DatabaseConfigurationFactory.postgres(
            configuration: .init(
                hostname: Environment.get("DATABASE_HOST") ?? "localhost",
                port: 5432,//Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
                username: Environment.get("DATABASE_USERNAME") ?? "postgres",
                password: Environment.get("DATABASE_PASSWORD") ?? "123456",
                database: Environment.get("DATABASE_NAME") ?? databaseID.string,
                tls: .prefer(try .init(configuration: .clientDefault))
            )
        )
        
        
        migrations.add(UserMigration(), to: databaseID)
        
        databases.use(databaseConfiguration, as: databaseID)

        try autoRevert().wait()
        try autoMigrate().wait()

        return databases.database(databaseID, logger: Logger(label: #file), on: eventLoopGroup.next())!
    }
}
