//
//  CollectionPreviewVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

final class CollectionPreviewVC: ArtworkPreviewVC {
	let collection: MPMediaItemCollection

	// MARK: -
	init(collection: MPMediaItemCollection) {
		self.collection = collection
		super.init(artwork: collection.representativeItem?.artwork)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	override var previewActionItems: [UIPreviewActionItem] {
		if collection.items.isEmpty { return [] }

		return [
			UIPreviewAction(title: R.string.localizable.play(), style: .default) { _, _ in
				MusicPlayerManager.shared.play(with: self.collection.items, at: 0)
			},
			UIPreviewAction(title: R.string.localizable.shuffle(), style: .default) { _, _ in
				MusicPlayerManager.shared.setShuffleMode(.songs)
				MusicPlayerManager.shared.play(with: self.collection.items)
			}
		]
	}
}
