import Foundation
import Redux
import Dependencies
import Combine

import CommonServices
import SettingsCore
import SettingsServices

public struct SettingsFeature: Reducer {
    public init() {}
    
    @Dependency(\.admin) var admin
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var isLocalLog = UserDefaultService.isLocalLog
        var isAdmin = UserDefaultService.isAdmin
    
        var router: RouterFeature<SettingsRoute>.State = .init(root: .settings)
    }
    
    public enum Action: Codable, Equatable {
        case settings(SettingsAction)
        case admin(AdminAction)
        
        case localLocChanged(Bool)
        
        case router(RouterFeature<SettingsRoute>.Action)
    }
    
    public enum SettingsAction: Codable, Equatable {
        case debugTapped
        case logTapped
        case adminTapped
    }
    
    public enum AdminAction: Codable, Equatable {
        case loginTapped(_ username: String, _ password: String)
        case logoutTapped
        case updateStatus(Bool)
    }
    
    public func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action){
        case let .settings(action):
            switch(action){
            case .debugTapped:
                state.router.push(.debug)
            case .logTapped:
                state.router.push(.log)
            case .adminTapped:
                state.router.push(.admin)
            }
        
        case let .admin(action):
            switch(action) {
            case let .loginTapped(username, password):
                return .run { send in
                    let success = await self.admin.login(username: username, password: password)
                    if(success) {
                        send(.success(.admin(.updateStatus(true))))
                    } else {
                        send(.success(.admin(.updateStatus(false))))
                    }
                }
            case let .updateStatus(isAdmin):
                state.isAdmin = isAdmin
                UserDefaultService.isAdmin = isAdmin
            case .logoutTapped:
                state.isAdmin = false
                UserDefaultService.isAdmin = false
            }
            
        case let .localLocChanged(isLog):
            state.isLocalLog = isLog
            UserDefaultService.isLocalLog = isLog
        
        case let .router(action):
            return RouterFeature<SettingsRoute>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
        }
        
        return .none
    }
    
    
   
}

