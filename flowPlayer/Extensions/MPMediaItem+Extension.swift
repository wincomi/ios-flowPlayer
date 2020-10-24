//
//  MPMediaItem+Extension.swift
//  flowPlayer
//

import MediaPlayer

extension Array where Element: MPMediaItem {
	subscript(indexPath: IndexPath, for querySection: [MPMediaQuerySection]?) -> Element {
		let currLoc = querySection?[indexPath.section].range.location ?? 0
		return self[currLoc + indexPath.row]
	}

	subscript(indexPath: IndexPath, for sectionRange: [TableSection]) -> Element {
		guard let currLoc = sectionRange[indexPath.section].range.first else { fatalError() }
		return self[currLoc + indexPath.row]
	}
}

extension MPMediaItem {
	func artwork(size: CGSize) -> UIImage {
		return artwork?.image(at: size) ?? UIImage.image(with: .tableViewBackgroundColor, size: size)
	}

	var year: Int? {
		return value(forProperty: "year") as? Int
	}

	var copyright: String? {
		return value(forProperty: "copyright") as? String
	}

	var fileSize: Int64 {
		return (value(forProperty: "fileSize") as? Int64) ?? 0
	}

	/// 0: 없음
	/// 2: 좋아요
	/// 3: 별로예요
	@available(iOS 9.0, *)
	private var likedState: Int? {
		return self.value(forProperty: "likedState") as? Int
	}

	@available(iOS 9.0, *)
	var loved: Bool {
		guard let likedState = self.likedState else { return false }
		return (likedState == 2)
	}

	@available(iOS 9.0, *)
	var disliked: Bool {
		guard let likedState = self.likedState else { return false }
		return (likedState == 3)
	}

	func getLyrics() -> String? {
		if let lyrics = lyrics, !lyrics.isEmpty {
			return lyrics
		}

		if let assetURL = assetURL,
			let lyrics = AVURLAsset(url: assetURL).lyrics {
			return lyrics
		}

		return nil
	}

	//// https://bendodson.com/weblog/2017/07/19/mpmediaitem-canaddtolibrary/
	var canAddToLibrary: Bool {
		let id = MPMediaPropertyPredicate(value: self.persistentID, forProperty: MPMediaItemPropertyPersistentID)
		let query = MPMediaQuery(filterPredicates: [id])
		let count = query.items?.count ?? 0
		return count == 0
	}
}
