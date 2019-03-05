// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rover",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/tuist/xcodeproj.git", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/nsomar/Guaka.git", from: "0.3.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "rover",
            dependencies: ["xcodeproj", "Guaka"]),
        .testTarget(
            name: "roverTests",
            dependencies: ["rover"]),
    ]
)
