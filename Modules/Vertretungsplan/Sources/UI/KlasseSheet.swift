import SwiftUI

import VertretungsplanCore

public struct KlasseSheet: View {
    let klasse: Klasse
    let saveTapped: (Klasse) -> ()
    
    public init(klasse: Klasse, saveTapped: @escaping (Klasse) -> Void) {
        self.klasse = klasse
        self.saveTapped = saveTapped
    }
    
    @State var name = ""
    public var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        var klasse = klasse
                        klasse.name = name
                        saveTapped(klasse)
                    }) {
                        Text("Save")
                    }
                }
            }
        }
        .onAppear {
            name = klasse.name
        }
    }
}
