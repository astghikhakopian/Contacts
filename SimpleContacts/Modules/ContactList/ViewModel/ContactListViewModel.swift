//
//  ContactListViewModel.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import Foundation
import CoreData
import SwiftUI
import Combine

enum ContactContextUpdateType: Equatable {
    case add(ContactModel)
    case update(ContactModel)
    case delete(ContactModel)
    
    var message: String {
        switch self {
        case .add: return "alert.contact.added"
        case .update: return "alert.contact.updated"
        case .delete: return "alert.contact.deleted"
        }
    }
}

final class ContactListViewModel: NSObject, ContactListViewModeling {
    
    @Published var contacts: [ContactModel] = []
    @Published var onError: Error? = nil
    @Published var onSuccess: Bool? = nil
    @Published var onContextUpdate: ContactContextUpdateType? = nil
    
    
    private var contactMOs: [ContactMO] = [] {
        didSet {
            contacts = contactMOs.map { ContactModel(from: $0) }
        }
    }
    
    private let deleteFromContactListUseCase: DeleteFromContactListUseCase
    private let context: NSManagedObjectContext
    private let dueSoonController: NSFetchedResultsController<ContactMO>
    
    private var cancelables = Set<AnyCancellable>()
    
    init(deleteFromContactListUseCase: DeleteFromContactListUseCase, context: NSManagedObjectContext) {
        self.deleteFromContactListUseCase = deleteFromContactListUseCase
        self.context = context
        
        dueSoonController = NSFetchedResultsController(fetchRequest: ContactModel.dueSoonFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        deleteFromContactListUseCase.contactProvider.fetchedResultsController = dueSoonController
        
        super.init()
        
        dueSoonController.delegate = self
        fetchItems()
    }
    
    func delete(contact: ContactModel) {
        guard let contactMO = getMO(from: contact) else { return }
        deleteFromContactListUseCase.execute(contact: contactMO)
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
                    self.onSuccess = success
                }
            }.store(in: &cancelables)
    }
    
    func getMO(from contact: ContactModel) -> ContactMO? {
        contactMOs.first(where: {$0.id == contact.id})
    }
}


// MARK: - NSFetchedResultsControllerDelegate

extension ContactListViewModel: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let contactMOs = controller.fetchedObjects as? [ContactMO] else { return }
        self.contactMOs = contactMOs
        self.onContextUpdate = getContactContextUpdateType(context: controller.managedObjectContext)
    }
}

extension ContactListViewModel {
    
    private func fetchItems() {
        do {
            try dueSoonController.performFetch()
            contactMOs = dueSoonController.fetchedObjects ?? []
        } catch {
            onError = error
        }
    }
    
    private func getContactContextUpdateType(context: NSManagedObjectContext) -> ContactContextUpdateType? {
        if let insertedObject = context.insertedObjects.first as? ContactMO {
            return .add(ContactModel(from: insertedObject))
        } else if let insertedObject = context.updatedObjects.first as? ContactMO {
            return .update(ContactModel(from: insertedObject))
        } else if let insertedObject = context.deletedObjects.first as? ContactMO {
            return .delete(ContactModel(from: insertedObject))
        } else {
            return nil
        }
    }
}
