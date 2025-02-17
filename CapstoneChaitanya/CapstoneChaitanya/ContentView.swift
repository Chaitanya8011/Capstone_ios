//
//  ContentView.swift
//  CapstoneChaitanya
//
//  Created by admin on 15/02/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        LoginView().environment(\.managedObjectContext,PersistenceController.shared.container.viewContext)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
