//
//  LoginView.swift
//  CapstoneChaitanya
//  Created by admin on 15/02/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.managedObjectContext)private var viewContext
    @FetchRequest(entity:User.entity(),sortDescriptors: [])
    private var users:FetchedResults<User>
    @State private var username = ""
    @State private var password = ""
    @State private var isAuthinticated = false
    @State private var showError = false
    
    var body:some View{
        NavigationView{
            VStack{
                Text("Login")
                    .font(.largeTitle)
                    .padding()
                TextField("username",text:$username).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                SecureField("password",text:$password).textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                
                if showError {
                    Text("Invalid username or password!")
                        .foregroundColor(.red)
                }
                
                Button("Login") {
                    authenticateUser()
                }
                .buttonStyle(.borderedProminent)
                .padding()
                
                NavigationLink("Register here if u df dont have account", destination:RegisterView())
                    .padding()
            }
            .fullScreenCover(isPresented: $isAuthinticated) {
                TransactionListView()
            }
        }
    }
    private func authenticateUser(){
        if users.contains(where: {$0.username == username && $0.password == password})
        {
            isAuthinticated = true
        }else
        {
            showError = true
        }
    }
    
    
    
    
    struct LoginView_Previews: PreviewProvider {
        static var previews: some View {
            LoginView()
        }
    }
}
