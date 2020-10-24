//
//  MainTabBarController.swift
//  flowPlayer
//

import UIKit
import MediaPlayer
//import SPStorkController
import LNPopupController

class MainTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()

		setUserTabs()

		setupPopupBar()
	}

	/// LNPopupController를 이용한 PopupBar 세팅
	private func setupPopupBar() {
		guard let vc = R.storyboard.main.nowPlayingVC() else { fatalError() }
		vc.delegate = self

		popupBar.tintColor = UIColor.ThemeColor.pink
		popupBar.barStyle = .compact
		popupBar.progressViewStyle = .top
		popupContentView.popupCloseButtonStyle = .chevron
		popupInteractionStyle = .drag

		popupBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]

		presentPopupBar(withContentViewController: vc, animated: true, completion: nil)
	}

	/// MoreVC에서 호출할 수 있음.
	///
	/// - Parameter vc: MoreVC의 NavigationController. 보통 MoreVC에서 self.navigationController로 전달함. 전달하지 않을 경우 새로운 MoreVC가 생성되어 문제가 발생함.
	public func setUserTabs(with vc: UIViewController? = nil) {
		setViewControllers(TabManager.shared.getTabBarControllerTabs().map {
			if let vc = vc, $0 == .more {
				return vc
			}
			return TabManager.shared.viewController(for: $0)
		}, animated: false)
	}

}

extension MainTabBarController: NowPlayingDelegate {
	func presentAlbumVC(of mediaItem: MPMediaItem) {
		let vc = UIViewController()

		if let nc = selectedViewController as? UINavigationController {
			nc.pushViewController(vc, animated: true)
		} else {
			selectedViewController?.present(vc, animated: true)
		}
	}

	func presentArtistVC(of mediaItem: MPMediaItem) {
		let vc = AlbumsVC(artistPersistentID: mediaItem.artistPersistentID, title: mediaItem.artist ?? "")

		if let nc = selectedViewController as? UINavigationController {
			nc.pushViewController(vc, animated: true)
		} else {
			selectedViewController?.present(vc, animated: true)
		}

	}

}
