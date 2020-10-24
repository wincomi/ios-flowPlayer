//
//  String+Extension.swift
//  flowPlayer
//

import Foundation

extension String {
	//// Returns a localized string, using the main bundle if one is not specified.
	var localized: String {
		return NSLocalizedString(self, comment: "")
		// return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
	}

	private func camelCaseToWords() -> String {
		return unicodeScalars.reduce("") {
			if CharacterSet.uppercaseLetters.contains($1) == true {
				return ($0 + " " + String($1))
			} else {
				return $0 + String($1)
			}
		}
	}

	func propertyToString() -> String {
		return self.camelCaseToWords().capitalized
	}

}
