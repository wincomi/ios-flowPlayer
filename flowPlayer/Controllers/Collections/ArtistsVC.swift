//
//  ArtistsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class ArtistsVC: ItemCollectionsVC<ArtworkSubtitleCell> {
	init() {
		let libraryType = LibraryType.artist

		let configure: (ArtworkSubtitleCell, MPMediaItemCollection) -> Void = { (cell, collection) in
			cell.textLabel?.text = collection.representativeItem?.artist
			cell.detailTextLabel?.text = nil
			cell.imageView?.image = nil
			cell.accessoryType = .disclosureIndicator
		}

		let detailViewController: (MPMediaItemCollection) -> UIViewController = {
			collection in
			let vc = ItemsVC(itemCollection: collection)
			vc.title = collection.representativeItem?.artist
			return vc
		}

		super.init(style: .plain, mediaQuery: libraryType.mediaQuery, configure: configure, detailViewController: detailViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
