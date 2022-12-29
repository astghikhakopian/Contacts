//
//  PressedButtonStyle.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

import SwiftUI

struct PressedButtonStyle: ButtonStyle {
    
    var normalColor: Color = .clear
    var pressedColor: Color = .clear
    
    var normalForegroundColor: Color = .primaryWhite
    var pressedForegroundColor: Color = .primaryWhite
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? pressedForegroundColor : normalForegroundColor)
            .background(configuration.isPressed ? pressedColor : normalColor)
    }
}
