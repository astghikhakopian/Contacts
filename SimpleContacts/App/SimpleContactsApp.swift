//
//  SimpleContactsApp.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

@main
struct SimpleContactsApp: App {
    let persistenceController = PersistenceController.shared
    let contactProvider = ContactProvider(with: PersistenceController.shared.container, fetchedResultsControllerDelegate: nil)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.contactProvider, contactProvider)
        }
    }
}
