//
//  SimpleContactsTests.swift
//  SimpleContactsTests
//
//  Created by Astghik Hakopian on 28.12.22.
//

import XCTest
@testable import SimpleContacts
import CoreData

final class SimpleContactsTests: XCTestCase {
    
    var editingContactDetailsViewModel: ContactDetailsViewModel!
    var addingContactDetailsViewModel: ContactDetailsViewModel!
    var contactListViewModel: ContactListViewModel!
    var editingItem: ContactMO?
    
    override func setUpWithError() throws {
        let persistence = PersistenceController.test
        let provider = ContactProvider(
            with: persistence.container,
            fetchedResultsControllerDelegate: nil)
        
        let addContactUseCase = AddContactUseCase(contactProvider: provider)
        let updateContactUseCase = UpdateContactUseCase(contactProvider: provider)
        let deleteContactUseCase = DeleteContactUseCase(contactProvider: provider)
        let deleteFromContactListUseCase = DeleteFromContactListUseCase(contactProvider: provider)
        
        editingItem = try? provider.fetch(in: persistence.context).first
        
        editingContactDetailsViewModel = ContactDetailsViewModel(
            mode: .edit(editingItem),
            addContactUseCase: addContactUseCase,
            updateContactUseCase: updateContactUseCase,
            deleteContactUseCase: deleteContactUseCase,
            context: persistence.context)
        
        addingContactDetailsViewModel = ContactDetailsViewModel(
            mode: .new,
            addContactUseCase: addContactUseCase,
            updateContactUseCase: updateContactUseCase,
            deleteContactUseCase: deleteContactUseCase,
            context: persistence.context)
        
        contactListViewModel = ContactListViewModel(
            deleteFromContactListUseCase: deleteFromContactListUseCase,
            context: persistence.context)
    }
    
    func testAddContactSuccess() throws {
        
        // When
        addingContactDetailsViewModel.saveContact()
        let exp = expectation(description: "")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        
        // Then
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(addingContactDetailsViewModel.onSuccess, true)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testUpdateContactSuccess() throws {
        
        // When
        editingContactDetailsViewModel.saveContact()
        let exp = expectation(description: "")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        
        // Then
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(editingContactDetailsViewModel.onSuccess, true)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testDeleteContactSuccess() throws {
        // When
        editingContactDetailsViewModel.deleteContact()
        let exp = expectation(description: "")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        
        // Then
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(editingContactDetailsViewModel.onSuccess, true)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testDeleteContactError() throws {
        
        // When
        addingContactDetailsViewModel.deleteContact()
        let exp = expectation(description: "")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        
        // Then
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(addingContactDetailsViewModel.onSuccess, nil)
        } else {
            XCTFail("Delay interrupted")
        }
    }
    
    func testDeleteContactFromListError() throws {
        // Given
        let persistence = PersistenceController.test
        let provider = ContactProvider(with: persistence.container, fetchedResultsControllerDelegate: nil)
        let deletingItemMO = try provider.fetch(in: persistence.context).first
        let deletingItem = ContactModel(from: deletingItemMO!)
        
        // When
        contactListViewModel.delete(contact: deletingItem)
        let exp = expectation(description: "")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        
        // Then
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(addingContactDetailsViewModel.onSuccess, nil)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
