// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OutHere",
    platforms: [
        // NavigationStack and other APIs used in the project require iOS 16
        // and macOS 13 or newer.
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "OutHere", targets: ["OutHere"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.15.0")
    ],
    targets: [
        .executableTarget(
            name: "OutHere",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ],
            path: "Sources"
        )
    ]
)
