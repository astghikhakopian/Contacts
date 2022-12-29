//
//  String+Formatting.swift
//  SimpleContacts
//
//  Created by Astghik Hakopian on 28.12.22.
//

extension String {
    enum Format {
        case phone(mask: String = "(XXX) XXX-XXXX")
    }
    func format(with format: Format) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        switch format {
        case .phone(let mask):
            for ch in mask where index < numbers.endIndex {
                if ch == "X" {
                    result.append(numbers[index])
                    index = numbers.index(after: index)
                } else {
                    result.append(ch)
                }
            }
        }
        return result
    }
}
