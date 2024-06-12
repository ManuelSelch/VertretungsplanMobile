import SwiftUI
import Redux

import VertretungsplanApp
import SettingsApp
import CommonUI

struct AppContainer: View {
    @ObservedObject var store: StoreOf<AppFeature>
    
    init(store: StoreOf<AppFeature>) {
        self.store = store
    }
    
    var body: some View {
        RouterView(store: store.lift(\.router, AppFeature.Action.router)) { route in
            VStack {
                switch(route) {
                case .vertretungsplan:
                    VertretungsplanContainer(store: store.lift(\.vertretungsplan, AppFeature.Action.vertretungsplan))
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    store.send(.settingsTapped)
                                }) {
                                    Image(systemName: "gearshape")
                                        .foregroundStyle(Color.contrast)
                                }
                            }
                        }
                case .settings:
                    SettingsContainer(store: store.lift(\.settings, AppFeature.Action.settings))
                }
            }
        }
    }
}

