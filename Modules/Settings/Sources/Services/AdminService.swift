import Foundation
import Dependencies

public struct AdminService {
    var _login: (_ username: String, _ password: String) async -> (Bool)
    
    public func login(username: String, password: String) async -> Bool {
        return await _login(username, password)
    }
}

extension AdminService {
    static let live = AdminService(
        _login: { username, password in
            return (username == "username") && (password == "password")
        }
    )
    
    static let mock = AdminService(
        _login: {_, _ in return true}
    )
}

struct AdminServiceKey: DependencyKey {
    static var liveValue = AdminService.live
    static var mockValue = AdminService.mock
}

public extension DependencyValues {
    var admin: AdminService {
        get { Self[AdminServiceKey.self] }
        set { Self[AdminServiceKey.self] = newValue }
    }
}
