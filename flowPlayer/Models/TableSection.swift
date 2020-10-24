//
//  TableSection.swift
//  flowPlayer
//

import MediaPlayer

class TableSection {

	/// The localized title of the media query section.
	var title: String?

	/// The range in the media query's items or collections array that is represented by the media query section.
	var range: Range<Int>

	init(title: String?, range: Range<Int>) {
		self.title = title
		self.range = range
	}

	convenience init(mediaQuerySection: MPMediaQuerySection) {
		guard let range = Range(mediaQuerySection.range) else { fatalError() }
		self.init(title: mediaQuerySection.title, range: range)
	}

}
