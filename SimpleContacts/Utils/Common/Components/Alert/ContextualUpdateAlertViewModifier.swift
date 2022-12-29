//
//  ContextualUpdateAlertViewModifier.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import SwiftUI

extension View {

    func contextualUpdate(type: Binding<ContactContextUpdateType?>) -> some View {
        return modifier(ContextualUpdateAlertViewModifier(type: type))
    }
}

struct ContextualUpdateAlertViewModifier {
    
    @Binding var type: ContactContextUpdateType?
    
    private let dismissAfter: TimeInterval = 5
}

extension ContextualUpdateAlertViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if let type = type {
                InformativeAlertView(message: type.message, image: Image(systemName: "checkmark"))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                            self.type = nil
                        }
                    }
            }
        }
    }
}
