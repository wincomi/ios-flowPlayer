//
//  ItemsVC.swift
//  flowPlayer
//

import UIKit
import MediaPlayer
import StatusAlert
//import SPStorkController

class ItemsVC: BaseTableVC {
	var cellReuseIdentifier: String = "ItemCell"

	private var mediaQuery: MPMediaQuery?

	/// 정렬하기 전의 items
	private let defaultItems: [MPMediaItem]

	var items: [MPMediaItem] {
		didSet {
			tableView.reloadData()
		}
		// 아래 방법은 스크롤할 때마다 계속 정렬을 하기 때문에 절대 하지 않는다!!
		// get {
		// 	return itemsBeforeSorting.sorted(by: sortingType)
		// }
	}

	/// 현재 ItemsVC의 정렬 방식
	/// - Note: 이 변수를 변경할 경우 tableView.reloadData() 가 호출된다.
	var sortingType: LibrarySorting {
		didSet {
			if sortingType == .default {
				tableSections = defaultTableSections
			} else {
				let sectionTitle = (sortingType == .default) ? nil : "\(R.string.localizable.sortBy()): \(sortingType.title)"
				tableSections = [TableSection(title: sectionTitle, range: 0..<items.count)]
			}

			items = defaultItems.sorted(by: sortingType)
		}
	}

	/// 정렬하기 전의 tableSections
	private var defaultTableSections: [TableSection]
	var tableSections: [TableSection]

	// MARK: - 초기화 함수

	private init(items: [MPMediaItem], tableSections: [TableSection], style: UITableView.Style) {
		self.defaultItems = items
		self.defaultTableSections = tableSections

		self.items = items
		self.tableSections = tableSections

		self.sortingType = .default

		super.init(style: style)
	}

	/// MPMediaItemCollection으로 ItemsVC 생성
	/// itemCollection으로 생성했을 경우 tableSections가 단 한 개!
	init(itemCollection: MPMediaItemCollection, style: UITableView.Style = .grouped) {
		let items = itemCollection.items
		let tableSections = [TableSection(title: nil, range: 0..<items.count)]

		self.defaultItems = items
		self.defaultTableSections = tableSections

		self.items = items
		self.tableSections = tableSections

		self.sortingType = .default

		super.init(style: style)
	}

	/// MPMediaQuery로 ItemsVC 생성
	/// mediaQuery로 생성할 경우 tableSections를 itemSections를 통해 생성한다.
	init(mediaQuery: MPMediaQuery, style: UITableView.Style = .plain) {
		let items = mediaQuery.items ?? []
		let itemSections = mediaQuery.itemSections ?? []
		let tableSections = itemSections.map { TableSection(mediaQuerySection: $0) }

		self.defaultItems = items
		self.defaultTableSections = tableSections

		self.items = items
		self.tableSections = tableSections

		self.sortingType = .default

		super.init(style: style)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: -
	var sortBarButtonItem: UIBarButtonItem {
		let button = UIBarButtonItem(image: R.image.sort.default(), style: .plain) { sender in
			let alert = UIAlertController(title: R.string.localizable.sortBy() + ":", message: nil, preferredStyle: .actionSheet)
			alert.popoverPresentationController?.barButtonItem = sender
			alert.addAction(UIAlertAction.cancelAction)

			let sortingMethods: [LibrarySorting] = [.default, .artist, .albumTitle, .genre, .composer, .rating, .playCount, .lastPlayedDate, .dateAdded, .playbackDuration]
			for method in sortingMethods {
				let action = UIAlertAction(title: method.title, style: .default, handler: { _ in
					self.sortingType = method
				})

				action.image = method.image
				action.checked = (method == self.sortingType)

				alert.addAction(action)
			}

			self.present(alert, animated: true)
		}

		button.accessibilityLabel = R.string.localizable.sortBy()

		return button
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = sortBarButtonItem
		tableView.register(ArtworkSubtitleCell.self, forCellReuseIdentifier: cellReuseIdentifier)
		tableView.emptyDataSetSource = BaseEmptyDataSet.shared
		tableView.emptyDataSetDelegate = BaseEmptyDataSet.shared
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// 아이템이 없을 경우 섹션수 = 0
		guard items.count > 0 else { return 0 }
		return tableSections.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableSections[section].range.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return tableSections[section].title
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		// tableSections이 1개 이하일 경우 오른쪽에 sectionIndexTitles 표시 안 함
		guard tableSections.count > 1 else { return nil }

		// nil을 제외한 title을 sectionIndexTitles에 나타내
		return tableSections.compactMap { $0.title }
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? ArtworkSubtitleCell else { fatalError() }

		let item = items[indexPath, for: tableSections]
		cell.textLabel?.text = item.getTitle()
		cell.detailTextLabel?.text = {
			switch sortingType {
			case .artist:
				return item.artist ?? "알 수 없음"
			case .albumArtist:
				return item.albumArtist ?? "알 수 없음"
			case .albumTitle:
				return item.albumTitle ?? "알 수 없음"
			case .genre:
				return item.genre ?? "알 수 없음"
			case .composer:
				return item.composer ?? "알 수 없음"
			case .rating:
				return (item.rating > 0) ? String(repeating: "★ ", count: item.rating) : "-"
			case .playCount:
				return "\(R.string.localizable.songInfoPlayCount()): \(String(item.playCount))"
//			case .lastPlayedDate:
//			case .dateAdded:
			case .playbackDuration:
				return item.playbackDuration.toString() ?? "알 수 없음"
			case .year:
				guard let year = item.year else { return "알 수 없음" }
				return String(year)
			default:
				return item.artist ?? "알 수 없음"
			}
		}()

		cell.imageView?.image = {
			guard let artwork = item.artwork else { return nil }
			let artworkSize = cell.imageView?.bounds.width ?? 0 * UIScreen.main.scale * 2
			return artwork.image(at: CGSize(width: artworkSize, height: artworkSize))
		}()

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let currLoc = tableSections[indexPath.section].range.first ?? 0

		MusicPlayerManager.shared.play(with: items, at: currLoc + indexPath.row)
		tableView.deselectRow(at: indexPath, animated: true)

		// 만약에 모달일 경우 dismiss
		dismiss(animated: true)
	}
}

// MARK: - 테이블뷰 액션
extension ItemsVC {
	// 음악 정보 보기 액션
	private func infoAction(for indexPath: IndexPath) {
		// let vc = ItemContextualAction.info.itemInfoVC(items: self.items, index: indexPath.row)
		let vc = ItemInfoModal(item: self.items[indexPath.row])

//		let transitionDelegate = vc.transitionDelegate
//		vc.transitioningDelegate = transitionDelegate
//		vc.modalPresentationStyle = .custom

		present(vc, animated: true)
	}

