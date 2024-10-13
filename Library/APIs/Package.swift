// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIs",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "AuthenticationApi", targets: ["AuthenticationApi"]),
        .library(name: "DatasourceApi", targets: ["DatasourceApi"]),
        .library(name: "UserApi", targets: ["UserApi"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../DataAccess"),
        .package(path: "../Services"),

        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
    ],
    targets: Target.allTargets
)

extension Target {
    static var allTargets: [Target] {
        [
            authenticationApiTargets(),
            datasourceApiTargets(),
            userApiTargets()
        ]
            .flatMap { $0 }
    }
    
    static func authenticationApiTargets() -> [Target] {
        [
            .target(
                name: "AuthenticationApi",
                dependencies: [
                    .product(name: "Cognito", package: "Services"),
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "UserDatabase", package: "DataAccess"),
                    .product(name: "Utility", package: "Core"),
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "AuthenticationApi/Sources"
            ),
            .testTarget(
                name: "AuthenticationApiTests",
                dependencies: [
                    "AuthenticationApi",
                    
                    .product(name: "UserDatabaseTesting", package: "DataAccess"),
                    
                    .product(name: "Cognito", package: "Services"),
                    .product(name: "CognitoTesting", package: "Services"),
                    
                    .product(name: "XCTVapor", package: "vapor"),
                ],
                path: "AuthenticationApi/Tests"
            )
        ]
    }
    
    static func datasourceApiTargets() -> [Target] {
        [
            .target(
                name: "DatasourceApi",
                dependencies: [
                    .product(name: "DatasourceDatabase", package: "DataAccess"),
                    
                    .product(name: "Utility", package: "Core"),
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "DatasourcesApi/Sources"
            ),
            .testTarget(
                name: "DatasourceApiTests",
                dependencies: [
                    "DatasourceApi",
                    
                    .product(name: "XCTVapor", package: "vapor"),
                ],
                path: "DatasourcesApi/Tests"
            )
        ]
    }
    
    static func userApiTargets() -> [Target] {
        [
            .target(
                name: "UserApi",
                dependencies: [
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "UserDatabase", package: "DataAccess"),
                    .product(name: "Vapor", package: "vapor"),
                ],
                path: "UserApi/Sources"
            ),
            .testTarget(
                name: "UserApiTests",
                dependencies: [
                    "UserApi",
                    
                    .product(name: "UserDatabase", package: "DataAccess"),
                    .product(name: "UserDatabaseTesting", package: "DataAccess"),
                    
                    .product(name: "XCTVapor", package: "vapor"),
                ],
                path: "UserApi/Tests"
            )
        ]
    }
}
