//
//  TabType.swift
//  flowPlayer
//

enum TabType: String {
	case playlists
	case artists
	case albums
	case songs
	case genres
	case composers
	case favorites
	case files
	case more

	/// 앱 처음 설치시 나타나는 기본 탭
	static var defaultTabTypes: [TabType] {
		return [
			.playlists, .albums, .songs, .favorites,
			.artists, .genres, .composers, .files//, .search
		]
	}

	public var viewControllerTitle: String {
		switch self {
		case .playlists: 	return R.string.localizable.playlists()
		case .artists: 		return R.string.localizable.artists()
		case .albums: 		return R.string.localizable.albums()
		case .songs: 		return R.string.localizable.songs()
		case .genres: 		return R.string.localizable.genres()
		case .composers: 	return R.string.localizable.composers()
		case .favorites: 	return R.string.localizable.favorites()
		case .files:			return R.string.localizable.files()
		case .more:			return R.string.localizable.more()
		}
	}

	var image: UIImage? {
		switch self {
		case .playlists: 	return R.image.tab.playlists()
		case .artists: 		return R.image.tab.artists()
		case .albums: 		return R.image.tab.albums()
		case .songs: 		return R.image.tab.songs()
		case .genres: 		return R.image.tab.genres()
		case .composers: 	return R.image.tab.composers()
		case .favorites: 	return R.image.tab.favorites()
		case .files:			return R.image.tab.files()
		case .more:			return R.image.tab.more()
		}
	}

	public func getTabBarItem() -> UITabBarItem {
		return UITabBarItem(title: viewControllerTitle, image: image, tag: hashValue)
	}

}
