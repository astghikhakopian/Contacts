//
//  PhoneNumberTextField.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

struct PhoneNumberTextField: View {
    
    @Binding var text: String
    var format: String = "(XXX) XXX-XXXX"
    var placeholder: String = "(000) 000-0000"
    
    private let height = 48.0
    private let padding = 12.0
    private let spacing = 0.0
    
    var body: some View {
        
        let proxy = Binding<String>(
            get: { format(with: format, phone: text) },
            set: { text = format(with: format, phone: $0) }
        )
        
        TextField(LocalizedStringKey(placeholder), text: proxy)
            .keyboardType(.numberPad)
    }
}


extension PhoneNumberTextField {
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

struct PhoneNumberTextField_Previews: PreviewProvider {
    
    @State static var text: String = ""
    
    static var previews: some View {
        PhoneNumberTextField(text: $text)
    }
}
