import SwiftUI

public struct DebugView: View {
    @Binding var isLocalLog: Bool
    
    public init(isLocalLog: Binding<Bool>) {
        self._isLocalLog = isLocalLog
    }
    
    public var body: some View {
        List {
            Section("General") {
                Toggle("Local Log", isOn: $isLocalLog)
            }
        }
        .listStyle(SidebarListStyle())
        .padding()
    }
}

