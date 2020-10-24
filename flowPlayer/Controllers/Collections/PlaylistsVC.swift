//
//  PlaylistsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class PlaylistsVC: ItemCollectionsVC<SubtitleTableViewCell> {
	init() {
		let libraryType = LibraryType.playlist

		let configure: (SubtitleTableViewCell, MPMediaItemCollection) -> Void = { (cell, collection) in
			guard let playlist = collection as? MPMediaPlaylist else { fatalError() }
			cell.textLabel?.text = playlist.name
			cell.detailTextLabel?.text = playlist.descriptionText
			cell.imageView?.image = (playlist.playlistAttributes == .smart) ? R.image.tab.playlist.smartPlaylists() : R.image.tab.playlists()
			cell.accessoryType = .disclosureIndicator
		}

		let detailViewController: (MPMediaItemCollection) -> UIViewController = {
			collection in
			guard let playlist = collection as? MPMediaPlaylist else { fatalError() }
			let vc = PlaylistItemsVC(itemCollection: collection, style: .grouped)
			vc.title = playlist.name

			return vc
		}

		super.init(style: .grouped, mediaQuery: libraryType.mediaQuery, configure: configure, detailViewController: detailViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// TODO: - v5.1 재생목록 추가 기능
		let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add) { (_) in
			let alert = UIAlertController(title: "New playlist".localized, message: "You can only add and delete a playlist in default music app on Apple policy.".localized, preferredStyle: .alert)
			alert.addAction(UIAlertAction.cancelAction)

			let yesAction = UIAlertAction(title: "Go to music app...".localized, style: .default, handler: { (_) in
				let url = URL(string: "music://")!
				if #available(iOS 10.0, *) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				} else {
					UIApplication.shared.openURL(url)
				}
			})
			alert.addAction(yesAction)

			self.present(alert, animated: true)
		}

		navigationItem.rightBarButtonItem = addBarButtonItem
	}
}
