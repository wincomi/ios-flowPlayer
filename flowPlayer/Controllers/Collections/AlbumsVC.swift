//
//  AlbumsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class AlbumsVC: ItemCollectionsVC<ArtworkSubtitleCell> {
	// MARK: - 초기화

	/// 일반 탭에서 초기화
	init(mediaQuery: MPMediaQuery = MPMediaQuery.albums()) {
		let configure: (ArtworkSubtitleCell, MPMediaItemCollection) -> Void = { (cell, collection) in
			cell.textLabel?.text = collection.representativeItem?.albumTitle
			cell.detailTextLabel?.text = collection.representativeItem?.albumArtist
			cell.imageView?.image = collection.representativeItem?.artwork(size: cell.imageView?.bounds.size ?? CGSize.zero)
		}

		let detailViewController: (MPMediaItemCollection) -> UIViewController = {
			collection in
			let vc = AlbumItemsVC(itemCollection: collection, style: .grouped)
			vc.title = collection.representativeItem?.albumTitle
			return vc
		}

		super.init(style: .plain, mediaQuery: mediaQuery, configure: configure, detailViewController: detailViewController)
	}

	/// 아티스트의 앨범 보기
	///
	/// - Parameter artistPersistentID: 아티스트의 Persistent ID
	convenience init(artistPersistentID: MPMediaEntityPersistentID, title: String) {
		let mediaQuery = MPMediaQuery.albums()
		let predicate = MPMediaPropertyPredicate(value: artistPersistentID, forProperty: MPMediaItemPropertyArtistPersistentID, comparisonType: .equalTo)
		mediaQuery.addFilterPredicate(predicate)

		self.init(mediaQuery: mediaQuery)

		self.title = title
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	var sortBarButtonItem: UIBarButtonItem {
		let button = UIBarButtonItem(image: R.image.sort.default(), style: .plain) { sender in
			let alert = UIAlertController(title: R.string.localizable.sortBy() + ":", message: nil, preferredStyle: .actionSheet)
			alert.popoverPresentationController?.barButtonItem = sender
			alert.addAction(UIAlertAction.cancelAction)

			let sortingMethods: [LibrarySorting] = [.default, .albumArtist]

			for method in sortingMethods {
				let action = UIAlertAction(title: method.title, style: .default, handler: { _ in

				})

				action.image = method.image
//				action.checked = (method == self.sortingType)

				alert.addAction(action)
			}

			self.present(alert, animated: true)
		}

		button.accessibilityLabel = R.string.localizable.sortBy()

		return button
	}

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = sortBarButtonItem

		if !collections.isEmpty {
			let tableViewButtonsView = TableViewButtonsView.defaultView()
			tableViewButtonsView.delegate = self
			tableView.tableHeaderView = tableViewButtonsView
		}
	}

}

extension AlbumsVC: TableViewButtonsViewDelegate {
	func touchPlayButton(_ sender: TableViewButton) {
		guard let items = mediaQuery.items else { return }
		MusicPlayerManager.shared.setShuffleMode(.off)
		MusicPlayerManager.shared.play(with: items, at: 0)
	}

	// TODO: v5.x shuffleMode .albums
	func touchShuffleButton(_ sender: TableViewButton) {
		guard let items = mediaQuery.items else { return }
		MusicPlayerManager.shared.setShuffleMode(.songs)
		MusicPlayerManager.shared.play(with: items)
	}
}
