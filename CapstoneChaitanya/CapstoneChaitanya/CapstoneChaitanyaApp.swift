//
//  CapstoneChaitanyaApp.swift
//  CapstoneChaitanya
//
//  Created by admin on 15/02/25.
//

import SwiftUI

@main
struct CapstoneChaitanyaApp: App {
    let persistenece = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            LoginView().environment(\.managedObjectContext,persistenece.container.viewContext)
        }
    }
}
