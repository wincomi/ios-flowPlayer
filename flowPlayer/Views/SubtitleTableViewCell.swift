//
//  SubtitleTableViewCell.swift
//  flowPlayer
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

		detailTextLabel?.textColor = UIColor.descriptionColor
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func awakeFromNib() {
		super.awakeFromNib()

		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
	}

}
