//
//  DeleteFromContactListUseCase.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import Combine

class DeleteFromContactListUseCase: ContactListUseCase {
    func execute(contact: ContactMO, shouldSave: Bool = true) -> AnyPublisher<Bool, Error> {
        contactProvider.delete(contact: contact, shouldSave: shouldSave)
            .eraseToAnyPublisher()
    }
}
