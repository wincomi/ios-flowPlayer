//
//  SettingsVC.swift
//  flowPlayer
//

import UIKit
import InAppSettingsKit

class SettingsVC: IASKAppSettingsViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		showCreditsFooter = false
		showDoneButton = false
		neverShowPrivacySettings = true
		hiddenKeys = [
			"showNowPlayingOnSelection"
		]

		tableView.backgroundColor = UIColor.tableViewBackgroundColor
		tableView.separatorColor = UIColor.tableViewSeparatorColor
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
	}
}

extension IASKSpecifierValuesViewController {
	open override func viewDidLoad() {
		super.viewDidLoad()

		tableView.backgroundColor = UIColor.tableViewBackgroundColor
		tableView.separatorColor = UIColor.tableViewSeparatorColor
		if #available(iOS 11.0, *) {
			navigationItem.largeTitleDisplayMode = .never
		}
	}
}
