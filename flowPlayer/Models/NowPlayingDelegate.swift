//
//  NowPlayingDelegate.swift
//  flowPlayer
//

import MediaPlayer

protocol NowPlayingDelegate {
	func presentAlbumVC(of mediaItem: MPMediaItem)
	func presentArtistVC(of mediaItem: MPMediaItem)
}
