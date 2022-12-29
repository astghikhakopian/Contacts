//
//  DeleteContactUseCase.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import Combine
import CoreData

class DeleteContactUseCase: ContactListUseCase {
    func execute(contactMO: ContactMO, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        contactProvider.delete(contact: contactMO, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
