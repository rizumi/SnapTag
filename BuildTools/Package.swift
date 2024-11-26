// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v14)],
    dependencies: [
        .package(url: "https://github.com/uber/mockolo", from: "2.1.1"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
