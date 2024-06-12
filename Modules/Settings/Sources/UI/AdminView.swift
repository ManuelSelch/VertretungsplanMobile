import SwiftUI

import CommonUI

public struct AdminView: View {
    let isAdmin: Bool
    
    let loginTapped: (_ username: String, _ password: String) -> ()
    let logoutTapped: () -> ()
    
    @State var username = ""
    @State var password = ""
    
    public init(isAdmin: Bool, loginTapped: @escaping (_: String, _: String) -> Void, logoutTapped: @escaping () -> Void) {
        self.isAdmin = isAdmin
        self.loginTapped = loginTapped
        self.logoutTapped = logoutTapped
    }
    
    public var body: some View {
        Form {
            if(isAdmin) {
                Button("Logout", action: logoutTapped)
                    .foregroundStyle(Color.red)
                    
            } else {
                
                TextField("Username", text: $username)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    loginTapped(username, password)
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                
                
                
            }
        }
        .padding()
    }
}

#Preview {
    AdminView(
        isAdmin: false, 
        loginTapped: { _, _ in },
        logoutTapped: {}
    )
}

