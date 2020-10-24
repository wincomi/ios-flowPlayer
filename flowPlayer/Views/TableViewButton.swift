//
//  TableViewButton.swift
//  flowPlayer
//
//  Created by 장근혁 on 07/12/2018.
//  Copyright © 2018 COMI. All rights reserved.
//

import UIKit

class TableViewButton: UIButton {
	override open var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? .lightGray : .tableViewBackgroundColor
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()

		layer.cornerRadius = min(layer.frame.size.width, layer.frame.size.height) / 8

//		backgroundColor = UIColor(hex: "F0F1F6")
		backgroundColor = UIColor.tableViewBackgroundColor
		titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//		imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
		imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6 + 8)

		imageView?.contentMode = .scaleAspectFit
	}
}
