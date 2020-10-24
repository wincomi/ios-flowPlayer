//
// UIBarButtonItem+Extension.swift
// https://medium.com/@BeauNouvelle/adding-a-closure-to-uibarbuttonitem-24dfc217fe72
//

import UIKit

/// Typealias for UIBarButtonItem closure.
typealias UIBarButtonItemTargetClosure = (UIBarButtonItem) -> Void

class UIBarButtonItemClosureWrapper: NSObject {
	let closure: UIBarButtonItemTargetClosure
	init(_ closure: @escaping UIBarButtonItemTargetClosure) {
		self.closure = closure
	}
}

extension UIBarButtonItem {

	private struct AssociatedKeys {
		static var targetClosure = "targetClosure"
	}

	private var targetClosure: UIBarButtonItemTargetClosure? {
		get {
			guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIBarButtonItemClosureWrapper else { return nil }
			return closureWrapper.closure
		}
		set(newValue) {
			guard let newValue = newValue else { return }
			objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIBarButtonItemClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}

	convenience init(title: String?, style: UIBarButtonItem.Style, closure: @escaping UIBarButtonItemTargetClosure) {
		self.init(title: title, style: style, target: nil, action: nil)
		targetClosure = closure
		action = #selector(UIBarButtonItem.closureAction)
	}

	convenience init(image: UIImage?, style: UIBarButtonItem.Style, closure: @escaping UIBarButtonItemTargetClosure) {
		self.init(image: image, style: style, target: nil, action: nil)
		targetClosure = closure
		action = #selector(UIBarButtonItem.closureAction)
	}

	convenience init(barButtonSystemItem: UIBarButtonItem.SystemItem, closure: @escaping UIBarButtonItemTargetClosure) {
		self.init(barButtonSystemItem: barButtonSystemItem, target: nil, action: nil)
		targetClosure = closure
		action = #selector(UIBarButtonItem.closureAction)
	}

	@objc func closureAction() {
		guard let targetClosure = targetClosure else { return }
		targetClosure(self)
	}
}
