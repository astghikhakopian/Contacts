//
//  InformativeAlertView.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import SwiftUI

struct InformativeAlertView: View {
    let message: String
    let image: Image
    
    private let imageWidth: CGFloat = 8
    private let cornerRadius: CGFloat = 4
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(message))
                .font(.subheadline)
                .foregroundColor(.primaryWhite)
            Spacer()
            accessory(image: image)
        }
        .padding()
        .background(Color.primaryBlack)
        .cornerRadius(cornerRadius)
        .padding()
    }
    
    private func accessory(image: Image) -> some View {
        image
            .resizable()
            .frame(width: imageWidth, height: imageWidth)
            .foregroundColor(.primaryWhite)
            .padding(imageWidth/2)
            .background(Color.primaryBlue)
            .clipShape(Capsule())
            .overlay(Circle()
                .stroke(Color.primaryWhite, lineWidth: 1)
        )
    }
}

struct InformativeAlertView_Previews: PreviewProvider {
    static var previews: some View {
        InformativeAlertView(message: "alert.contact.added", image: Image(systemName: "checkmark"))
    }
}
