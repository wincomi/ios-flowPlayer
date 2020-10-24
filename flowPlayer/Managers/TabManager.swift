//
//  TabManager.swift
//  flowPlayer
//

import MediaPlayer

final class TabManager {
	static let shared = TabManager()

	private init() { }

	/// TabType의 UIViewController
	///
	/// - Parameter type: 탭 타입
	/// - Returns: UITabBarController의 viewControllers에 들어갈 viewController
	public func viewController(for tabType: TabType) -> UIViewController {
		switch tabType {
		case .playlists:
			let vc = PlaylistsVC()
			vc.title = tabType.viewControllerTitle
			return splitViewController(for: tabType, masterViewController: vc)
		case .artists:
			let vc = ArtistsVC()
			vc.title = tabType.viewControllerTitle
			return splitViewController(for: tabType, masterViewController: vc)
		case .genres:
			let vc = GenresVC()
			vc.title = tabType.viewControllerTitle
			return splitViewController(for: tabType, masterViewController: vc)
		case .composers:
			let vc = ComposersVC()
			vc.title = tabType.viewControllerTitle
			return splitViewController(for: tabType, masterViewController: vc)
		case .albums:
			let vc = AlbumsVC()
			vc.title = tabType.viewControllerTitle

			return navigationController(for: tabType, viewController: vc)
		case .songs:
			let mediaQuery = MPMediaQuery.songs()

			let vc = SongsVC(mediaQuery: mediaQuery)
			vc.title = tabType.viewControllerTitle
			return navigationController(for: tabType, viewController: vc)
		case .favorites:
//			let vc = FavoritesVC()
			let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LegacyFavoritesVC")
			vc.title = tabType.viewControllerTitle
			return navigationController(for: tabType, viewController: vc)
		case .files:
			let vc = FilesVC()
			vc.title = tabType.viewControllerTitle
			return navigationController(for: tabType, viewController: vc)
		case .more:
			let vc = MoreVC()
			vc.title = tabType.viewControllerTitle
			return navigationController(for: tabType, viewController: vc)
		}
	}

	private func splitViewController(for tabType: TabType, masterViewController: UIViewController) -> UISplitViewController {
		let splitVC = BaseSplitVC()

		let nc = BaseNC(rootViewController: masterViewController)
		let emptyNC = BaseNC(rootViewController: BaseEmptyVC())
		splitVC.viewControllers = [nc, emptyNC]
		splitVC.tabBarItem = tabType.getTabBarItem()

		return splitVC
	}

	private func navigationController(for tabType: TabType, viewController: UIViewController) -> UINavigationController {
		let nc = BaseNC(rootViewController: viewController)
		nc.tabBarItem = tabType.getTabBarItem()

		return nc
	}

	// MARK: - 유저 커스텀 탭

	static let defaultsKey = "flowPlayerTabs"

	public func saveUserTabs(_ tabs: [TabType]) {
		let rawValues = tabs.map { $0.rawValue }
		UserDefaults.standard.set(rawValues, forKey: TabManager.defaultsKey)
		UserDefaults.standard.synchronize()
	}

	public func getUserTabs() -> [TabType] {
		guard let rawValues = UserDefaults.standard.array(forKey: TabManager.defaultsKey) as? [String] else { return TabType.defaultTabTypes }

		return rawValues.compactMap { TabType(rawValue: $0) }
	}

	public func resetUserTabs() {
		UserDefaults.standard.set(nil, forKey: TabManager.defaultsKey)
		UserDefaults.standard.synchronize()
	}

	/// 항상 5개만 반환됨
	public func getTabBarControllerTabs() -> [TabType] {
		var tabs = Array(getUserTabs()[0..<4])
		tabs.append(.more)
		return tabs
	}

	// MARK: - 레거시 탭을 5.0 탭으로 convert

	private let legacyTabs: [String: TabType] = [
		"PlaylistsNavigationController": TabType.playlists,
		"AlbumsNavigationController": TabType.albums,
		"SongsNavigationController": TabType.songs,
		"FavsNavigationController": TabType.favorites,
		"ArtistsSplitViewController": TabType.artists,
		"GenresSplitViewController": TabType.genres,
		"ComposersSplitViewController": TabType.composers,
		"FilesNavigationController": TabType.files
//		"SearchNavigationController": TabType.search
	]

	/// 레거시 탭을 가져온다.
	///
	/// - Returns: [String] 으로 구성된 레거시 탭
	private func getLegacyTabs() -> [String]? {
		return UserDefaults.standard.object(forKey: "tabs") as? [String]
	}

	private func legacyTabToTabType(_ legacy: String) -> TabType? {
		return legacyTabs[legacy]
	}

	/// 래거시 탭을 5.0 탭으로 변환한다.
	public func convertLegacyTabs() {
		// 레거시 탭을 불러온다. 없을 경우 함수를 실행하지 않는다.
		guard let legacyTabs = getLegacyTabs() else { return }

		// 레거시 탭을 v5.0의 탭으로 변환한다.
		let tabs = legacyTabs.compactMap { legacyTabToTabType($0) }

		// 레거시 탭을 지운다.
		UserDefaults.standard.set(nil, forKey: "tabs")
		UserDefaults.standard.synchronize()

		// v5.0의 탭을 저장한다.
		saveUserTabs(tabs)
	}
}
