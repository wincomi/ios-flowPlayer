//
//  TimeInterval+Extension.swift
//  flowPlayer
//

extension TimeInterval {
	func toString() -> String? {
		let formatter = DateComponentsFormatter()
		formatter.zeroFormattingBehavior = .pad
		formatter.allowedUnits = [.minute, .second]
		formatter.unitsStyle = .abbreviated

		if self >= 3600 {
			formatter.allowedUnits.insert(.hour)
		}

		return formatter.string(from: self)
	}
}
