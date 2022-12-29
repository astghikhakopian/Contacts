//
//  CommonButton.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

struct CommonButton: View {
    
    let title: String
    var action: (() -> Void)? = nil
    @Binding var isEnabled: Bool
    
    var body: some View {
        Button(action: { action?()}) {
            CommonButtonLabel(title: title)
        }
        .clipShape(Capsule())
        .disabled(!isEnabled)
        .buttonStyle(
            PressedButtonStyle(normalColor: isEnabled ?  .primaryBlue : .primaryBlueDisabled, pressedColor: .primaryBluePressed))
        
    }
}

struct CommonButtonLabel: View {
    let title: String
    var image: Image? = nil
    
    var body: some View {
        HStack {
            if let image = image {
                image
            }
            Text(LocalizedStringKey(title))
        }
            .foregroundColor(.primaryWhite)
            .font(.bold(.callout)())
            .frame(maxWidth: .infinity)
            .padding()
    }
}

struct CommonButton_Previews: PreviewProvider {
    static var previews: some View {
        CommonButton(title: "contacts.add.save", isEnabled: .constant(true))
    }
}
