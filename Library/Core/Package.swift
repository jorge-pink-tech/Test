// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Utility", targets: ["Utility"]),
    ],
    dependencies: [
        // 🗄 An ORM for SQL and NoSQL databases.
        .package(url: "https://github.com/vapor/fluent.git", from: "4.8.0"),
    ],
    targets: Target.allTargets
)

extension Target {
    static var allTargets: [Target] {
        [
            extensionsTargets(),
            utilityTargets()
        ]
            .flatMap { $0 }
    }
    
    static func extensionsTargets() -> [Target] {
        [
            .target(
                name: "Extensions",
                dependencies: [
                    "Utility",
                    
                    .product(name: "Fluent", package: "fluent"),
                ],
                path: "Extensions/Sources"
            ),
            .testTarget(
                name: "CoreTests",
                dependencies: [
                    "Extensions",
                ],
                path: "Tests"
            )
        ]
    }
    
    static func utilityTargets() -> [Target] {
        [
            .target(
                name: "Utility",
                dependencies: [
                    .product(name: "Fluent", package: "fluent"),                    
                ],
                path: "Utility/Sources"
            ),
        ]
    }
}
