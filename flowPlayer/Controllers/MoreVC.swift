//
//  MoreVC.swift
//  flowPlayer
//

import UIKit
//import SPStorkController
import SafariServices
import StoreKit

// TODO: 다국어화
class MoreVC: BaseTableVC {

	struct DefaultCell {
		var title: String
		var image: UIImage?
		var action: (() -> Void)?
	}

	var settingsSectionItems: [DefaultCell] {
		return [
			DefaultCell(title: "Settings".localized, image: R.image.settings.settings()) {
				let vc = SettingsVC()

				self.navigationController?.pushViewController(vc, animated: true)
			},
			DefaultCell(title: "FAQ".localized, image: R.image.settings.faq()) {
				guard let lang = Locale.preferredLanguages.first,
					let url = URL(string: "https://www.wincomi.com/apps/musis/help.php?lang=\(lang)") else { return }

				if #available(iOS 11.0, *) {
					let configuration = SFSafariViewController.Configuration()
					configuration.barCollapsingEnabled = false

					let vc = SFSafariViewController(url: url, configuration: configuration)
					vc.preferredControlTintColor = self.view.tintColor
					vc.dismissButtonStyle = .close
					self.present(vc, animated: true)
				} else {
					let vc = SFSafariViewController(url: url)
					vc.preferredControlTintColor = self.view.tintColor
					self.present(vc, animated: true)
				}
			},
			DefaultCell(title: "Sleep timer".localized, image: R.image.settings.sleepTimer()) {
				let alert = UIAlertController(title: AppSettings.displayName, message: "기본 앱 '시계' → 타이머 탭 → 타이머 종료 시 → 실행 중단을 이용하여 취침 예약을 할 수 있습니다.", preferredStyle: .alert)
				alert.addAction(.okAction)
				self.present(alert, animated: true)
			},
			DefaultCell(title: "Equalizer".localized, image: R.image.settings.equalizer()) {
				let alert = UIAlertController(title: AppSettings.displayName, message: "기본 앱 '설정' → 음악 → EQ에서 EQ를 지정할 수 있습니다.", preferredStyle: .alert)
				alert.addAction(.okAction)
				self.present(alert, animated: true)
			}
		]
	}

	var inAppPurchaseSectionItems: [DefaultCell] {
		let donateText = "Donate".localized
		return [
			DefaultCell(title: donateText, image: R.image.settings.donate()) {
				let alert = UIAlertController(title: donateText, message: nil, preferredStyle: .actionSheet)
				alert.addAction(.cancelAction)
				self.present(alert, animated: true)
			}
		]
	}

	let cellReuseIdentifier = "MoreCell"

	enum TableSection: Int, CaseIterable {
		case tabs
		case settings
		case inAppPurchase
//		case appDeveloper
//		case appIconDesigner

		var sectionHeaderTitle: String? { return nil }
		var sectionFooterTitle: String? {
			switch self {
			case .tabs:
				return "Touch the Edit button at the top to change the tab order.".localized
			default:
				return nil
			}
		}
	}

	var tabs: [TabType]

	func saveTabs() {
		TabManager.shared.saveUserTabs(tabs)

		(tabBarController as? MainTabBarController)?.setUserTabs(with: self.navigationController)
	}

	init() {
		tabs = TabManager.shared.getUserTabs()
		super.init(style: .grouped)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

		navigationItem.rightBarButtonItem = editButtonItem
		tableView.allowsSelectionDuringEditing = false

		// iOS 11 미만을 위한 검색 버튼
//		if #available(iOS 11.0, *) {
//
//		} else {
			navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search) { _ in
				self.navigationController?.pushViewController(SearchVC(), animated: true)
			}
//		}
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
//		return isEditing ? 1 : TableSection.allCases.count
		return TableSection.allCases.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tableSection = TableSection(rawValue: section) else { fatalError() }
		switch tableSection {
		case .tabs: return isEditing ? tabs.count : tabs.count - 4
		case .settings: return settingsSectionItems.count
//		case .appDeveloper: return 1
//		case .appIconDesigner: return 1
		case .inAppPurchase: return inAppPurchaseSectionItems.count
		}
	}

	override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
		return false
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let tableSection = TableSection(rawValue: indexPath.section) else { fatalError() }

		let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)

		switch tableSection {
		case .tabs:
			let tab = isEditing ? tabs[indexPath.row] : tabs[indexPath.row + 4]
			cell.textLabel?.text = tab.viewControllerTitle
			cell.imageView?.image = tab.image
			cell.accessoryType = .disclosureIndicator
			cell.showsReorderControl = true
		case .settings:
			let item = settingsSectionItems[indexPath.row]
			cell.textLabel?.text = item.title
			cell.imageView?.image = item.image
			cell.accessoryType = .disclosureIndicator
		case .inAppPurchase:
			let item = inAppPurchaseSectionItems[indexPath.row]
			cell.textLabel?.text = item.title
			cell.imageView?.image = item.image
			cell.accessoryType = .disclosureIndicator
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let tableSection = TableSection(rawValue: indexPath.section) else { fatalError() }
		switch tableSection {
		case .tabs:
			let tab = tabs[indexPath.row + 4]
			let vc = TabManager.shared.viewController(for: tab)

			/// TabBar를 유지하면서 present 함
			/// SplitViewController 일 경우 .currentContext를 사용할 경우 오류가 발생하여 사용할 수 없음.
			// vc.modalPresentationStyle = .currentContext

//			let transitionDelegate = SPStorkTransitioningDelegate()
//			transitionDelegate.showIndicator = false
//			vc.transitioningDelegate = transitionDelegate
//			vc.modalPresentationStyle = .custom

			present(vc, animated: true) {
				self.tableView.deselectRow(at: indexPath, animated: true)
			}
		case .settings:
			let item = settingsSectionItems[indexPath.row]
			item.action?()

			tableView.deselectRow(at: indexPath, animated: true)
		case .inAppPurchase:
			let item = inAppPurchaseSectionItems[indexPath.row]
			item.action?()

			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		guard let tableSection = TableSection(rawValue: indexPath.section) else { fatalError() }
		switch tableSection {
		case .tabs: 	return true
		default:		return false
		}
	}

	override func setEditing(_ editing: Bool, animated: Bool) {
		super.setEditing(editing, animated: animated)

		let indexPaths = (0..<4).map { IndexPath(row: $0, section: 0) }
//		let sections = IndexSet(integersIn: (1..<TableSection.allCases.count))

		tabBarController?.tabBar.isHidden = editing

		if editing {
			tableView.insertRows(at: indexPaths, with: .fade)
//			tableView.deleteSections(sections, with: .fade)
		} else {
			tableView.deleteRows(at: indexPaths, with: .fade)
			saveTabs()
//			tableView.insertSections(sections, with: .fade)
		}
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		var tempTabs = tabs
		let tabToMove = tabs[sourceIndexPath.row]
		tempTabs.remove(at: sourceIndexPath.row)
		tempTabs.insert(tabToMove, at: destinationIndexPath.row)

		tabs = tempTabs
	}

	override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
		if sourceIndexPath.section != proposedDestinationIndexPath.section {
			return sourceIndexPath
		}
		return proposedDestinationIndexPath
	}

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		return .none
	}
}