	// 즐겨찾기 액션
	private func addTofavoriteAction(for indexPath: IndexPath) {
		let item = self.items[indexPath, for: self.tableSections]

		guard FavoriteManager.shared.exists(mediaItem: item, in: .song) else { return }

		let statusAlert = StatusAlert()
		statusAlert.title = R.string.localizable.favoriteAddedToFavorites()
		statusAlert.image = R.image.statusAlert.check()
		statusAlert.canBePickedOrDismissed = true
		statusAlert.showInKeyWindow()

		FavoriteManager.shared.add(mediaItem: item, to: .song)
	}

	private func deleteFromFavoriteAction(for indexPath: IndexPath) {
		let item = self.items[indexPath, for: self.tableSections]

		if FavoriteManager.shared.exists(mediaItem: item, in: .song) {
			FavoriteManager.shared.delete(mediaItem: item, from: .song)
		}
	}

	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let item = self.items[indexPath, for: self.tableSections]

		let infoAction = ItemContextualAction.info.tableViewRowAction() { (_, _) in
			self.infoAction(for: indexPath)
		}

		let favoriteAction: UITableViewRowAction = {
			if FavoriteManager.shared.exists(mediaItem: item, in: .song) {
				return ItemContextualAction.deleteFromFavorite.tableViewRowAction() { (_, _) in
					self.deleteFromFavoriteAction(for: indexPath)
				}
			} else {
				return ItemContextualAction.addToFavorite.tableViewRowAction() { (_, _) in
					self.addTofavoriteAction(for: indexPath)
				}
			}
		}()

		return [infoAction, favoriteAction]
	}

	@available(iOS 11.0, *)
	override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let infoAction = ItemContextualAction.info.contextualAction() { (_, _, completionHandler) in
			self.infoAction(for: indexPath)

			completionHandler(true)
		}

		return UISwipeActionsConfiguration(actions: [infoAction])
	}

	@available(iOS 11.0, *)
	override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let item = self.items[indexPath, for: self.tableSections]

		let favoriteAction: UIContextualAction = {
			if FavoriteManager.shared.exists(mediaItem: item, in: .song) {
				return ItemContextualAction.deleteFromFavorite.contextualAction() { (_, _, completionHandler) in
					self.deleteFromFavoriteAction(for: indexPath)

					completionHandler(true)
				}
			} else {
				return ItemContextualAction.addToFavorite.contextualAction() { (_, _, completionHandler) in
					self.addTofavoriteAction(for: indexPath)

					completionHandler(true)
				}

			}
		}()

		return UISwipeActionsConfiguration(actions: [favoriteAction])
	}
}
