import Redux
import Dependencies
import Combine

import CommonServices
import VertretungsplanServices
import VertretungsplanCore

public struct VertretungsplanFeature: Reducer {
    public init() {}
    @Dependency(\.vertretungsplan) var vertretungsplan
    
    public struct State: Equatable, Codable {
        public init() {}
        
        var router: RouterFeature<Route>.State = .init(root: .vertretungen)
        
        var vertretungsplanLinks: Vertretungsplan = Vertretungsplan(datum: "", klassen: [])
        var vertretungsplanRechts: Vertretungsplan = Vertretungsplan(datum: "", klassen: [])
        
        var mode: VertretungsplanMode = .links
        
        var isAdmin = UserDefaultService.isAdmin
    }
    
    public enum Action: Equatable, Codable {
        case router(RouterFeature<Route>.Action)
        
        case onAppear
        case setVertretungsplan(_ links: Vertretungsplan, _ rechts: Vertretungsplan)
        
        case vertretung(VertretungAction)
        case klasse(KlasseAction)
        
        case modeChanged(VertretungsplanMode)
    }
    
    public enum VertretungsplanMode: Equatable, Codable {
        case links
        case rechts
    }
    
    public enum VertretungAction: Equatable, Codable {
        case editTapped(_ klasse: Int, Vertretung)
        case saveTapped(_ klasse: Int, Vertretung)
        case deleteTapped(_ klasse: Int, Vertretung)
        case createTapped(_ klasse: Int)
    }
    
    public enum KlasseAction: Equatable, Codable {
        case editTapped(Klasse)
        case saveTapped(Klasse)
        case deleteTapped(Klasse)
        case createTapped
    }
    
    public enum Route: Equatable, Codable, Identifiable, Hashable {
        case vertretungen
        
        case vertretung(_ klasse: Int, Vertretung)
        case klasse(Klasse)
        
        public var id: Self {self}
    }
    
   
}
