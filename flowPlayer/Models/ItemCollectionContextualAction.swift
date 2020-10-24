//
//  ItemCollectionContextualAction.swift
//  flowPlayer
//

import MediaPlayer

enum ItemCollectionContextualAction: String, CaseIterable, LibraryContextualAction {
	case playAll
	case shuffleAll

	var localizedTitle: String {
		return rawValue.localized
	}

	var image: UIImage? {
		switch self {
		case .playAll: 		return R.image.contextualAction.play()
		case .shuffleAll: 	return R.image.contextualAction.shuffle()
		}
	}

	var backgroundColor: UIColor? {
		switch self {
		case .playAll: 		return UIColor.ThemeColor.pink
		case .shuffleAll: 	return UIColor.ThemeColor.orange
		}
	}

	/// iOS 11 미만을 위한 UITableViewRowAction 반환
	///
	/// - Note: 일반적으로 tableView(_:editActionsForRowAt:) 에서 사용한다.
	///
	/// - Parameter collection: 이 액션을 사용할 MPMediaItemCollection
	/// - Returns: collection에 적절한 UITableViewRowAction
	func tableViewRowAction(for collection: MPMediaItemCollection) -> UITableViewRowAction {
		let action = UITableViewRowAction(style: .normal, title: localizedTitle) { (_, _) in
			self.handlerAction(for: collection)
		}
		action.backgroundColor = backgroundColor
		return action
	}

	/// iOS 11 이상을 위한 UIContextualAction 반환
	///
	/// - Note: 일반적으로 tableView(_:trailingSwipeActionsConfigurationForRowAt:) 에서 사용한다.
	/// - Parameter collection: 이 액션을 사용할 MPMediaItemCollection
	/// - Returns: collection에 적절한 UIContextualAction
	@available(iOS 11.0, *)
	func contextualAction(for collection: MPMediaItemCollection) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: localizedTitle) { (_, _, completionHandler) in
			self.handlerAction(for: collection)

			completionHandler(true)
		}
		action.image = image
		action.backgroundColor = backgroundColor
		return action
	}

	private func handlerAction(for collection: MPMediaItemCollection) {
		let shuffleMode: MPMusicShuffleMode = (self == .playAll) ? .off : .songs

		MusicPlayerManager.shared.setShuffleMode(shuffleMode)
		MusicPlayerManager.shared.play(with: collection.items)
	}
}
