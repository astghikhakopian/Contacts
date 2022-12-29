//
//  MockContactListViewmodel.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import CoreData
import Foundation

final class MockContactListViewModel: ContactListViewModeling {
    
    var contacts = [ContactModel]()
    var onContextUpdate: ContactContextUpdateType? = nil
    
    private var contactMOs: [ContactMO] = [] {
        didSet {
            contacts = contactMOs.map { ContactModel(from: $0) }
        }
    }
    
    private let deleteFromContactListUseCase: DeleteFromContactListUseCase
    private let context: NSManagedObjectContext
    private let dueSoonController: NSFetchedResultsController<ContactMO>
    
    init(deleteFromContactListUseCase: DeleteFromContactListUseCase, context: NSManagedObjectContext) {
        self.deleteFromContactListUseCase = deleteFromContactListUseCase
        self.context = context
        
        dueSoonController = NSFetchedResultsController(fetchRequest: ContactModel.dueSoonFetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        deleteFromContactListUseCase.contactProvider.fetchedResultsController = dueSoonController
        
        fetchItems()
    }
    
    private func fetchItems() {
        do {
          try dueSoonController.performFetch()
            contactMOs = dueSoonController.fetchedObjects ?? []
        } catch {
          print("failed to fetch items!")
        }
    }
    
    func delete(contact: ContactModel) { }
    
    func getMO(from contact: ContactModel) -> ContactMO? {
        contactMOs.first(where: {$0.id == contact.id})
    }
}
