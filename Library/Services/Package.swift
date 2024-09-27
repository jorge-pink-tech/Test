// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "Cognito", targets: ["Cognito"]),
        .library(name: "CognitoTesting", targets: ["CognitoTesting"])
    ],
    dependencies: [
        .package(path: "../Core"),
        
        .package(url: "https://github.com/soto-project/soto-cognito-authentication-kit", from: "4.1.1"),
    ],
    targets: Target.allTargets
)

extension Target {
    static var allTargets: [Target] {
        [
            cognitoTargets()            
        ]
            .flatMap { $0 }
    }

    static func cognitoTargets() -> [Target] {
        [
            .target(
                name: "Cognito",
                dependencies: [
                    .product(name: "Extensions", package: "Core"),
                    .product(name: "Utility", package: "Core"),
                    
                    .product(name: "SotoCognitoAuthenticationKit", package: "soto-cognito-authentication-kit")
                ],
                path: "Cognito/Sources"
            ),
            .target(
                name: "CognitoTesting",
                dependencies: [
                    "Cognito"
                ],
                path: "Cognito/Testing"
            ),
            .testTarget(
                name: "CognitoTests",
                dependencies: [
                    "Cognito",
                ],
                path: "Cognito/Tests"
            )
        ]
    }
}
