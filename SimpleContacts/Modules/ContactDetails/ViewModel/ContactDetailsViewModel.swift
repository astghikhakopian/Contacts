//
//  ContactDetailsViewModel.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import Combine
import CoreData

enum ContactDetailsMode {
    case new
    case edit(ContactMO?)
}

final class ContactDetailsViewModel: ContactDetailsViewModeling {
    
    let mode: ContactDetailsMode
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var primaryPhone: String = ""
    
    @Published var isLoading: Bool = false
    @Published var isContentValid: Bool  = false
    @Published var onError: Error? = nil
    @Published var onSuccess: Bool? = nil
    
    private let addContactUseCase: AddContactUseCase
    private let updateContactUseCase: UpdateContactUseCase
    private let deleteContactUseCase: DeleteContactUseCase
    private let context: NSManagedObjectContext
    
    private let phoneNumberCount = 10
    
    private var isValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3($firstName, $lastName, $primaryPhone)
            .map { [weak self] firstName, lastName, primaryPhone in
                !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                self?.rawPhoneNumber(phoneNumber: primaryPhone).count == self?.phoneNumberCount
            }
            .eraseToAnyPublisher()
    }
    
    private var cancelables = Set<AnyCancellable>()
    
    
    init(mode: ContactDetailsMode = .new, addContactUseCase: AddContactUseCase, updateContactUseCase: UpdateContactUseCase, deleteContactUseCase: DeleteContactUseCase, context: NSManagedObjectContext) {
        self.mode = mode
        self.addContactUseCase = addContactUseCase
        self.updateContactUseCase = updateContactUseCase
        self.deleteContactUseCase = deleteContactUseCase
        self.context = context
        
        isValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isContentValid, on: self)
            .store(in: &cancelables)
        
        setContent(for: mode)
    }
    
    
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
    
    private func setContent(for mode: ContactDetailsMode) {
        switch mode {
        case .new:
            break
        case .edit(let contactMO):
            guard let contactMO = contactMO else { break }
            firstName = contactMO.firstName ?? ""
            lastName = contactMO.lastName ?? ""
            primaryPhone = contactMO.primaryPhone ?? ""
        }
    }
    
    private func rawPhoneNumber(phoneNumber: String) -> String {
        return phoneNumber
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: " ", with: "")
    }
}
