//
//  AlbumSongCell.swift
//  flowPlayer
//

import UIKit

class AlbumSongCell: UITableViewCell {
	@IBOutlet weak var albumTrackNumberLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!

	override func layoutSubviews() {
		super.layoutSubviews()

		separatorInset = UIEdgeInsets(top: 0, left: titleLabel.frame.origin.x, bottom: 0, right: 0)
	}
}
