//
//  SearchVC.swift
//  flowPlayer
//

import Foundation

class SearchVC: BaseTableVC {

	static var searchController: UISearchController {
		let searchResultsController = SearchResultsController()
		let searchController = UISearchController(searchResultsController: searchResultsController)
		searchController.searchResultsUpdater = searchResultsController
		searchController.searchBar.delegate = searchResultsController
		// searchController.searchBar.scopeButtonTitles = ["전체 보관함", "현재 탭"]
		searchController.searchBar.returnKeyType = .search
		return searchController
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		title = R.string.localizable.search()

		// searchBar를 정상적으로 보이게하기 위한 코드
		definesPresentationContext = true

		// TODO: iOS 10
		if #available(iOS 11.0, *) {
			navigationItem.searchController = SearchVC.searchController
		} else {
			tableView.tableHeaderView = SearchVC.searchController.searchBar
		}
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if #available(iOS 11.0, *) {
			navigationItem.hidesSearchBarWhenScrolling = false
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if #available(iOS 11.0, *) {
			navigationItem.hidesSearchBarWhenScrolling = true
		}
	}

}
