import SwiftUI
import Redux
import Dependencies

import VertretungsplanCore
import VertretungsplanUI

public struct VertretungsplanContainer: View {
    @ObservedObject var store: StoreOf<VertretungsplanFeature>
    
    public init(store: StoreOf<VertretungsplanFeature>) {
        self.store = store
    }
    
    var vertretungsplan: Vertretungsplan {
        switch(store.state.mode) {
        case .links:
            return store.state.vertretungsplanLinks
        case .rechts:
            return store.state.vertretungsplanRechts
        }
    }
    
    public var body: some View {
        RouterView(store: store.lift(\.router, VertretungsplanFeature.Action.router)) { route in
            VStack {
                switch(route){
                case .vertretungen:
                    VStack {
                        Picker("Mode", selection: store.binding(for: \.mode, action: VertretungsplanFeature.Action.modeChanged)) {
                            Text("Heute")
                                .tag(VertretungsplanFeature.VertretungsplanMode.links)
                            Text("Morgen")
                                .tag(VertretungsplanFeature.VertretungsplanMode.rechts)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                        .labelsHidden()
                        
                        VertretungenViews(
                            vertretungsplan: vertretungsplan,
                            isAdmin: store.state.isAdmin,
                            
                            vertretungEditTapped: { store.send(.vertretung(.editTapped($0, $1))) },
                            vertretungDeleteTapped: { store.send(.vertretung(.deleteTapped($0, $1))) },
                            vertretungAddTapped: { store.send(.vertretung(.createTapped($0))) },
                            
                            klasseEditTapped: { store.send(.klasse(.editTapped($0))) },
                            klasseDeleteTapped: { store.send(.klasse(.deleteTapped($0))) },
                            klasseAddTapped: { store.send(.klasse(.createTapped)) },
                            
                            syncTapped: { store.send(.onAppear) }
                        )
                    }
                case let .vertretung(klasse, vertretung):
                    VertretungSheet(vertretung: vertretung, saveTapped: { store.send(.vertretung(.saveTapped(klasse, $0))) })
                    
                case let .klasse(klasse):
                    KlasseSheet(
                        klasse: klasse,
                        saveTapped: { store.send(.klasse(.saveTapped($0))) }
                    )
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
       
    }
}


#Preview {
    DependencyValues.mode = .mock
    
    return VertretungsplanContainer(
        store: .init(initialState: .init(),
        reducer: VertretungsplanFeature())
    )
}
