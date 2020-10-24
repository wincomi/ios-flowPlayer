//
//  ItemContextualAction.swift
//  flowPlayer
//

import MediaPlayer

enum ItemContextualAction: String, LibraryContextualAction {
	case info
	case addToFavorite
	case deleteFromFavorite

	var localizedTitle: String {
		return rawValue.localized
	}

	var image: UIImage? {
		switch self {
		case .info:
			return R.image.contextualAction.info()
		case .addToFavorite:
			return R.image.contextualAction.favorite()
		case .deleteFromFavorite:
			return R.image.contextualAction.remove()
		}
	}

	var backgroundColor: UIColor? {
		switch self {
		case .info:
			return nil
		case .addToFavorite, .deleteFromFavorite:
			return UIColor.ThemeColor.yellow
		}
	}

	// iOS 10을 위한 함수
	func tableViewRowAction(_ handler: @escaping (UITableViewRowAction, IndexPath) -> Void) -> UITableViewRowAction {
		let action = UITableViewRowAction(style: .normal, title: localizedTitle, handler: handler)
		action.backgroundColor = backgroundColor
		return action
	}

	@available(iOS 11.0, *)
	func contextualAction(_ handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: localizedTitle, handler: handler)
		action.image = image
		action.backgroundColor = backgroundColor
		return action
	}

}
