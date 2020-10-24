//
//  ArtworkPreviewVC.swift
//  flowPlayer
//

import MediaPlayer

class ArtworkPreviewVC: UIViewController {
	let artwork: MPMediaItemArtwork?

	init(artwork: MPMediaItemArtwork?) {
		self.artwork = artwork
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	override func viewDidLoad() {
		super.viewDidLoad()

		preferredContentSize = CGSize(width: view.bounds.width, height: view.bounds.width)
		view.backgroundColor = UIColor.tableViewBackgroundColor

		if let artwork = artwork {
			let imageView = UIImageView(image: artwork.image(at: self.view.bounds.size))
			imageView.contentMode = .scaleAspectFit
			view = imageView
		}
	}
}
