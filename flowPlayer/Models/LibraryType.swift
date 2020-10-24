//
//  LibraryType.swift
//  flowPlayer
//

import MediaPlayer

enum LibraryType: String, CaseIterable {
	case playlist
	case artist
	case album
	case song
	case genre
	case composer

	/// MPMediaQuery에 사용하는 groupingType을 가져온다.
	private var groupingType: MPMediaGrouping {
		switch self {
		case .playlist: 	return .playlist
		case .artist: 	return .albumArtist
		case .album: 	return .album
		case .song: 		return .title
		case .genre: 	return .genre
		case .composer: 	return .composer
		}
	}

	public var mediaQuery: MPMediaQuery {
		let mediaQuery = MPMediaQuery.songs()
		mediaQuery.groupingType = groupingType
		return mediaQuery
	}

	func getFavoriteMediaItems() -> [MPMediaItem] {
		return FavoriteManager.shared.getMediaItems(in: self)
	}
	
}
