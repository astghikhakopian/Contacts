//
//  ContactListUseCase.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

class ContactListUseCase {
     var contactProvider: ContactProviderProtocol
    
    init(contactProvider: ContactProviderProtocol) {
        self.contactProvider = contactProvider
    }
}
