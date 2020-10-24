//
//  BaseSplitVC.swift
//  flowPlayer
//

import UIKit

class BaseSplitVC: UISplitViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		delegate = self
		preferredDisplayMode = .allVisible
	}
}

extension BaseSplitVC: UISplitViewControllerDelegate {
	// 아이폰에서 Master가 먼저 보이도록 함
	func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
		return true
	}
}
