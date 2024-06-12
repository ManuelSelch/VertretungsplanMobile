import Foundation

public enum SettingsRoute: Identifiable, Codable {
    case settings
    case debug
    case log
    case admin
    
    public var id: Self {self}
}
