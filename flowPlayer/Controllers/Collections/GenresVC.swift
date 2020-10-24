//
//  GenresVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class GenresVC: ItemCollectionsVC<ArtworkSubtitleCell> {
	init() {
		let libraryType = LibraryType.genre

		let configure: (ArtworkSubtitleCell, MPMediaItemCollection) -> Void = { (cell, collection) in
			cell.textLabel?.text = collection.representativeItem?.genre
			cell.detailTextLabel?.text = nil
			cell.imageView?.image = nil
			cell.accessoryType = .disclosureIndicator
		}

		let detailViewController: (MPMediaItemCollection) -> UIViewController = {
			collection in
			let vc = ItemsVC(itemCollection: collection)
			vc.title = collection.representativeItem?.genre
			return vc
		}

		super.init(style: .plain, mediaQuery: libraryType.mediaQuery, configure: configure, detailViewController: detailViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
