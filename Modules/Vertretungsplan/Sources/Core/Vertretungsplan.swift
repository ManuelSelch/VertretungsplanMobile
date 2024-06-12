import Foundation

public struct Vertretungsplan: Codable, Equatable, Hashable {
    public var datum: String
    public var klassen: [Klasse]
    
    public init(datum: String, klassen: [Klasse]) {
        self.datum = datum
        self.klassen = klassen
    }
}

extension Vertretungsplan {
    public static let new = Vertretungsplan(datum: "", klassen: [])
    public static let sample = Vertretungsplan(datum: "1.1.2024 Montag (Seite 1/3)", klassen: [Klasse.sample])
}


public struct Klasse: Codable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var vertretungen: [Vertretung]
}

extension Klasse {
    public static let sample = Klasse(id: 0, name: "6e", vertretungen: [Vertretung.sample])
    public static let new = Klasse(id: -1, name: "", vertretungen: [])
}

public struct Vertretung: Codable, Equatable, Hashable {
    public var id: Int
    
    public var stunde: String
    public var lehrkraft: String
    public var fach: String
    public var raum: String
    public var vertreter: String
    public var fach2: String
    public var raum2: String
    public var art: String
    public var bemerkungen: String
}

extension Vertretung {
    public static let sample = Vertretung(id: 0, stunde: "1", lehrkraft: "Her Müller", fach: "D", raum: "W05", vertreter: "Frau Müller", fach2: "Ma", raum2: "--", art: "Vertretung", bemerkungen: "--")
    public static let new = Vertretung(id: -1, stunde: "", lehrkraft: "", fach: "", raum: "", vertreter: "", fach2: "", raum2: "", art: "", bemerkungen: "")
}
