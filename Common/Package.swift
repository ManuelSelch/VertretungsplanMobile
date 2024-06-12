// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CommonUI", targets: ["CommonUI"]),
        .library(name: "CommonServices", targets: ["CommonServices"]),
    ],
    
    targets: [
        .target(name: "CommonUI", path: "Sources/UI"),
        .target(name: "CommonServices", path: "Sources/Services")
    ]
)
