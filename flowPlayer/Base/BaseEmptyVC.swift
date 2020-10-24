//
//  BaseEmptyVC.swift
//  flowPlayer
//

import UIKit

class BaseEmptyVC: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = UIColor.tableViewBackgroundColor

		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
	}
}
