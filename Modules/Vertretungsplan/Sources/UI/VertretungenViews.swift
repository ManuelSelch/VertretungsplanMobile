import SwiftUI
import CommonUI

import VertretungsplanCore

public struct VertretungenViews: View {
    let vertretungsplan: Vertretungsplan
    let isAdmin: Bool
    
    let vertretungEditTapped: (_ klasse: Int, Vertretung) -> ()
    let vertretungDeleteTapped: (_ klasse: Int, Vertretung) -> ()
    let vertretungAddTapped: (_ klasse: Int) -> ()
    
    let klasseEditTapped: (Klasse) -> ()
    let klasseDeleteTapped: (Klasse) -> ()
    let klasseAddTapped: () -> ()
    
    let syncTapped: () -> ()
    
    public init(vertretungsplan: Vertretungsplan, isAdmin: Bool, vertretungEditTapped: @escaping (_: Int, Vertretung) -> Void, vertretungDeleteTapped: @escaping (_: Int, Vertretung) -> Void, vertretungAddTapped: @escaping (_: Int) -> Void, klasseEditTapped: @escaping (Klasse) -> Void, klasseDeleteTapped: @escaping (Klasse) -> Void, klasseAddTapped: @escaping () -> Void, syncTapped: @escaping () -> Void) {
        self.vertretungsplan = vertretungsplan
        self.isAdmin = isAdmin
        self.vertretungEditTapped = vertretungEditTapped
        self.vertretungDeleteTapped = vertretungDeleteTapped
        self.vertretungAddTapped = vertretungAddTapped
        self.klasseEditTapped = klasseEditTapped
        self.klasseDeleteTapped = klasseDeleteTapped
        self.klasseAddTapped = klasseAddTapped
        self.syncTapped = syncTapped
    }
    
    public var body: some View {
        List {
            ForEach(vertretungsplan.klassen, id: \.self) { klasse in
     
                HStack {
                    Text(klasse.name)
                        .bold()
                    Spacer()
                    Button(action: {
                        vertretungAddTapped(klasse.id)
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.contrast)
                    }
                    .buttonStyle(.borderless)
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        klasseDeleteTapped(klasse)
                    } label: {
                        Text("Delete")
                            .foregroundColor(.white)
                    }
                    .disabled(!isAdmin)
                    .tint(.red)
                    
                    Button(role: .cancel) {
                        klasseEditTapped(klasse)
                    } label: {
                        Text("Edit")
                            .foregroundColor(.white)
                    }
                    .disabled(!isAdmin)
                    .tint(.gray)
                }
                
                ForEach(klasse.vertretungen, id: \.self) { vertretung in
                    HStack {
                        //Text(klasse.klasse)
                        Text(vertretung.stunde)
                        
                        Text(vertretung.lehrkraft)
                        Text(vertretung.fach)
                        
                        /*Text(vertretung.raum)
                         Text(vertretung.vertreter)
                         Text(vertretung.fach2)
                         Text(vertretung.raum2)*/
                        
                        Spacer()
                        
                        Text(vertretung.art)
                        // Text(vertretung.bemerkungen)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            vertretungDeleteTapped(klasse.id, vertretung)
                        } label: {
                            Text("Delete")
                                .foregroundColor(.white)
                        }
                        .disabled(!isAdmin)
                        .tint(.red)
                        
                        Button(role: .cancel) {
                            vertretungEditTapped(klasse.id, vertretung)
                        } label: {
                            Text("Edit")
                                .foregroundColor(.white)
                        }
                        .disabled(!isAdmin)
                        .tint(.gray)
                    }
                }
                
                
            }
            
        }
        .padding()
        .navigationTitle("Vertretungen")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button(action: {
                        syncTapped()
                    }) {
                        Image(systemName: "arrow.circlepath")
                            .foregroundStyle(Color.contrast)
                    }
                    
                    Button(action: {
                        klasseAddTapped()
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.contrast)
                    }
                }
            }
        }
    }
}

