//
//  MockContactDetailsModel.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import Combine
import CoreData

final class MockContactDetailsViewModel: ContactDetailsViewModeling {
    
    let mode: ContactDetailsMode
    
    var firstName: String = ""
    var lastName: String = ""
    var primaryPhone: String = ""
    
    var isLoading: Bool = false
    var isContentValid: Bool  = false
    var onError: Error? = nil
    var onSuccess: Bool? = nil
    
    private let addContactUseCase: AddContactUseCase
    private let updateContactUseCase: UpdateContactUseCase
    private let deleteContactUseCase: DeleteContactUseCase
    private let context: NSManagedObjectContext
    
    private var cancelables = Set<AnyCancellable>()
    
    
    init(mode: ContactDetailsMode = .new, addContactUseCase: AddContactUseCase, updateContactUseCase: UpdateContactUseCase, deleteContactUseCase: DeleteContactUseCase, context: NSManagedObjectContext) {
        self.mode = mode
        self.addContactUseCase = addContactUseCase
        self.updateContactUseCase = updateContactUseCase
        self.deleteContactUseCase = deleteContactUseCase
        self.context = context
    }
    
    
    // MARK: - Public Methods
    
    // MARK: - Public Methods
    
    func saveContact() {
        switch mode {
        case .new:
            addContact()
        case .edit(let contactMO):
            guard let contactMO = contactMO else { break }
            updateContact(contact: contactMO)
        }
    }
    
    func deleteContact() {
        switch mode {
        case .new: break
        case .edit(let contactMO):
            guard let contactMO = contactMO else { break }
            deleteContactUseCase.execute(contactMO: contactMO)
                .sink { [weak self] result in
                    switch result {
                    case .finished: break
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.onError = error
                        }
                    }
                } receiveValue: { success in
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.onSuccess = success
                    }
                }.store(in: &cancelables)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func addContact() {
        isLoading = true
        let addingContact = ContactModel(id: UUID(), firstName: firstName, lastName: lastName, primaryPhone: rawPhoneNumber(phoneNumber: primaryPhone))
        addContactUseCase.execute(contactModel: addingContact, in: context)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError = error
                    }
                }
            } receiveValue: { success in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.onSuccess = success
                }
            }.store(in: &cancelables)
    }
    
    private func updateContact(contact: ContactMO) {
        isLoading = true
        let updatingContact = ContactModel(id: UUID(), firstName: firstName, lastName: lastName, primaryPhone: rawPhoneNumber(phoneNumber: primaryPhone))
        updateContactUseCase.execute(contactMO: contact, by: updatingContact)
            .sink { [weak self] result in
                switch result {
                case .finished: break
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError = error
                    }
                }
            } receiveValue: { success in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.onSuccess = success
                }
            }.store(in: &cancelables)
    }
    
    private func rawPhoneNumber(phoneNumber: String) -> String {
        return phoneNumber
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
