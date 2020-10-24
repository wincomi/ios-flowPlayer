//
//  PlaylistManager.swift
//  flowPlayer
//

import MediaPlayer

typealias PlaylistFolderPersistentID = UInt64

class PlaylistManager {
	static let shared = PlaylistManager()

	private init() { }

	/// 재생목록 생성
	///
	/// - Parameter playlistCreationMetadata: MPMediaPlaylistCreationMetadata을 가져옴
	/// - Returns: MPMediaPlaylist 반환
	func createPlaylist(title: String, authorDisplayName: String?, descriptionText: String?, completionHandler: @escaping (MPMediaPlaylist?, Error?) -> Void) {
		let playlistCreationMetadata = MPMediaPlaylistCreationMetadata(name: title)
		playlistCreationMetadata.authorDisplayName = authorDisplayName ?? "Flow Player"
		if let descriptionText = descriptionText {
			playlistCreationMetadata.descriptionText = descriptionText
		}

		let playlistUUID = UUID()

		MPMediaLibrary.default().getPlaylist(with: playlistUUID, creationMetadata: playlistCreationMetadata) { (playlist, error) in
			completionHandler(playlist, error)
		}
	}

}
