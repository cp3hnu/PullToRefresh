// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PullToRefresh",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v10)
    ],
    products: [
        .library(name: "PullToRefresh", targets: ["PullToRefresh"])
    ],
    targets: [
        .target(name: "PullToRefresh", path: "PullToRefresh")
    ],
    swiftLanguageVersions: [.v5]
)
