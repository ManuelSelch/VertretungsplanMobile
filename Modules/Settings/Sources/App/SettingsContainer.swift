import SwiftUI
import Redux

import SettingsUI

public struct SettingsContainer: View {
    @ObservedObject var store: StoreOf<SettingsFeature>
    
    public init(store: StoreOf<SettingsFeature>) {
        self.store = store
    }

    public var body: some View {
        RouterView(store: store.lift(\.router, SettingsFeature.Action.router)) { route in
            VStack {
                switch(route) {
                case .settings:
                    SettingsView(
                        debugTapped: { store.send(.settings(.debugTapped)) },
                        logTapped: { store.send(.settings(.logTapped)) },
                        adminTapped: { store.send(.settings(.adminTapped)) }
                    )
                case .debug:
                    DebugView(
                        isLocalLog: store.binding(for: \.isLocalLog, action: SettingsFeature.Action.localLocChanged)
                    )
                case .log:
                    LogView()
                    
                case .admin:
                    AdminView(
                        isAdmin: store.state.isAdmin,
                        loginTapped: { store.send(.admin(.loginTapped($0, $1))) },
                        logoutTapped: { store.send(.admin(.logoutTapped)) }
                    )
                }
            }
        }
    }
}
