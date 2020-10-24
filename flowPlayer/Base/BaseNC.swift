//
//  BaseNC.swift
//  flowPlayer
//

import UIKit

class BaseNC: UINavigationController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if #available(iOS 11.0, *) {
			navigationBar.prefersLargeTitles = true
		}

	}

}
