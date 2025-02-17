//
//  RegisterView.swift
//  BudgetTracker
//
//  Created by admin on 29/01/25.
//

import SwiftUI
import CoreData

struct RegisterView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var username = ""
    @State private var clinicName = ""
    @State private var password = ""
    @State private var registrationSuccess = false
    @State private var address = ""
    @State private var contact = ""
    @State private var experience = ""
    @State private var name = ""
    @State private var qualification = ""
    @State private var specialization = ""

    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Text("Register")
                .font(.largeTitle)
                .padding()

            Group {
                TextField("Clinic name", text: $clinicName)
                TextField("Contact", text: $contact)
                    .keyboardType(.phonePad)
                TextField("Experience", text: $experience)
                TextField("Address", text: $address)
                TextField("Username", text: $username)
                TextField("Name", text: $name)
                TextField("Qualification", text: $qualification)
                TextField("Specialization", text: $specialization)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            Button("Register") {
                registerUser()
            }
            .buttonStyle(.borderedProminent)
            .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            if registrationSuccess {
                Text("Registration successful!")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }

    private func registerUser() {
        // Check if username already exists
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let existingUsers = try viewContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                errorMessage = "Username already exists. Please choose another."
                return
            }

            let newUser = User(context: viewContext)
            newUser.username = username
            newUser.password = password  // Ideally, use Keychain for security
            newUser.name = name
            newUser.clinicName = clinicName
            newUser.address = address
            newUser.experience = experience
            newUser.contact = contact
            newUser.qualification = qualification
            newUser.specialization = specialization

            try viewContext.save()
            registrationSuccess = true
            errorMessage = nil

        } catch {
            errorMessage = "Failed to register user: \(error.localizedDescription)"
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
