//
//  SongsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class SongsVC: ItemsVC {

	override func viewDidLoad() {
		super.viewDidLoad()

		let tableViewButtonsView = TableViewButtonsView(frame: CGRect(x: 0, y: 0, width: 0, height: 64 + 16))
		tableViewButtonsView.delegate = self

		if items.count > 0 {
			tableView.tableHeaderView = tableViewButtonsView
		}

		// searchBar를 정상적으로 보이게하기 위한 코드
		definesPresentationContext = true

		if #available(iOS 11.0, *) {
			navigationItem.searchController = SearchVC.searchController
		}
	}
}

extension SongsVC: TableViewButtonsViewDelegate {
	func touchPlayButton(_ sender: TableViewButton) {
		MusicPlayerManager.shared.setShuffleMode(.off)
		MusicPlayerManager.shared.play(with: items, at: 0)
	}

	func touchShuffleButton(_ sender: TableViewButton) {
		MusicPlayerManager.shared.setShuffleMode(.songs)
		MusicPlayerManager.shared.play(with: items)
	}

}

extension MPMediaItem {
	func getTitle() -> String {
		return title ?? R.string.localizable.unknownTitle()
	}

	func getAttributedString() -> NSAttributedString {
		let artistString = (artist ?? albumArtist) ?? R.string.localizable.unknownArtist()
		let artistAttributedString = NSAttributedString(string: artistString, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
		let albumAttributedString = NSAttributedString(string: albumTitle ?? R.string.localizable.unknownAlbum())

		let blank = NSAttributedString(string: " ")

		let attributedString = NSMutableAttributedString()
		attributedString.append(artistAttributedString)
		attributedString.append(blank)
		attributedString.append(albumAttributedString)
		return attributedString as NSAttributedString
	}
}
