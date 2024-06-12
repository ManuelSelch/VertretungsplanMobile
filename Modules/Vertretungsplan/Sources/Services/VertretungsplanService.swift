import Foundation
import Moya
import Dependencies

import VertretungsplanCore

public struct VertretungsplanService {
    public var getLinks: () async throws -> (Vertretungsplan)
    public var setLinks: (Vertretungsplan) async throws -> ()
    
    public var getRechts: () async throws -> (Vertretungsplan)
    public var setRechts: (Vertretungsplan) async throws -> ()
}

extension VertretungsplanService {
    static var live: VertretungsplanService {
        let provider = MoyaProvider<VertretungenRequest>()
        
        return VertretungsplanService(
            getLinks: {
                return try await Network.request(provider, .getVertretungsplanLinks)
            },
            setLinks: {
                let _: Vertretungsplan = try await Network.request(provider, .setVertretungsplanLinks($0))
            },
            getRechts: {
                return try await Network.request(provider, .getVertretungsplanRechts)
            },
            setRechts: {
                let _: Vertretungsplan = try await Network.request(provider, .setVertretungsplanRechts($0))
            }
        )
    }
    
    static let mock = VertretungsplanService(
        getLinks: { return .sample },
        setLinks: { _ in },
        getRechts: { return .sample },
        setRechts: { _ in }
    )
}

struct VertretungsplanServiceKey: DependencyKey {
    static var liveValue = VertretungsplanService.live
    static var mockValue = VertretungsplanService.mock
}

public extension DependencyValues {
    var vertretungsplan: VertretungsplanService {
        get { Self[VertretungsplanServiceKey.self] }
        set { Self[VertretungsplanServiceKey.self] = newValue }
    }
}

