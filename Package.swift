// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "kounty-api",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        .package(path: "Library/APIs"),
        .package(path: "Library/DataAccess"),
        .package(path: "Library/Services"),
        
        // ⚠️ A tool to enforce Swift style and conventions.
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0"),
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
        // 🐘 Fluent driver for Postgres.
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/redis.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "AuthenticationApi", package: "APIs"),
                .product(name: "UserApi", package: "APIs"),
            
                .product(name: "Cognito", package: "Services"),
                                
                .product(name: "Storage", package: "DataAccess"),
                
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Redis", package: "redis"),                
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")
            ]
        ),
        .testTarget(name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),

            // Workaround for https://github.com/apple/swift-package-manager/issues/6940
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "Fluent"),
            .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
        ])
    ]
)
