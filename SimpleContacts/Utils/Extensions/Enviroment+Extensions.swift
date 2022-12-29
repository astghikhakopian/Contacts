//
//  Enviroment+Extensions.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 29.12.22.
//

import SwiftUI

extension EnvironmentValues {
    
    var contactProvider: ContactProvider? {
        get { self[ContactProviderKey.self] }
        set { self[ContactProviderKey.self] = newValue }
    }
}


// MARK: - Enviroment Keys

private struct ContactProviderKey: EnvironmentKey {
    
    static let defaultValue: ContactProvider? = nil
}
