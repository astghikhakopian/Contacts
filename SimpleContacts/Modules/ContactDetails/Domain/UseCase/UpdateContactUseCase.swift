//
//  UpdateContactUseCase.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import Combine
import CoreData

class UpdateContactUseCase: ContactListUseCase {
    func execute(contactMO: ContactMO, by contact: ContactModel, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        contactProvider.update(contactMO: contactMO, by: contact, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
