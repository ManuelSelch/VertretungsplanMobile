import Foundation
import Redux
import Combine

import VertretungsplanApp
import SettingsApp

struct AppFeature: Reducer {
    struct State: Equatable, Codable {
        var router: RouterFeature<Route>.State = .init(root: .vertretungsplan)
        
        var vertretungsplan: VertretungsplanFeature.State = .init()
        var settings: SettingsFeature.State = .init()
    }
    
    enum Action: Equatable, Codable {
        case router(RouterFeature<Route>.Action)
        case vertretungsplan(VertretungsplanFeature.Action)
        case settings(SettingsFeature.Action)
        
        case settingsTapped
    }
    
    enum Route: Equatable, Codable, Identifiable {
        case vertretungsplan
        case settings
        
        var id: Self {self}
    }
    
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
        case let .router(action):
            return RouterFeature<Route>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
        case let .vertretungsplan(action):
            return VertretungsplanFeature().reduce(&state.vertretungsplan, action)
                .map { .vertretungsplan($0) }
                .eraseToAnyPublisher()
        case let .settings(action):
            return SettingsFeature().reduce(&state.settings, action)
                .map { .settings($0) }
                .eraseToAnyPublisher()
            
        case .settingsTapped:
            state.router.presentSheet(.settings)
            return .none
        }
    }
}
