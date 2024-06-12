import Foundation
import Moya

import VertretungsplanCore

public enum VertretungenRequest {
    case getVertretungsplanLinks
    case setVertretungsplanLinks(Vertretungsplan)
    
    case getVertretungsplanRechts
    case setVertretungsplanRechts(Vertretungsplan)
}
 
extension VertretungenRequest: Moya.TargetType {
    public var task: Moya.Task {
        switch self {
        case .getVertretungsplanLinks, .getVertretungsplanRechts:
            return .requestPlain
        case let .setVertretungsplanLinks(vertretungsplan), let .setVertretungsplanRechts(vertretungsplan):
            return .requestData( (try? JSONEncoder().encode(vertretungsplan)) ?? Data() )
        }
    }
    

    public var headers: [String : String]? {
        return [
            "Content-Type": "application/json; charset=utf-8"
        ]
    }
    
    
    
    
    public var path: String {
        switch self {
        case .getVertretungsplanLinks, .setVertretungsplanLinks(_):
            return "/links"
        case .getVertretungsplanRechts, .setVertretungsplanRechts(_):
            return "/rechts"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getVertretungsplanLinks, .getVertretungsplanRechts:
            return .get
        case .setVertretungsplanLinks(_), .setVertretungsplanRechts(_):
            return .post
        }
    }
    
    public var baseURL: URL {
        return URL(string: "https://abi-backend.dev.manuelselch.de")!
    }
    
    var parameters: [String: Any] {
        return [:]
        
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
    
    
    var validate: Bool {
        switch self {
        default:
            return true
        }
    }
}
