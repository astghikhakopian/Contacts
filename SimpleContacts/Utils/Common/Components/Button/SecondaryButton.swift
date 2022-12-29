//
//  SecondaryButton.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button(action: { action?()}) {
            Text(LocalizedStringKey(title))
                .foregroundColor(.primaryBlue)
                .font(.bold(.callout)())
                .frame(maxWidth: .infinity)
                .padding()
        }.buttonStyle(
            PressedButtonStyle(normalForegroundColor: .primaryBlue, pressedForegroundColor: .primaryBluePressed))
        
    }
}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(title: "contacts.details.delete")
    }
}
