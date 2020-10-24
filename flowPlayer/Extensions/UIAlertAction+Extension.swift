//
//  UIAlertAction+Extension.swift
//  flowPlayer
//

import UIKit

extension UIAlertAction {
	var checked: Bool {
		get {
			return value(forKey: "checked") as? Bool ?? false
		}
		set(checked) {
			setValue(checked, forKey: "checked")
		}
	}

	var image: UIImage? {
		get {
			return value(forKey: "image") as? UIImage
		}
		set(image) {
			setValue(image, forKey: "image")
		}
	}

	@available(iOS 9.0, *)
	var titleTextAlignment: NSTextAlignment {
		get {
			return value(forKey: "titleTextAlignment") as? NSTextAlignment ?? .center
		}
		set(value) {
			setValue(value.rawValue, forKey: "titleTextAlignment")
		}
	}

	static let okAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
	static let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
}
