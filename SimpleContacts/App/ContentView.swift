//
//  ContentView.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.contactProvider) private var contactProvider
    
    var body: some View {
        NavigationView {
            ContactListView(viewModel: ContactListViewModel(deleteFromContactListUseCase: DeleteFromContactListUseCase(contactProvider: contactProvider!), context: viewContext))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
