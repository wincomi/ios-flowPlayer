//
//  SearchResultsController.swift
//  flowPlayer
//

import UIKit
import MediaPlayer

class SearchResultsController: BaseTableVC {
	var cellReuseIdentifier: String = "ItemCell"

	init() {
		super.init(style: .grouped)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// 검색할 탭을 구한다.
	// 사용자가 설정한 탭 순서대로 나온다.
	var searchTabs: [TabType] {
		let tabsToSearch: [TabType] = [/*.playlists, */.albums, .songs, .artists, .genres, .composers]

		return TabManager.shared.getUserTabs().filter {
			tabsToSearch.contains($0)
		}
	}

	var filteredSearchTabs: [TabType] = [.songs]

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
		tableView.register(ArtworkSubtitleCell.self, forCellReuseIdentifier: cellReuseIdentifier)
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return filteredSearchTabs.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return songs?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return filteredSearchTabs[section].viewControllerTitle
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ArtworkSubtitleCell else { fatalError() }

		guard let item = songs?[indexPath.row] else { return cell }
		cell.textLabel?.text = item.getTitle()
		cell.detailTextLabel?.text = item.artist

		let artworkSize = cell.imageView?.bounds.width ?? 0 * UIScreen.main.scale
		cell.imageView?.image = item.artwork?.image(at: CGSize(width: artworkSize, height: artworkSize))

		return cell
	}

	// TODO: - 좀 더 현대적으로
	var songs: [MPMediaItem]?
	var albums: [MPMediaItemCollection]?
	var artists: [MPMediaItemCollection]?
	var genres: [MPMediaItemCollection]?
	var composers: [MPMediaItemCollection]?
}

extension SearchResultsController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text else { return }
		guard !searchText.isEmpty else { return }

		let predicate = MPMediaPropertyPredicate(value: searchText, forProperty: MPMediaItemPropertyTitle, comparisonType: .contains)

		let songsQuery = MPMediaQuery.songs()
		songsQuery.addFilterPredicate(predicate)

		songs = songsQuery.items

		tableView.reloadData()
	}

}

extension SearchResultsController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
		print(selectedScope)
	}

}
