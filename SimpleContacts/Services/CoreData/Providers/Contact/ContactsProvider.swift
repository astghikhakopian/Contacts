//
//  ContactsProvider.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import UIKit
import CoreData
import Combine

protocol ContactProviderProtocol {
    
    var fetchedResultsController: NSFetchedResultsController<ContactMO> { get set }
    var viewContext: NSManagedObjectContext { get }
    
    func addContact(_ contactModel: ContactModel, in context: NSManagedObjectContext, shouldSave: Bool) -> AnyPublisher<Bool, Error>
    func update(contactMO: ContactMO, by contact: ContactModel, shouldSave: Bool) -> AnyPublisher<Bool, Error>
    func delete(contact: ContactMO, shouldSave: Bool) -> AnyPublisher<Bool, Error>
}

class ContactProvider: ContactProviderProtocol {
    
    private(set) var persistentContainer: NSPersistentContainer
    private weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    lazy var fetchedResultsController: NSFetchedResultsController<ContactMO> = {
        let fetchRequest: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Schema.Contact.firstName.rawValue, ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        
        return controller
    }()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(with persistentContainer: NSPersistentContainer,
         fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?) {
        self.persistentContainer = persistentContainer
        self.fetchedResultsControllerDelegate = fetchedResultsControllerDelegate
    }
    
    
    // MARK: - Public Methods
    
    public func fetch(in context: NSManagedObjectContext) throws -> [ContactMO] {
        let fetchRequest: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ContactMO.firstName, ascending: false)]
        
        return try context.fetch(fetchRequest)
    }
    
    public func addContact(_ contactModel: ContactModel, in context: NSManagedObjectContext, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            context.perform { [weak self] in
                self?.contactMO(from: contactModel, in: context)
                
                if shouldSave {
                    context.save(with: .addContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    public func update(contactMO: ContactMO, by contact: ContactModel, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            guard let context = contactMO.managedObjectContext else {
                fatalError("###\(#function): Failed to retrieve the context from: \(contact)")
            }
            context.perform { [weak self] in
                self?.update(contactMO: contactMO, from: contact)
                
                if shouldSave {
                    context.save(with: .updateContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    public func delete(contact: ContactMO, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        return Future { promise in
            guard let context = contact.managedObjectContext else {
                fatalError("###\(#function): Failed to retrieve the context from: \(contact)")
            }
            context.perform {
                context.delete(contact)
                
                if shouldSave {
                    context.save(with: .deleteContact)
                }
                return promise(.success(true))
            }
        }.eraseToAnyPublisher()
    }
    
    
    // MARK: - Private Methods
    
    private func contactMO(from contact: ContactModel, in context: NSManagedObjectContext) {
        let contactMO = ContactMO(context: context)
        contactMO.id = contact.id
        update(contactMO: contactMO, from: contact)
    }
    
    private func update(contactMO: ContactMO, from contact: ContactModel) {
        contactMO.id = contact.id
        contactMO.firstName = contact.firstName
        contactMO.lastName = contact.lastName
        contactMO.primaryPhone = contact.primaryPhone
        contactMO.secondaryPhone = contact.secondaryPhone
        contactMO.relationship = contact.relationship
    }
}
