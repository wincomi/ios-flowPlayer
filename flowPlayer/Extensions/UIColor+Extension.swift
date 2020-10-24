//
//  UIColor+Extension.swift
//  flowPlayer
//

import UIKit

extension UIColor {
	//// https://developer.apple.com/ios/human-interface-guidelines/visual-design/color/
	struct ThemeColor {
		// static let pink = UIColor(red: 255/255.0, green: 45/255.0, blue: 85/255.0, alpha: 1.0)
		static let pink = UIColor(red: 255/255.0, green: 0/255.0, blue: 66/255.0, alpha: 1.0)
		static let red = UIColor(red: 255/255.0, green: 59/255.0, blue: 48/255.0, alpha: 1.0)
		static let orange = UIColor(red: 255/255.0, green: 149/255.0, blue: 0/255.0, alpha: 1.0)
		static let yellow = UIColor(red: 255/255.0, green: 204/255.0, blue: 0/255.0, alpha: 1.0)
		static let green = UIColor(red: 76/255.0, green: 217/255.0, blue: 100/255.0, alpha: 1.0)
		static let tealBlue = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
		static let blue = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
		static let purple = UIColor(red: 88/255.0, green: 86/255.0, blue: 214/255.0, alpha: 1.0)
	}

	static let tableViewBackgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1.0)

	static let tableViewSeparatorColor = UIColor(red: 199/255.0, green: 200/255.0, blue: 204/255.0, alpha: 1.0).withAlphaComponent(0.5)

	static let descriptionColor = UIColor(red: 141/255.0, green: 142/255.0, blue: 147/255.0, alpha: 1.0)

	struct ButtonBackgroundColor {
		static let normal = UIColor(red: 240/255.0, green: 239/255.0, blue: 248/255.0, alpha: 1.0)
		static let highlighted = UIColor(red: 143/255.0, green: 144/255.0, blue: 146/255.0, alpha: 1.0)

	}

	func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
		return self.adjust(by: abs(percentage) )
	}

	func darker(by percentage: CGFloat = 30.0) -> UIColor? {
		return self.adjust(by: -1 * abs(percentage) )
	}

	func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
		var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: min(r + percentage/100, 1.0),
						   green: min(g + percentage/100, 1.0),
						   blue: min(b + percentage/100, 1.0),
						   alpha: a)
		} else {
			return nil
		}
	}
}
