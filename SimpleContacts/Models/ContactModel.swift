//
//  ContactModel.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import Foundation
import CoreData

struct ContactModel: Identifiable, Hashable {
    
    var id: UUID
    var firstName: String
    var lastName: String?
    var primaryPhone: String
    var secondaryPhone: String?
    var relationship: String?
    
    var fullName: String {
        "\(firstName)  \(lastName ?? "")"
    }
}

extension ContactModel {
    
  static var dueSoonFetchRequest: NSFetchRequest<ContactMO> {
    let request: NSFetchRequest<ContactMO> = ContactMO.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(key: #keyPath(ContactMO.firstName), ascending: true)]
    return request
  }
    
    init(from contactMO: ContactMO) {
        self.id = contactMO.id ?? UUID()
        self.firstName = contactMO.firstName ?? ""
        self.lastName = contactMO.lastName
        self.primaryPhone = contactMO.primaryPhone ?? ""
        self.secondaryPhone = contactMO.secondaryPhone
        self.relationship = contactMO.relationship
    }
}


