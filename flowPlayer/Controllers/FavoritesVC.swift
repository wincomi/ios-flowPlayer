//
//  FavoritesVC.swift
//  flowPlayer
//

import UIKit

class FavoritesVC: BaseTableVC {
	init() {
		super.init(style: .grouped)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let cellReuseIdentifier = "FavoriteCell"

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = editButtonItem
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, closure: { (_) in
			print("refresh")
			self.tableView.reloadData()
		})
		tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
		tableView.register(ArtworkSubtitleCell.self, forCellReuseIdentifier: cellReuseIdentifier)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let type = LibraryType.song
		return FavoriteManager.shared.getMediaItems(in: type).count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return R.string.localizable.song()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
		let item = FavoriteManager.shared.getMediaItems(in: .song)[indexPath.row]
		cell.textLabel?.text = item.title
		cell.detailTextLabel?.text = item.artist

		let artworkSize = cell.imageView?.bounds.width ?? 0 * UIScreen.main.scale
		cell.imageView?.image = item.artwork?.image(at: CGSize(width: artworkSize, height: artworkSize))

		return cell
	}
}
