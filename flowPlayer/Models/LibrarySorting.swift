//
//  LibrarySorting.swift
//  flowPlayer
//

import MediaPlayer

enum LibrarySorting: String {
//	case playlistOrder
	case `default`
	case title
	case artist
	case albumArtist
	case albumTitle
	case genre
	case composer
	case rating
	case playCount
	case lastPlayedDate
	case dateAdded
	case playbackDuration
	case year

	var title: String {
		if self == .default { return R.string.localizable.sortingDefault() }
		return "songInfo.\(rawValue)".localized
	}

	var image: UIImage? {
		switch self {
		case .default: 			return R.image.sort.default()
		case .title: 			return R.image.sort.title()
		case .artist: 			return R.image.sort.artist()
		case .albumArtist: 		return R.image.sort.albumArtist()
		case .albumTitle: 		return R.image.sort.albumTitle()
		case .genre: 			return R.image.sort.genre()
		case .composer: 			return R.image.sort.composer()
		case .rating: 			return R.image.sort.rating()
		case .playCount: 		return R.image.sort.playCount()
		case .lastPlayedDate: 	return R.image.sort.lastPlayedDate()
		case .dateAdded: 		return R.image.sort.dateAdded()
		case .playbackDuration: 	return R.image.sort.playbackDuration()
		case .year: 				return R.image.sort.year()
		}
	}
}

extension Array where Element == MPMediaItem {
	/// https://stackoverflow.com/questions/40140401/sort-through-array-excluding-nil
	private func compareString(_ a: String?, _ b: String?) -> Bool {
		switch (a, b) {
		case (nil, nil): return false
		case (nil, _?): return true
		case (_?, nil): return false
		case (let a?, let b?): return a < b
		}
	}

	func sorted(by librarySorting: LibrarySorting) -> [MPMediaItem] {
		return self.sorted { left, right in
			switch librarySorting {
			case .default: return false
			case .title:
				return compareString(left.title, right.title)
			case .artist:
				return compareString(left.artist, right.artist)
			case .albumArtist:
				return compareString(left.albumArtist, right.albumArtist)
			case .albumTitle:
				return compareString(left.albumTitle, right.albumTitle)
			case .genre:
				return compareString(left.genre, right.genre)
			case .composer:
				return compareString(left.composer, right.composer)
			case .rating:
				return left.rating > right.rating
			case .playCount:
				return left.playCount > right.playCount
			case .lastPlayedDate:
				return left.lastPlayedDate ?? .distantPast > right.lastPlayedDate ?? .distantPast
			case .dateAdded:
				return left.dateAdded > right.dateAdded
			case .playbackDuration:
				return left.playbackDuration > right.playbackDuration
			case .year:
				return left.year ?? 0 > right.year ?? 0
			}
		}

	}
}
