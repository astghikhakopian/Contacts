//
//  ContactListViewModeling.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

protocol ContactListViewModeling: ObservableObject {
    
    var contacts: [ContactModel] { get set }
    var onContextUpdate: ContactContextUpdateType? { get set }
    
    func delete(contact: ContactModel)
    func getMO(from contact: ContactModel) -> ContactMO?
}
