//
//  ComposersVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class ComposersVC: ItemCollectionsVC<ArtworkSubtitleCell> {
	init() {
		let libraryType = LibraryType.composer

		let configure: (ArtworkSubtitleCell, MPMediaItemCollection) -> Void = { (cell, collection) in
			cell.textLabel?.text = collection.representativeItem?.composer
			cell.detailTextLabel?.text = nil
			cell.imageView?.image = nil
			cell.accessoryType = .disclosureIndicator
		}

		let detailViewController: (MPMediaItemCollection) -> UIViewController = {
			collection in
			let vc = ItemsVC(itemCollection: collection)
			vc.title = collection.representativeItem?.composer
			return vc
		}

		super.init(style: .plain, mediaQuery: libraryType.mediaQuery, configure: configure, detailViewController: detailViewController)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
