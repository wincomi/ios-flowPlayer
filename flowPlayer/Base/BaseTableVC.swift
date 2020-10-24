//
//  BaseTableVC.swift
//  flowPlayer
//

import UIKit

class BaseTableVC: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.backgroundColor = UIColor.tableViewBackgroundColor
		tableView.separatorColor = UIColor.tableViewSeparatorColor

		if tableView.style == .plain, tableView.tableFooterView == nil {
			tableView.tableFooterView = {
				let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1.0 / UIScreen.main.scale))
				view.backgroundColor = tableView.separatorColor
				return view
			}()
		} else {
			tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 29)) // 상단 여백 줄임 (30)
		}
	}

	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		guard let headerView = view as? UITableViewHeaderFooterView else { return }
		if tableView.style == .plain {
			let blurEffect = UIBlurEffect(style: .extraLight)
			let visualView = UIVisualEffectView(effect: blurEffect)
			headerView.backgroundView = visualView
		}
	}

}
