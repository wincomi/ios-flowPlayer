//
//  ArtworkSubtitleCell.swift
//  flowPlayer
//

import UIKit

class ArtworkSubtitleCell: SubtitleTableViewCell {

	override func layoutSubviews() {
		super.layoutSubviews()

		guard let imageView = self.imageView, imageView.image != nil,
			let textLabel = self.textLabel else { return }

		let imageViewSize: CGFloat = self.contentView.frame.size.height - 16
		imageView.frame = CGRect(x: imageView.frame.origin.x, y: imageView.frame.origin.y + 8, width: imageViewSize, height: imageViewSize)
		imageView.layer.borderColor = UIColor.black.withAlphaComponent(0.05).cgColor
		imageView.layer.borderWidth = 1.0 / UIScreen.main.scale // 레티나 대응
		imageView.layer.masksToBounds = true
		imageView.layer.shouldRasterize = true
		imageView.layer.rasterizationScale = UIScreen.main.scale
		imageView.layer.cornerRadius = imageViewSize * 0.15625
		imageView.contentMode = .scaleAspectFit
		imageView.clipsToBounds = true

		separatorInset = UIEdgeInsets(top: 0, left: imageView.frame.origin.x * 2 + imageViewSize, bottom: 0, right: 0)

		textLabel.frame.origin.x = separatorInset.left
		textLabel.font = UIFont.preferredFont(forTextStyle: .body)

		guard let detailTextLabel = detailTextLabel else { return }
		detailTextLabel.frame.origin.x = separatorInset.left
		detailTextLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
		detailTextLabel.textColor = UIColor.descriptionColor
	}

}
