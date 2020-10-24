//
//  ItemCollectionsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer
import DZNEmptyDataSet
//import SPStorkController

class ItemCollectionsVC<Cell: UITableViewCell>: BaseTableVC, UIViewControllerPreviewingDelegate {

	let cellReuseIdentifier: String = "ItemCollectionCell"

	let mediaQuery: MPMediaQuery

	let collections: [MPMediaItemCollection]

	/// Cell 구성 함수
	var configure: (Cell, MPMediaItemCollection) -> Void

	/// Cell을 선택했을 경우 이동할 ViewController
	var detailViewController: (MPMediaItemCollection) -> UIViewController

	/// true일 경우 collectionSections를 사용한다.
	var useSectionIndex: Bool

	var propertyPersistentID: String = MPMediaItemPropertyPersistentID

	/// tableView(_:didSelectRowAt:) 혹은
	/// previewingContext(_:commit:) 등을 사용 할 경우
	/// splitViewController의 여부에 따라 pushViewController 혹은 showDetailViewController를 실행하는 함수이다.
	/// - Parameter vc: Detail을 보여줄 ViewController
	private func presentDetail(_ vc: UIViewController) {
		if let splitViewController = splitViewController {
			let nc = BaseNC(rootViewController: vc)
			splitViewController.showDetailViewController(nc, sender: self)
		} else {
			navigationController?.pushViewController(vc, animated: true)
		}
	}

	// MARK: - 생성자

	init(style: UITableView.Style, mediaQuery: MPMediaQuery, configure: @escaping (Cell, MPMediaItemCollection) -> Void, detailViewController: @escaping (MPMediaItemCollection) -> UIViewController) {
		self.mediaQuery = mediaQuery
		self.collections = mediaQuery.collections ?? []
		self.configure = configure
		self.detailViewController = detailViewController

		// collectionSections가 2개 이상 있을 경우 sectionIndex를 사용함 (예: 재생목록에선 sectionIndex 사용 안 함)
		if let collectionSections = mediaQuery.collectionSections,
			collectionSections.count > 1 {
			// 아이템 20개 이하일 경우, 혹은 정렬을 할 경우에는 섹션을 보여주지 않음
			self.useSectionIndex = (self.collections.count > 20)
		} else {
			self.useSectionIndex = false
		}

		super.init(style: style)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -

	override func viewDidLoad() {
		super.viewDidLoad()

		registerForPreviewing(with: self, sourceView: tableView)

		tableView.emptyDataSetSource = BaseEmptyDataSet.shared
		tableView.emptyDataSetDelegate = BaseEmptyDataSet.shared
		tableView.register(Cell.self, forCellReuseIdentifier: cellReuseIdentifier)

		// searchBar를 정상적으로 보이게하기 위한 코드
		definesPresentationContext = true

		if #available(iOS 11.0, *) {
			navigationItem.searchController = SearchVC.searchController
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		return mediaQuery.collectionSections?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return mediaQuery.collectionSections?[section].range.length ?? 0
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard useSectionIndex else { return nil }
		return mediaQuery.collectionSections?[section].title
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		guard useSectionIndex else { return nil }
		return mediaQuery.collectionSections?.map { $0.title }
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? Cell else { fatalError() }

		let collection = collections[indexPath, for: mediaQuery.collectionSections]
		configure(cell, collection)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let collection = collections[indexPath, for: mediaQuery.collectionSections]

		let vc = detailViewController(collection)
		presentDetail(vc)
	}

	// MARK: - UISwipeActionsConfiguration
	@available(iOS 11.0, *)
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let collection = collections[indexPath, for:
			mediaQuery.collectionSections]

		let actions = ItemCollectionContextualAction.allCases.map {
			$0.contextualAction(for: collection)
		}
		return UISwipeActionsConfiguration(actions: actions)
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let collection = collections[indexPath, for:
			mediaQuery.collectionSections]

		return ItemCollectionContextualAction.allCases.map {
			$0.tableViewRowAction(for: collection)
		}
	}

	// MARK: - UIViewControllerPreviewingDelegate
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let indexPath = tableView.indexPathForRow(at: location) else { return nil }
		previewingContext.sourceRect = tableView.rectForRow(at: indexPath)

		let collection = collections[indexPath, for:
			mediaQuery.collectionSections]

		// collection의 아이템이 없을 경우 nil 반환
		if collection.items.isEmpty { return nil }

		let vc = CollectionPreviewVC(collection: collection)
		return vc
	}

	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		guard let vc = viewControllerToCommit as? CollectionPreviewVC else { return }
		presentDetail(detailViewController(vc.collection))
	}

}
