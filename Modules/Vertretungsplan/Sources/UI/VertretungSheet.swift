import SwiftUI

import VertretungsplanCore

public struct VertretungSheet: View {
    let vertretung: Vertretung
    let saveTapped: (Vertretung) -> ()
    
    @State var stunde = ""
    @State var lehrkraft = ""
    @State var fach = ""
    @State var raum = ""
    @State var vertreter = ""
    @State var fach2 = ""
    @State var raum2 = ""
    @State var art = ""
    @State var bemerkungen = ""
    
    public init(vertretung: Vertretung, saveTapped: @escaping (Vertretung) -> ()) {
        self.vertretung = vertretung
        self.saveTapped = saveTapped
    }
    
    public var body: some View {
        NavigationStack {
            Form {
                TextField("Stunde", text: $stunde)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Lehrkraft", text: $lehrkraft)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Fach", text: $fach)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Raum", text: $raum)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Vertreter", text: $vertreter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Fach2", text: $fach2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Raum2", text: $raum2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Art", text: $art)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Bemerkungen", text: $bemerkungen)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .onAppear {
                stunde = vertretung.stunde
                lehrkraft = vertretung.lehrkraft
                fach = vertretung.fach
                raum = vertretung.raum
                vertreter = vertretung.vertreter
                fach2 = vertretung.fach2
                raum2 = vertretung.raum2
                art = vertretung.art
                bemerkungen = vertretung.bemerkungen
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        var vertretung = vertretung
                        vertretung.stunde = stunde
                        vertretung.lehrkraft = lehrkraft
                        vertretung.fach = fach
                        vertretung.raum = raum
                        vertretung.vertreter = vertreter
                        vertretung.fach2 = fach2
                        vertretung.raum2 = raum2
                        vertretung.art = art
                        vertretung.bemerkungen = bemerkungen
                        saveTapped(vertretung)
                    }) {
                        Text("Save")
                    }
                }
            }
        }
    }
}

#Preview {
    VertretungSheet(vertretung: .sample, saveTapped: {_ in })
}
