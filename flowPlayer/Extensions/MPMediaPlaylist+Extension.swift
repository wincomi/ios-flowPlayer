//
//  MPMediaPlaylist+Extension.swift
//  flowPlayer
//

import MediaPlayer

extension MPMediaPlaylist {
	// https://stackoverflow.com/questions/38568603/show-playlist-folder-in-ios-app
	// /PrivateFrameworks/AccessoryMediaLibrary.framework/ACCMediaLibraryUpdatePlaylist.h
	var parentPersistentID: MPMediaEntityPersistentID? {
		let parentPersistentID = (self.value(forProperty: "parentPersistentID") as? NSNumber)?.uint64Value

		if parentPersistentID == 0 {
			return nil
		}

		return parentPersistentID
	}

	var isFolder: Bool {
		guard let isFolder = self.value(forProperty: "isFolder") as? Bool else { return false }

		return isFolder
	}

	var editable: Bool {
		return self.playlistAttributes == .onTheGo
	}

	@available(iOS 9.0, *)
	private var likedState: Int? {
		return self.value(forProperty: "likedState") as? Int
		// 0: 없음
		// 2: 좋아요
		// 3: 별로예요
	}

	@available(iOS 9.0, *)
	var isLoved: Bool {
		guard let likedState = self.likedState else { return false }
		return (likedState == 2)
	}

	@available(iOS 9.0, *)
	var isDisliked: Bool {
		guard let likedState = self.likedState else { return false }
		return (likedState == 3)
	}

	var canAddItems: Bool {
		/// (0): 일반 재생목록
		/// .oneTheGo (1): iTunes와 동기화 후에 기기에서 추가된 재생목록
		return (self.playlistAttributes.rawValue == 0 || self.playlistAttributes == .onTheGo)
	}
}
