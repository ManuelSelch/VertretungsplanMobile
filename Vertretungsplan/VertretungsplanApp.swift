import SwiftUI
import Redux
import PulseLogHandler

@main
struct VertretungsplanApp: App {
    var store: StoreOf<AppFeature>
    
    init() {
        URLSessionProxyDelegate.enableAutomaticRegistration()
        
        store = .init(
            initialState: .init(),
            reducer: AppFeature(),
            middlewares: [
                MonitorMiddleware().handle
            ]
        )
    }
    var body: some Scene {
        WindowGroup {
            AppContainer(store: store)
                .scrollContentBackground(.hidden)
        }
    }
}
