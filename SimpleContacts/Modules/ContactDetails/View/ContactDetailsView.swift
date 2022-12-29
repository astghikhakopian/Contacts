//
//  ContactDetailsView.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//


import SwiftUI

struct ContactDetailsView<M: ContactDetailsViewModeling>: View {
    
    @StateObject var viewModel: M
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var isPresentingConfirmAlert: Bool = false
    
    
    var body: some View {
        VStack {
            content
            Spacer()
            footer
        }
        .scrollContentBackground(.hidden)
        .navigationBarTitle(LocalizedStringKey(navigatonTitle), displayMode: .inline)
        .background(Color.primaryBackground)
        .onChange(of: viewModel.onSuccess) { success in
            guard success == true else { return }
            presentationMode.wrappedValue.dismiss()
        }
        .alert(
            "contacts.details.delete.title",
            isPresented: $isPresentingConfirmAlert,
            actions: { Button( "contacts.details.delete.yes", role: .destructive) { viewModel.deleteContact() } },
            message: { Text("contacts.details.delete.title")})
    }
    
    
    // MARK: - Private Components
    
    private var content: some View {
        Form {
            Section(header: Text("contacts.add.firstName")) {
                TextField("contacts.add.firstName.placeholder", text: $viewModel.firstName)
                    .textContentType(.name)
            }
            
            Section(header: Text("contacts.add.lastName")) {
                TextField("contacts.add.lastName.placeholder", text: $viewModel.lastName)
                    .textContentType(.familyName)
                
            }
            Section(header: Text("contacts.add.primaryPhone")) {
                PhoneNumberTextField(text: $viewModel.primaryPhone, placeholder: "contacts.add.primaryPhone.placeholder")
                    .textContentType(.telephoneNumber)
            }
        }
    }
    
    private  var footer: some View {
        VStack {
            CommonButton(
                title: "contacts.add.save",
                action: { viewModel.saveContact()},
                isEnabled: $viewModel.isContentValid)
            switch viewModel.mode {
            case .new: EmptyView()
            case .edit: SecondaryButton(title: "contacts.details.delete") {
                isPresentingConfirmAlert = true
            }}
        }
        .padding()
    }
    
    private var navigatonTitle: String {
        switch viewModel.mode {
        case .new: return "contacts.add.title"
        case .edit: return "contacts.edit.title"
        }
    }
}


// MARK: - Preview

struct AddPlaceView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailsView(
            viewModel: MockContactDetailsViewModel(
                addContactUseCase: AddContactUseCase(
                    contactProvider: ContactProvider(
                        with: PersistenceController.preview.container,
                        fetchedResultsControllerDelegate: nil)),
                updateContactUseCase: UpdateContactUseCase(
                    contactProvider: ContactProvider(
                        with: PersistenceController.preview.container,
                        fetchedResultsControllerDelegate: nil)),
                deleteContactUseCase: DeleteContactUseCase(
                    contactProvider: ContactProvider(
                        with: PersistenceController.preview.container,
                        fetchedResultsControllerDelegate: nil)),
                context: PersistenceController.preview.context))
    }
}
