//
//  ContactCell.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

struct ContactCell: View {
    
    let contact: ContactModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.fullName)
                .font(.headline)
                .foregroundColor(.primary)
            Text(contact.primaryPhone.format(with: .phone()))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}


// MARK: - Preview

struct ContactCell_Previews: PreviewProvider {
    static var previews: some View {
        ContactCell(contact: ContactModel(id: UUID(), firstName: "Anna", lastName: "Simonyan", primaryPhone: "234567896"))
    }
}
