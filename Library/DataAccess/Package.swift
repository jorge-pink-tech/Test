// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataAccess",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "DatasourceDatabase", targets: ["DatasourceDatabase"]),
        .library(name: "DatasourceDatabaseTesting", targets: ["DatasourceDatabaseTesting"]),
        
        .library(name: "Storage", targets: ["Storage"]),
        .library(name: "StorageTesting", targets: ["StorageTesting"]),
        
        .library(name: "UserDatabase", targets: ["UserDatabase"]),
        .library(name: "UserDatabaseTesting", targets: ["UserDatabaseTesting"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        
        // 🫙 A Key/Value storage.
        .package(url: "https://github.com/swift-server/RediStack.git", from: "1.4.1"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2")
    ],
    targets: Target.allTargets
)

extension Target {
    static var allTargets: [Target] {
        [
            datasourceDatabaseTargets(),
            storageTargets(),
            userDatabaseTargets()
        ]
            .flatMap { $0 }
    }
    
    static func datasourceDatabaseTargets() -> [Target] {
        [
            .target(
                name: "DatasourceDatabase",
                dependencies: [
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "Utility", package: "Core"),
                    
                    .product(name: "Fluent", package: "fluent"),
                    .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "DatasourceDatabase/Sources"
            ),
            .target(
                name: "DatasourceDatabaseTesting",
                dependencies: [
                    "DatasourceDatabase",
                    
                    .product(name: "Utility", package: "Core"),
                    .product(name: "Fluent", package: "fluent"),
                ],
                path: "DatasourceDatabase/Testing"
            ),
            .testTarget(
                name: "DatasourceDatabaseTests",
                dependencies: [
                    "DatasourceDatabase",
                ],
                path: "DatasourceDatabase/Tests"
            )
        ]
    }

    static func storageTargets() -> [Target] {
        [
            .target(
                name: "Storage",
                dependencies: [
                    .product(name: "RediStack", package: "RediStack"),
                    
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "Utility", package: "Core"),
                ],
                path: "Storage/Sources"
            ),
            .target(
                name: "StorageTesting",
                dependencies: [
                    "Storage",

                    .product(name: "RediStack", package: "RediStack"),

                    .product(name: "Utility", package: "Core"),
                ],
                path: "Storage/Testing"
            ),
            .testTarget(
                name: "StorageTests",
                dependencies: [
                    "Storage",

                    .product(name: "RediStack", package: "RediStack"),
                ],
                path: "Storage/Tests"
            )
        ]
    }
    
    static func userDatabaseTargets() -> [Target] {
        [
            .target(
                name: "UserDatabase",
                dependencies: [
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "Utility", package: "Core"),
                    
                    .product(name: "Fluent", package: "fluent"),
                    .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "UserDatabase/Sources"
            ),
            .target(
                name: "UserDatabaseTesting",
                dependencies: [
                    "UserDatabase",
                    
                    .product(name: "Utility", package: "Core"),
                    .product(name: "Fluent", package: "fluent"),
                ],
                path: "UserDatabase/Testing"
            ),
            .testTarget(
                name: "UserDatabaseTests",
                dependencies: [
                    "UserDatabase",
                ],
                path: "UserDatabase/Tests"
            )
        ]
    }
}
