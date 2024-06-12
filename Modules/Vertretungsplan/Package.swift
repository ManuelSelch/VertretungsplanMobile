// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Vertretungsplan",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "VertretungsplanApp", targets: ["VertretungsplanApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/manuelselch/Dependencies", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3")),
        
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "VertretungsplanCore",
            path: "Sources/Core"
        ),
        
        .target(
            name: "VertretungsplanServices",
            dependencies: [
                "VertretungsplanCore",
                .product(name: "Moya", package: "Moya"),
            ],
            path: "Sources/Services"
        ),
        
        .target(
            name: "VertretungsplanUI",
            dependencies: [
                .product(name: "CommonUI", package: "Common"),
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "VertretungsplanApp",
            dependencies: [
                "VertretungsplanCore", "VertretungsplanServices", "VertretungsplanUI",
                .product(name: "CommonServices", package: "Common"),
                .product(name: "Redux", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies")
            ],
            path: "Sources/App"
        ),
        .testTarget(
            name: "VertretungsplanTests",
            dependencies: ["VertretungsplanApp"]
        ),
    ]
)
