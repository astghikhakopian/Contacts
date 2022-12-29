//
//  AddContactUseCase.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import Combine
import CoreData

class AddContactUseCase: ContactListUseCase {
    func execute(contactModel: ContactModel, in context: NSManagedObjectContext, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        contactProvider.addContact(contactModel, in: context, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
