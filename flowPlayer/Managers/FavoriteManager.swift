//
//  FavoriteManager.swift
//  flowPlayer
//

import Foundation
import MediaPlayer

final class FavoriteManager {
	static let shared = FavoriteManager()

	private init() { }

	static var test: [MPMediaEntityPersistentID] = []

	// persistentID로 구성된 즐겨찾기
	private func getFavorites(in type: LibraryType) -> [MPMediaEntityPersistentID] {
		return FavoriteManager.test
	}

	/// 라이브러리에 들어있는 즐겨찾기의 MPMediaItem을 가져오는 함수
	func getMediaItems(in type: LibraryType) -> [MPMediaItem] {
		// 1. 라이브러리 타입에 맞는 즐겨찾기를 가져온다.
		let favorites = getFavorites(in: type)

		// 2. 라이브러리를 불러온다.
		let mediaItems = type.mediaQuery.items ?? []

		// 3. 불러온 라이브러리에서 즐겨찾기만 필터한다.
		return mediaItems.filter { favorites.contains($0.persistentID) }
	}

	/// 즐겨찾기에 mediaItem으로 들어온 항목이 존재하는지 확인하는 함수
	func exists(mediaItem: MPMediaItem, in type: LibraryType) -> Bool {
		return exists(item: mediaItem.persistentID, in: type)
	}

	private func exists(item: MPMediaEntityPersistentID, in type: LibraryType) -> Bool {
		return getFavorites(in: type).contains(item)
	}

	private func add(persistentId: MPMediaEntityPersistentID, to type: LibraryType) {
		FavoriteManager.test.append(persistentId)
		print("정상적으로 즐겨찾기에 추가됨")
		print(FavoriteManager.test)
	}

	func add(mediaItem: MPMediaItem, to type: LibraryType) {
		add(persistentId: mediaItem.persistentID, to: type)
	}

	func delete(mediaItem: MPMediaItem, from: LibraryType) {
		print("즐겨찾기에서 제거됨")
		print(FavoriteManager.test)
	}

	private func delete(item: MPMediaEntityPersistentID, from: LibraryType) throws {
		
	}

	func reset() throws {

	}

}
