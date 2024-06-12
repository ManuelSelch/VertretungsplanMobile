import Foundation
import Combine
import Redux

import CommonServices
import VertretungsplanCore

public extension VertretungsplanFeature {
    func reduce(_ state: inout State, _ action: Action) -> AnyPublisher<Action, Error> {
        switch(action) {
        case .onAppear:
            state.isAdmin = UserDefaultService.isAdmin
            return .run { send in
                do {
                    let links = try await vertretungsplan.getLinks()
                    let rechts = try await vertretungsplan.getRechts()
                    send(.success(.setVertretungsplan(links, rechts)))
                } catch {
                    send(.failure(error))
                }
            }
        case let .setVertretungsplan(links, rechts):
            state.vertretungsplanLinks = links
            state.vertretungsplanRechts = rechts
            
        case let .vertretung(action):
            switch(action) {
            case let .editTapped(klasse, vertretung):
                state.router.presentSheet(.vertretung(klasse, vertretung))
                return .none
                
            case let .saveTapped(klasse, vertretung):
                state.router.dismiss()
                if let index = getVertretungIndex(state, klasse: klasse, vertretung: vertretung) { // update
                    switch(state.mode) {
                    case .links:
                        state.vertretungsplanLinks.klassen[klasse].vertretungen[index] = vertretung
                        let vertretungsplan = state.vertretungsplanLinks
                        return .run { send in
                            try? await self.vertretungsplan.setLinks(vertretungsplan)
                        }
                    case .rechts:
                        state.vertretungsplanRechts.klassen[klasse].vertretungen[index] = vertretung
                        let vertretungsplan = state.vertretungsplanRechts
                        return .run { send in
                            try? await self.vertretungsplan.setRechts(vertretungsplan)
                        }
                    }
                } else { // create
                    switch(state.mode) {
                    case .links:
                        state.vertretungsplanLinks.klassen[klasse].vertretungen.append(vertretung)
                        let vertretungsplan = state.vertretungsplanLinks
                        return .run { send in
                            try? await self.vertretungsplan.setLinks(vertretungsplan)
                        }
                    case .rechts:
                        state.vertretungsplanRechts.klassen[klasse].vertretungen.append(vertretung)
                        let vertretungsplan = state.vertretungsplanRechts
                        return .run { send in
                            try? await self.vertretungsplan.setRechts(vertretungsplan)
                        }
                    }
                }
                
            case let .deleteTapped(klasse, vertretung):
                state.router.dismiss()
                if let index = getVertretungIndex(state, klasse: klasse, vertretung: vertretung) {
                    switch(state.mode) {
                    case .links:
                        state.vertretungsplanLinks.klassen[klasse].vertretungen.remove(at: index)
                        let vertretungsplan = state.vertretungsplanLinks
                        return .run { send in
                            try? await self.vertretungsplan.setLinks(vertretungsplan)
                        }
                    case .rechts:
                        state.vertretungsplanRechts.klassen[klasse].vertretungen.remove(at: index)
                        let vertretungsplan = state.vertretungsplanRechts
                        return .run { send in
                            try? await self.vertretungsplan.setRechts(vertretungsplan)
                        }
                    }
                }
                
            case let .createTapped(klasse):
                var new = Vertretung.new
                
                let lastId: Int
                switch(state.mode) {
                case .links:
                    lastId = state.vertretungsplanLinks.klassen[klasse].vertretungen.last?.id ?? -1
                case .rechts:
                    lastId = state.vertretungsplanRechts.klassen[klasse].vertretungen.last?.id ?? -1
                }
                new.id = lastId + 1
                
                state.router.presentSheet(.vertretung(klasse, new))
                break
            }
            
        case let .klasse(action):
            switch(action) {
            case let .editTapped(klasse):
                state.router.presentSheet(.klasse(klasse))
                
            case let .saveTapped(klasse):
                state.router.dismiss()
                switch(state.mode) {
                case .links:
                    if let index = state.vertretungsplanLinks.klassen.firstIndex(where: { $0.id == klasse.id }) { // update
                        state.vertretungsplanLinks.klassen[index] = klasse
                    } else { // create
                        state.vertretungsplanLinks.klassen.append(klasse)
                    }
                    let vertretungsplan = state.vertretungsplanLinks
                    return .run { send in
                        try? await self.vertretungsplan.setLinks(vertretungsplan)
                    }
                case .rechts:
                    if let index = state.vertretungsplanRechts.klassen.firstIndex(where: { $0.id == klasse.id }) { // update
                        state.vertretungsplanRechts.klassen[index] = klasse
                    } else { // create
                        state.vertretungsplanRechts.klassen.append(klasse)
                    }
                    let vertretungsplan = state.vertretungsplanRechts
                    return .run { send in
                        try? await self.vertretungsplan.setLinks(vertretungsplan)
                    }
                }
            case .createTapped:
                var new = Klasse.new
                
                let lastId: Int
                switch(state.mode) {
                case .links:
                    lastId = state.vertretungsplanLinks.klassen.last?.id ?? -1
                case .rechts:
                    lastId = state.vertretungsplanRechts.klassen.last?.id ?? -1
                }
                new.id = lastId + 1
                
                state.router.presentSheet(.klasse(new))
                
            case let .deleteTapped(klasse):
                switch(state.mode) {
                case .links:
                    state.vertretungsplanLinks.klassen.removeAll(where: { $0.id == klasse.id })
                    let vertretungsplan = state.vertretungsplanLinks
                    return .run { send in
                        try? await self.vertretungsplan.setLinks(vertretungsplan)
                    }
                case .rechts:
                    state.vertretungsplanRechts.klassen.removeAll(where: { $0.id == klasse.id })
                    let vertretungsplan = state.vertretungsplanRechts
                    return .run { send in
                        try? await self.vertretungsplan.setRechts(vertretungsplan)
                    }
                }
            }
        case let .modeChanged(mode):
            state.mode = mode
            
        case let .router(action):
            return RouterFeature<Route>().reduce(&state.router, action)
                .map { .router($0) }
                .eraseToAnyPublisher()
        }
        
        return .none
    }
    
    
    func getVertretungIndex(_ state: State, klasse: Int, vertretung: Vertretung) -> Int? {
        let vertretungsplan: Vertretungsplan
        
        switch(state.mode){
        case .links:
            vertretungsplan = state.vertretungsplanLinks
        case .rechts:
            vertretungsplan = state.vertretungsplanRechts
        }
        
        if let klasseIndex = vertretungsplan.klassen.firstIndex(where: { $0.id == klasse}),
           let vertretungIndex = vertretungsplan.klassen[klasseIndex].vertretungen.firstIndex(where: {$0.id == vertretung.id}) {
                
            return vertretungIndex
            
            
        }
        
        return nil
        
    }
    
    
}
