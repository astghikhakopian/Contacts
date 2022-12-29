//
//  ContactListView.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

struct ContactListView<M: ContactListViewModeling>: View {
    
    // MARK: - Public Properties
    
    @StateObject var viewModel: M
    
    
    // MARK: - Private Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.contactProvider) private var contactProvider
    
    
    // MARK: - Content
    
    var body: some View {
        VStack {
            list
            addButton
        }
        .background(Color.primaryBackground)
        .contextualUpdate(type: $viewModel.onContextUpdate)
    }
    
    
    // MARK: - Private Components
    
    private var list: some View {
        List {
            Section() {
                Text("contacts.list.description")
            }
            Section {
                ForEach(viewModel.contacts, id: \.id) { contact in
                    NavigationLink {
                        ContactDetailsView(viewModel: ContactDetailsViewModel(mode: .edit(viewModel.getMO(from: contact)), addContactUseCase: AddContactUseCase(contactProvider: contactProvider!), updateContactUseCase: UpdateContactUseCase(contactProvider: contactProvider!), deleteContactUseCase: DeleteContactUseCase(contactProvider: contactProvider!), context: viewContext))
                    } label: {
                        ContactCell(contact: contact)
                    }
                }.onDelete(perform: deleteContacts)
            }
        }
        .scrollContentBackground(.hidden)
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("contacts.title", displayMode: .inline)
    }
    
    private var addButton: some View {
        NavigationLink {
            ContactDetailsView(viewModel: ContactDetailsViewModel(mode: .new, addContactUseCase: AddContactUseCase(contactProvider: contactProvider!), updateContactUseCase: UpdateContactUseCase(contactProvider: contactProvider!), deleteContactUseCase: DeleteContactUseCase(contactProvider: contactProvider!), context: viewContext))
        } label: {
            CommonButtonLabel(title: "contacts.list.add", image: Image(systemName: "plus"))
        }.buttonStyle( PressedButtonStyle(normalColor: .primaryBlue, pressedColor: .primaryBluePressed))
            .clipShape(Capsule())
            .padding()
    }
    
    private func showUpdateToast(for newState: ContactContextUpdateType) {
        
    }
    
    // MARK: - Actions
    
    private func deleteContacts(at indices: IndexSet) {
        for index in indices {
            viewModel.delete(contact: viewModel.contacts[index])
        }
    }
}



// MARK: - Preview

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactListView(viewModel: MockContactListViewModel(deleteFromContactListUseCase: DeleteFromContactListUseCase(contactProvider: ContactProvider(with: PersistenceController.preview.container, fetchedResultsControllerDelegate: nil)), context: PersistenceController.preview.context))
        }
    }
}
