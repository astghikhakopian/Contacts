//
//  ContactDetailsViewModeling.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

protocol ContactDetailsViewModeling: ObservableObject {
    
    var mode: ContactDetailsMode { get }
    
    var firstName: String { get set }
    var lastName: String { get set }
    var primaryPhone: String { get set }
    
    var isLoading: Bool { get set }
    var isContentValid: Bool { get set }
    var onError: Error? { get set }
    var onSuccess: Bool? { get set }
    
    func saveContact()
    func deleteContact()
}
