import SwiftUI

public struct SettingsView: View {
    
    let debugTapped: () -> ()
    let logTapped: () -> ()
    let adminTapped: () -> ()
    
    public init(debugTapped: @escaping () -> Void, logTapped: @escaping () -> Void, adminTapped: @escaping () -> Void) {
        self.debugTapped = debugTapped
        self.logTapped = logTapped
        self.adminTapped = adminTapped
    }
    
    public var body: some View {
        VStack {
            List {
                Button("Debug", action: { debugTapped() })
                Button("Log", action: { logTapped() })
                Button("Admin", action: { adminTapped() })
            }
        }
    }
}

